from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import User

class UserSignupSerializer(serializers.ModelSerializer) :
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = (
            'email', 'name', 'password',
            'gender', 'age', 'height',
            'current_weight', 'target_weight', 'diet_plan'
        )

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user
    
class UserLoginSerializer(serializers.Serializer) :
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        user = authenticate(email=data['email'], password=data['password'])
        if not user:
            raise serializers.ValidationError("이메일 또는 비밀번호가 올바르지 않습니다.")
        data['user'] = user
        return data
    
    
class UserNameUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ("name",)

    def validate_name(self, value):
        if not value or not str(value).strip():
            raise serializers.ValidationError("이름을 입력해주세요.")
        return str(value).strip()


class PasswordChangeSerializer(serializers.Serializer):
    current_password = serializers.CharField(write_only=True)
    new_password = serializers.CharField(write_only=True)

    def validate(self, data):
        user = self.context.get("user")
        if user is None:
            raise serializers.ValidationError("사용자 컨텍스트가 필요합니다.")

        current = data.get("current_password")
        new = data.get("new_password")

        if not user.check_password(current):
            raise serializers.ValidationError("현재 비밀번호가 올바르지 않습니다.")
        if current == new:
            raise serializers.ValidationError("새 비밀번호가 현재 비밀번호와 같습니다.")
        if new is None or len(new) < 8:
            raise serializers.ValidationError("새 비밀번호는 8자 이상이어야 합니다.")
        return data


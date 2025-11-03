from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.schemas import openapi
from rest_framework.authentication import SessionAuthentication
from rest_framework.permissions import IsAuthenticated
from drf_yasg.utils import swagger_auto_schema
from .serializers import (
    UserSignupSerializer,
    UserLoginSerializer,
    UserNameUpdateSerializer,
    PasswordChangeSerializer,
)
from django.contrib.auth import login, logout

class UserSignupView(APIView) :
    @swagger_auto_schema(request_body=UserSignupSerializer)
    def post(self, request) :
        serializer = UserSignupSerializer(data = request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'message' : '회원가입 성공!' }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class UserLoginView(APIView) :
    @swagger_auto_schema(request_body=UserLoginSerializer)
    def post(self, request) :
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data['user']
            login(request, user)
            return Response({
                'message' : '로그인 성공!',
                'email' : user.email,
                'name' : user.name,
            },status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class UserNameUpdateView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(request_body=UserNameUpdateSerializer)
    def patch(self, request):
        serializer = UserNameUpdateSerializer(
            instance=request.user, data=request.data, partial=True
        )
        if serializer.is_valid():
            serializer.save()
            return Response(
                {"message": "이름 변경 성공!", "name": serializer.instance.name},
                status=status.HTTP_200_OK,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PasswordChangeView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(request_body=PasswordChangeSerializer)
    def post(self, request):
        serializer = PasswordChangeSerializer(
            data=request.data, context={"user": request.user}
        )
        if serializer.is_valid():
            user = request.user
            # set_password()만 호출하면 자동 로그아웃됨
            user.set_password(serializer.validated_data["new_password"])
            user.save()
            return Response(
                {"message": "비밀번호 변경 성공!"}, status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserLogoutView(APIView):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(request_body=None)
    def post(self, request):
        logout(request)
        resp = Response({"message": "로그아웃 성공!"}, status=status.HTTP_200_OK)
        resp.delete_cookie("sessionid")
        resp.delete_cookie("csrftoken")
        return resp

class SignupData {
  final String email;
  final String name;
  final String password;
  final String gender; // 'M' or 'F'
  final int age;
  final double height;
  final double currentWeight;
  final double targetWeight;
  final String dietPlan; // 'normal' or 'exercise'

  SignupData({
    required this.email,
    required this.name,
    required this.password,
    required this.gender,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.targetWeight,
    required this.dietPlan,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'password': password,
        'gender': gender,
        'age': age,
        'height': height,
        'current_weight': currentWeight,
        'target_weight': targetWeight,
        'diet_plan': dietPlan,
      };
}

// setup_screen.dart

import 'package:flutter/material.dart';
import '../models/signup_data.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isMale = true;
  bool isBalancedDiet = true;

  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final startWeightController = TextEditingController();
  final goalWeightController = TextEditingController();

  bool get isFormFilled {
    return emailController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        ageController.text.trim().isNotEmpty &&
        heightController.text.trim().isNotEmpty &&
        startWeightController.text.trim().isNotEmpty &&
        goalWeightController.text.trim().isNotEmpty &&
        isMale != null &&
        isBalancedDiet != null;
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateState);
    nameController.addListener(_updateState);
    passwordController.addListener(_updateState);
    ageController.addListener(_updateState);
    heightController.addListener(_updateState);
    startWeightController.addListener(_updateState);
    goalWeightController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    ageController.dispose();
    heightController.dispose();
    startWeightController.dispose();
    goalWeightController.dispose();
    super.dispose();
  }

  SignupData? _buildSignupData() {
    final age = int.tryParse(ageController.text.trim());
    final height = double.tryParse(heightController.text.trim());
    final currentWeight = double.tryParse(startWeightController.text.trim());
    final targetWeight = double.tryParse(goalWeightController.text.trim());
    if (age == null || height == null || currentWeight == null || targetWeight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('숫자 입력란을 확인해주세요.')),
      );
      return null;
    }
    return SignupData(
      email: emailController.text.trim(),
      name: nameController.text.trim(),
      password: passwordController.text.trim(),
      gender: isMale ? 'M' : 'F',
      age: age,
      height: height,
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      dietPlan: isBalancedDiet ? 'normal' : 'exercise',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF98F6C8),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('계정 정보', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInputField("이메일", emailController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _buildInputField("이름", nameController),
                  const SizedBox(height: 12),
                  _buildInputField("비밀번호", passwordController, obscureText: true),
                  const SizedBox(height: 24),

                  const Text('기본 정보', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  // 성별
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCircleButton("남자", isMale, () => setState(() => isMale = true)),
                      const SizedBox(width: 20),
                      _buildCircleButton("여자", !isMale, () => setState(() => isMale = false)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 나이, 키
                  Row(
                    children: [
                      Expanded(child: _buildInputField("나이", ageController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInputField("키", heightController)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 시작체중, 목표체중
                  Row(
                    children: [
                      Expanded(child: _buildInputField("시작체중", startWeightController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInputField("목표체중", goalWeightController)),
                    ],
                  ),
                  const SizedBox(height: 40),

                  const Text('식단 계획', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  // 식단 선택
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCircleButton("일반식", isBalancedDiet, () => setState(() => isBalancedDiet = true)),
                      const SizedBox(width: 20),
                      _buildCircleButton("운동", !isBalancedDiet, () => setState(() => isBalancedDiet = false)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 설명 텍스트
                  Center(
                    child: Text(
                      isBalancedDiet
                          ? "균형잡힌 탄단지!"
                          : "탄수화물, 지방은 적게!\n단백질은 많게!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 100), // 아래 버튼 공간 확보
                ],
              ),
            ),

            // 다음 버튼
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                heroTag: 'setupNextButton', 
                onPressed: isFormFilled
                    ? () {
                        final data = _buildSignupData();
                        if (data != null) {
                          Navigator.pushNamed(context, '/nextSetup', arguments: data);
                        }
                      }
                    : null,
                backgroundColor: isFormFilled ? const Color(0xFF2DB65A) : Colors.grey[400],
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 둥근 선택 버튼
  Widget _buildCircleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.black54,
          ),
        ),
      ),
    );
  }

  // 입력 필드
  Widget _buildInputField(String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

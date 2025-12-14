
import 'package:flutter/material.dart';

import '../camera_screen.dart'; // CameraScreen
import '../../models/ai_mode.dart'; // AiMode

import 'widgets/date_selector.dart';
import 'widgets/calorie_display.dart';
import 'widgets/macro_progress_bar.dart';
import 'widgets/meal_card.dart';
import 'widgets/bottom_nav_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 📌 AI 선택 팝업 (다이얼로그로 구현)
  void showAiSelectDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      // 외부를 어둡게 처리
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (dialogContext) { // 빌더 컨텍스트 이름을 dialogContext로 명확히 지정
        return Center(
          child: Container(
            width: 260,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogButton(
                  text: '음식 AI 검사',
                  onTap: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CameraScreen(mode: AiMode.food),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _DialogButton(
                  text: '영양 성분 OCR',
                  onTap: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CameraScreen(mode: AiMode.ocr),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 상태 값들
  DateTime _selectedDate = DateTime.now();

  final int _targetCalories = 2237;
  int _currentCalories = 0;

  final int _targetCarbs = 319;
  int _currentCarbs = 145;

  final int _targetProtein = 120;
  int _currentProtein = 20;

  final int _targetFat = 62;
  int _currentFat = 4;

  void _onDateSelected(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _onMealCardTapped(String mealType) {
    showAiSelectDialog();
  }

  String _getImagePathForMeal(String mealType) {
    switch (mealType) {
      case '아침':
        return 'assets/images/image-removebg-preview (3).png';
      case '점심':
        return 'assets/images/lunch.png';
      case '저녁':
        return 'assets/images/moon.png';
      case '간식':
        return 'assets/images/cherry.png';
      default:
        return 'assets/images/fork_logo_white.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFA1FFD1),
      body: SafeArea(
        child: Column(
          children: [
            DateSelector(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),

                    CalorieDisplay(
                      currentCalories: _currentCalories,
                      targetCalories: _targetCalories,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MealCard(
                          mealType: '아침',
                          imagePath: _getImagePathForMeal('아침'),
                          onTap: () => _onMealCardTapped('아침'),
                        ),
                        MealCard(
                          mealType: '점심',
                          imagePath: _getImagePathForMeal('점심'),
                          onTap: () => _onMealCardTapped('점심'),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MealCard(
                          mealType: '저녁',
                          imagePath: _getImagePathForMeal('저녁'),
                          onTap: () => _onMealCardTapped('저녁'),
                        ),
                        MealCard(
                          mealType: '간식',
                          imagePath: _getImagePathForMeal('간식'),
                          onTap: () => _onMealCardTapped('간식'),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          MacroProgressBar(
                            label: '탄수화물',
                            current: _currentCarbs,
                            target: _targetCarbs,
                            unit: 'g',
                          ),
                          const SizedBox(height: 20),
                          MacroProgressBar(
                            label: '단백질',
                            current: _currentProtein,
                            target: _targetProtein,
                            unit: 'g',
                          ),
                          const SizedBox(height: 20),
                          MacroProgressBar(
                            label: '지방',
                            current: _currentFat,
                            target: _targetFat,
                            unit: 'g',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomNavBar(
              onTap: (index) {
                // BottomNavBar의 인덱스 0 ('음식 AI 검사')를 탭했을 때
                if (index == 0) {
                  showAiSelectDialog();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _DialogButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFA1FFD1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black, 
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
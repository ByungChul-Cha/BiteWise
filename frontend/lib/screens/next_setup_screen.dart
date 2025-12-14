import 'package:flutter/material.dart';

class NextSetupScreen extends StatefulWidget {
  const NextSetupScreen({super.key});

  @override
  State<NextSetupScreen> createState() => _NextSetupScreenState();
}

class _NextSetupScreenState extends State<NextSetupScreen> {
  String _calories = '2500kcal';
  String _carbs = '200g';
  String _protein = '100g';
  String _fat = '50g';

  Future<void> _showEditDialog(BuildContext context, String label, String currentValue) async {
    final TextEditingController controller = TextEditingController(text: currentValue);

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(label),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "새로운 값을 입력하세요"),
            keyboardType: TextInputType.number, // 숫자 키보드
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                setState(() {
                  final newValue = controller.text;
                  if (label == '목표 칼로리') {
                    _calories = newValue;
                  } else if (label == '목표 탄수화물') {
                    _carbs = newValue;
                  } else if (label == '목표 단백질') {
                    _protein = newValue;
                  } else if (label == '목표 지방') {
                    _fat = newValue;
                  }
                });
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF98F6C8),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '추천 계획 완성!\n직접 바꾸실 수도 있어요!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          '기초대사량 : 2000kcal',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.1),

                    const Center(
                      child: Text(
                        '바이트와이즈가 추천하는\n하루 권장 영양성분',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          _buildNutrientRow(context, '목표 칼로리', _calories),
                          const SizedBox(height: 16),
                          _buildNutrientRow(context, '목표 탄수화물', _carbs),
                          const SizedBox(height: 16),
                          _buildNutrientRow(context, '목표 단백질', _protein),
                          const SizedBox(height: 16),
                          _buildNutrientRow(context, '목표 지방', _fat),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            
            Positioned(
              bottom: 30,
              left: 30,
              child: FloatingActionButton(
                heroTag: 'backButtonTag',
                onPressed: () {
                  Navigator.pop(context);
                  
                },
                backgroundColor: Colors.grey[400], // 회색으로 설정
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                heroTag: 'nextButtonTag',
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                backgroundColor: const Color(0xFF2DB65A),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                _showEditDialog(context, label, value);
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF2DB65A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('목표 수정'),
            ),
          ],
        ),
      ],
    );
  }
}
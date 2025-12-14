import 'package:flutter/material.dart';

class CalorieDisplay extends StatelessWidget {
  final int currentCalories;
  final int targetCalories;

  const CalorieDisplay({
    super.key,
    required this.currentCalories,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가로로 중앙 정렬
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$currentCalories',
            style: const TextStyle(
              fontSize: 60, // 현재 칼로리는 큰 글씨 유지
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            '/$targetCalories kcal',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3D8D66),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ai_mode.dart';

class CameraScreen extends StatelessWidget {
  final AiMode mode;

  const CameraScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _openCamera(context),
        builder: (context, snapshot) {
          return const SizedBox(); // UI 없음 (OS 카메라만)
        },
      ),
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      Navigator.pop(context); // 촬영 취소
      return;
    }

    // 🔽 여기서 분기
    if (mode == AiMode.food) {
      // 음식 AI API 호출
    } else {
      // OCR API 호출
    }

    Navigator.pop(context);
  }
}

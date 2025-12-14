import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  bool _isLoading = false;

  bool get _isFormValid =>
      _idController.text.trim().isNotEmpty && _pwController.text.trim().isNotEmpty;

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isSheetActive(BuildContext context) {
    return context is Element && context.mounted;
  }

  String _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] is String) {
          return decoded['message'] as String;
        }
        if (decoded.isNotEmpty) {
          final firstValue = decoded.values.first;
          if (firstValue is List && firstValue.isNotEmpty) {
            return firstValue.first.toString();
          }
          if (firstValue is String) {
            return firstValue;
          }
        }
      }
    } catch (_) {}
    return '로그인에 실패했어요. 이메일/비밀번호를 확인해주세요.';
  }

  Future<void> _handleLogin(BuildContext sheetContext, StateSetter sheetSetState) async {
    if (_isLoading) return;

    sheetSetState(() => _isLoading = true);

    try {
      final response = await http.post(
        loginUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _idController.text.trim(),
          'password': _pwController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(sheetContext);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return;
      }

      final message = _extractErrorMessage(response.body);
      _showError(sheetContext, message);
    } catch (_) {
      _showError(sheetContext, '로그인 요청에 실패했어요. 네트워크를 확인해주세요.');
    }

    if (!_isSheetActive(sheetContext)) return;
    sheetSetState(() => _isLoading = false);
  }

  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('로그인', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _idController,
                    onChanged: (_) => setState(() {}),
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      hintText: '아이디를 입력해주세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pwController,
                    onChanged: (_) => setState(() {}),
                    obscureText: true,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 입력해주세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('아이디 찾기', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(' | ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('비밀번호 찾기', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isFormValid && !_isLoading
                        ? () => _handleLogin(context, setState)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DB65A),
                      minimumSize: const Size.fromHeight(48),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('로그인', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 100,
            left: 40,
            right: 40,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showLoginBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2DB65A),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("로그인",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    print('?? 회원가입 버튼 눌림');
                    Navigator.pushNamed(context, '/setup');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("회원가입",
                      style: TextStyle(color: Color(0xFF2DB65A), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

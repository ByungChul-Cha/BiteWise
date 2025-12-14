import 'package:flutter/material.dart';
// intl 패키지의 초기화 라이브러리 import 추가
import 'package:intl/date_symbol_data_local.dart'; 
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/next_setup_screen.dart'; 
import 'screens/home_screen/home_screen.dart'; 

// 1. main 함수를 async로 변경
void main() async {
  // 2. runApp 전에 Flutter 엔진이 초기화되었는지 확인 (비동기 main의 필수 과정)
  WidgetsFlutterBinding.ensureInitialized();

  // 3. 한국어 날짜/시간 포맷 데이터를 초기화
  await initializeDateFormatting('ko_KR', null);

  runApp(const BiteWiseApp());
}

class BiteWiseApp extends StatelessWidget {
  const BiteWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiteWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/setup': (context) => const SetupScreen(),
        '/nextSetup': (context) => const NextSetupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
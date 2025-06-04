import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  
  // Cek apakah user sudah pernah input data
  String? name = prefs.getString('userName');
  String? birthDate = prefs.getString('userBirthDate');
  
  // Inisialisasi UserModel dengan data dari SharedPreferences jika ada
  if (name != null && birthDate != null) {
    UserModel().name = name;
    UserModel().birthDate = DateTime.parse(birthDate);
  }
  
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  
  const MyApp({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pustaka Jawa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isFirstTime ? OnboardingScreen() : HomeScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'models/user_model.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
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
/*************  ✨ Windsurf Command ⭐  *************/
/// Builds the main application widget.
/// 

/*******  677f38c1-910b-4b4b-a849-d049aa4c819d  *******/
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pustaka Jawa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isFirstTime ? OnboardingScreen() : HomeScreen(),
    );
  }
}
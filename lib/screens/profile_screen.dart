import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utils/theme.dart';
import '../models/user_model.dart';
import '../utils/weton_calculator.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserModel _userModel = UserModel();
  String _weton = '';
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    if (_userModel.birthDate != null) {
      final weton = WetonCalculator.calculateWeton(_userModel.birthDate!);
      debugPrint('Weton: ${weton.dayName} ${weton.pasaranName}');
      setState(() {
        _weton = '${weton.dayName} ${weton.pasaranName}';
        _userModel.weton = _weton;
        _userModel.neptuValue = weton.totalNeptu;
        debugPrint('weton: ${_userModel.weton}');
        debugPrint('weton: $_weton');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _userModel.name.isNotEmpty
                                  ? _userModel.name
                                      .substring(0, 1)
                                      .toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User Info
                        Text(
                          _userModel.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _userModel.birthDate != null
                              ? _dateFormat.format(_userModel.birthDate!)
                              : '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Weton Info
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weton Kelahiran',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _weton,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _userModel.neptuValue?.toString() ?? '-',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Menu Items
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit, color: AppColors.primary),
                        title: Text('Edit Profil'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implement edit profile
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.bookmark, color: AppColors.primary),
                        title: Text('Perhitungan Tersimpan'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implement saved calculations
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color: AppColors.primary,
                        ),
                        title: Text('Notifikasi'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implement notifications settings
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.help, color: AppColors.primary),
                        title: Text('Bantuan'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implement help
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.info, color: AppColors.primary),
                        title: Text('Tentang Aplikasi'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implement about
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _resetUserData,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('Reset Data'),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetUserData() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Reset Data'),
            content: Text('Apakah Anda yakin ingin menghapus semua data Anda?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isFirstTime', true);
                  await prefs.remove('userName');
                  await prefs.remove('userBirthDate');

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => OnboardingScreen()),
                  );
                },
                child: Text('Ya, Reset', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}

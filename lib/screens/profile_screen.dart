// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utils/theme.dart';
import '../models/user_model.dart';
import '../utils/weton_calculator.dart';
import 'onboarding_screen.dart';
import 'saved_calculations_screen.dart';
import 'edit_profile_screen.dart'; 
import 'notification_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onProfileUpdate; // Tambahkan callback

  const ProfileScreen({Key? key, this.onProfileUpdate}) : super(key: key);

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
      setState(() {
        _weton = '${weton.dayName} ${weton.pasaranName}';
        _userModel.weton = _weton;
        _userModel.neptuValue = weton.totalNeptu;
      });
    } else {
      setState(() {
        _weton = 'Belum dihitung';
        _userModel.weton = null;
        _userModel.neptuValue = null;
      });
    }
    // Panggil setState untuk memastikan UI nama & tanggal lahir juga diperbarui
    setState(() {}); 
    // Panggil callback jika ada, untuk memberitahu HomeScreen agar memuat ulang juga
    if (widget.onProfileUpdate != null) {
      widget.onProfileUpdate!();
    }
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );

    if (result == true) {
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: ConstrainedBox( // Tambahkan ConstrainedBox
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         (AppBar().preferredSize.height + MediaQuery.of(context).padding.top + kBottomNavigationBarHeight),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Atur spacing
                children: [
                  Column( // Kolom untuk konten utama (profil dan menu)
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
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
                                        ? _userModel.name.substring(0, 1).toUpperCase()
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
                              Text(
                                _userModel.name.isNotEmpty ? _userModel.name : "Nama Pengguna",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                key: ValueKey(_userModel.name), // Key untuk update
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _userModel.birthDate != null
                                    ? _dateFormat.format(_userModel.birthDate!)
                                    : 'Tanggal lahir belum diatur',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                key: ValueKey(_userModel.birthDate), // Key untuk update
                              ),
                              const SizedBox(height: 16),
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
                                          key: ValueKey(_weton), // Key untuk update
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
                              onTap: _navigateToEditProfile,
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Icon(Icons.bookmark, color: AppColors.primary),
                              title: Text('Perhitungan Tersimpan'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SavedCalculationsScreen()),
                                );
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
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                                 );
                              },
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Icon(Icons.help, color: AppColors.primary),
                              title: Text('Bantuan'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fitur Bantuan belum tersedia.')),
                                );
                              },
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Icon(Icons.info, color: AppColors.primary),
                              title: Text('Tentang Aplikasi'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Aplikasi Pustaka Jawa v1.0.0')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding( // Padding untuk tombol reset
                    padding: const EdgeInsets.only(top: 24.0), // Beri jarak dari atas
                    child: SizedBox(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetUserData() async {
    bool? confirmReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Data'),
        content: Text(
            'Apakah Anda yakin ingin menghapus semua data Anda? Ini juga akan menghapus perhitungan yang tersimpan dan pengaturan notifikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true); // Konfirmasi reset
            },
            child: Text('Ya, Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmReset == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', true);
      await prefs.remove('userName');
      await prefs.remove('userBirthDate');
      await prefs.remove('savedCalculations');
      await prefs.remove('notificationsEnabled');
      await prefs.remove('goodDayNotificationsEnabled');


      _userModel.name = '';
      _userModel.birthDate = null;
      _userModel.weton = null;
      _userModel.neptuValue = null;
      
      _loadUserData(); // Untuk update UI ProfileScreen sebelum navigasi

      // Tunggu sebentar agar state ProfileScreen sempat di-reset sebelum navigasi
      await Future.delayed(Duration(milliseconds: 100));


      if (mounted) { // Pastikan widget masih ada di tree
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
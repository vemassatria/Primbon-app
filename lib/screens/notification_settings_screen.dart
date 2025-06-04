import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _notificationsEnabled = true; // Default value

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Ambil nilai, jika tidak ada, default ke true
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _updateNotificationSetting(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Notifikasi ${value ? "diaktifkan" : "dinonaktifkan"}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Aktifkan Notifikasi'),
            subtitle: const Text('Terima pemberitahuan penting dan pengingat.'),
            value: _notificationsEnabled,
            onChanged: _updateNotificationSetting,
            activeColor: Theme.of(context).primaryColor,
          ),
          Divider(),
          ListTile(
            title: Text('Notifikasi Hari Baik'),
            subtitle: Text('Dapatkan pengingat untuk hari-hari baik Anda.'),
            trailing: Switch(
              value: _notificationsEnabled ? true : false, // Contoh, bisa dibuat terpisah
              onChanged: _notificationsEnabled ? (value) {
                // Logika spesifik untuk notifikasi hari baik
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pengaturan Notifikasi Hari Baik ${value ? "diaktifkan" : "dinonaktifkan"}')),
                );
              } : null, // Nonaktifkan jika notifikasi utama mati
            ),
          ),
          // Anda bisa menambahkan pengaturan notifikasi lainnya di sini
        ],
      ),
    );
  }
}
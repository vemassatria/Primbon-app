import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Untuk format tanggal

class SavedCalculationsScreen extends StatefulWidget {
  const SavedCalculationsScreen({Key? key}) : super(key: key);

  @override
  _SavedCalculationsScreenState createState() => _SavedCalculationsScreenState();
}

class _SavedCalculationsScreenState extends State<SavedCalculationsScreen> {
  List<Map<String, dynamic>> _savedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedItems();
  }

  Future<void> _loadSavedItems() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> itemsString = prefs.getStringList('savedCalculations') ?? [];
    
    // Urutkan berdasarkan timestamp terbaru di atas
    List<Map<String, dynamic>> loadedItems = itemsString.map((item) {
      return json.decode(item) as Map<String, dynamic>;
    }).toList();

    loadedItems.sort((a, b) {
      DateTime dateA = DateTime.parse(a['timestamp']);
      DateTime dateB = DateTime.parse(b['timestamp']);
      return dateB.compareTo(dateA); // Terbaru di atas
    });

    setState(() {
      _savedItems = loadedItems;
      _isLoading = false;
    });
  }

  Future<void> _deleteItem(int index) async {
    // Tampilkan dialog konfirmasi
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Perhitungan?'),
          content: Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> itemsString = prefs.getStringList('savedCalculations') ?? [];
      
      // Cari item yang sesuai untuk dihapus berdasarkan timestamp (atau ID unik jika ada)
      // Untuk contoh ini, kita hapus berdasarkan data yang sama persis, tapi ini kurang ideal.
      // Cara yang lebih baik adalah jika setiap item punya ID unik saat disimpan.
      // Namun, untuk kesederhanaan, kita cari dan hapus satu item yang cocok.
      
      // Karena kita sudah urutkan _savedItems, kita bisa menggunakan index jika
      // urutan di SharedPreferences juga konsisten atau jika kita save ulang seluruh list.
      // Mari kita save ulang seluruh list setelah menghapus dari _savedItems.
      
      _savedItems.removeAt(index);
      
      List<String> updatedItemsString = _savedItems.map((item) => json.encode(item)).toList();
      await prefs.setStringList('savedCalculations', updatedItemsString);
      
      _loadSavedItems(); // Muat ulang untuk refresh tampilan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item dihapus')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perhitungan Tersimpan'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _savedItems.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada perhitungan yang disimpan.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  itemCount: _savedItems.length,
                  itemBuilder: (context, index) {
                    final item = _savedItems[index];
                    final DateTime timestamp = DateTime.parse(item['timestamp']);
                    final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(timestamp);
                    IconData iconData = item['type'] == 'weton' 
                                        ? Icons.calendar_today 
                                        : Icons.favorite_border;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(iconData, color: Theme.of(context).primaryColor),
                        title: Text(item['displayName'] ?? 'Data Tidak Lengkap'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Disimpan: $formattedDate'),
                            if (item['type'] == 'weton')
                               Text('Neptu: ${item['details']?['totalNeptu'] ?? '-'}'),
                            if (item['type'] == 'compatibility')
                               Text('Kecocokan: ${item['details']?['totalCompatibility']?.round() ?? '-'}%'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _deleteItem(index),
                        ),
                        onTap: () {
                          // TODO: Mungkin tampilkan detail lengkap perhitungan saat di-tap
                          // Ini bisa dilakukan dengan navigasi ke layar detail baru
                          // atau menampilkan dialog dengan informasi lebih banyak.
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(item['displayName'] ?? 'Detail'),
                              content: SingleChildScrollView(
                                child: Text(JsonEncoder.withIndent('  ').convert(item['details'])),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
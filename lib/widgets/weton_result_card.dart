import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini
import 'dart:convert'; // Tambahkan ini
import '../utils/theme.dart';
import '../models/weton_model.dart';

class WetonResultCard extends StatelessWidget {
  final WetonModel weton;
  final String name;

  const WetonResultCard({Key? key, required this.weton, required this.name})
    : super(key: key);

  // Fungsi untuk menyimpan perhitungan
  Future<void> _saveCalculation(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedItemsString = prefs.getStringList('savedCalculations') ?? [];
    
    final Map<String, dynamic> calculationData = {
      'type': 'weton',
      'timestamp': DateTime.now().toIso8601String(),
      'displayName': '$name - ${weton.dayName} ${weton.pasaranName}',
      'details': {
        'name': name,
        'dayName': weton.dayName,
        'pasaranName': weton.pasaranName,
        'totalNeptu': weton.totalNeptu,
        'traits': weton.traits,
        // Anda bisa tambahkan detail lain dari weton model jika perlu
      }
    };
    
    savedItemsString.add(json.encode(calculationData)); // Encode Map ke String JSON
    await prefs.setStringList('savedCalculations', savedItemsString);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hasil perhitungan untuk $name disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (kode header dan tampilan lainnya tetap sama) ...
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Hasil Perhitungan Weton',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Weton Result
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weton Kelahiran',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${weton.dayName} ${weton.pasaranName}',
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
                        weton.totalNeptu.toString(),
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
            const SizedBox(height: 16),

            // Neptu Details
            Text(
              'Neptu (Nilai Hari)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Hari',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${weton.dayName} = ${weton.dayValue}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Pasaran',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${weton.pasaranName} = ${weton.pasaranValue}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weton.totalNeptu.toString(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Character Traits
            Text(
              'Watak & Karakter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              weton.traits,
              style: TextStyle(fontSize: 14, color: AppColors.dark),
            ),
            const SizedBox(height: 16),

            // Fortune Details
            Text(
              'Peruntungan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: [
                _buildFortuneItem('Arah Baik', weton.goodDirections.join(', ')),
                _buildFortuneItem('Hari Baik', weton.goodDays.join(', ')),
                _buildFortuneItem('Sifat Rejeki', weton.fortuneType),
                _buildFortuneItem(
                  'Warna Keberuntungan',
                  weton.luckyColors.join(', '),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _saveCalculation(context); // Panggil fungsi simpan
                    },
                    icon: Icon(Icons.bookmark_border),
                    label: Text('Simpan'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _shareResult();
                    },
                    icon: Icon(Icons.share),
                    label: Text('Bagikan'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFortuneItem(String title, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _shareResult() {
    final String shareText = '''
Hasil Perhitungan Weton - Pustaka Jawa

Nama: $name
Weton: ${weton.dayName} ${weton.pasaranName}
Neptu: ${weton.totalNeptu}

Watak & Karakter:
${weton.traits}

Arah Baik: ${weton.goodDirections.join(', ')}
Hari Baik: ${weton.goodDays.join(', ')}
Sifat Rejeki: ${weton.fortuneType}
Warna Keberuntungan: ${weton.luckyColors.join(', ')}

- Dihitung menggunakan aplikasi Pustaka Jawa
''';

    Share.share(shareText);
  }
}
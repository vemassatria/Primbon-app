import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/theme.dart';
import '../models/compatibility_model.dart';

class CompatibilityResultCard extends StatelessWidget {
  final CompatibilityModel compatibility;

  const CompatibilityResultCard({Key? key, required this.compatibility})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Text(
                    'Hasil Kecocokan Jodoh',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Berdasarkan Bibit, Bebet, Bobot',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Couple Icons
            Center(
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Person 1
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.loveColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            compatibility.person1Name.isNotEmpty
                                ? _getInitials(compatibility.person1Name)
                                : 'P1',
                            style: TextStyle(
                              color: AppColors.loveColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 56),
                      // Person 2
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            compatibility.person2Name.isNotEmpty
                                ? _getInitials(compatibility.person2Name)
                                : 'P2',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.loveColor,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Compatibility Score
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.loveColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Kecocokan ${compatibility.totalCompatibility.round()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getCompatibilityLevel(compatibility.totalCompatibility),
                    style: TextStyle(
                      color: AppColors.loveColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Progress Bar
            Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                widthFactor: compatibility.totalCompatibility / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.loveColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bibit, Bebet, Bobot Scores
            Row(
              children: [
                Expanded(
                  child: _buildScoreItem(
                    'Bibit',
                    compatibility.bibitScore.round(),
                    AppColors.loveColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildScoreItem(
                    'Bebet',
                    compatibility.bebetScore.round(),
                    AppColors.loveColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildScoreItem(
                    'Bobot',
                    compatibility.bobotScore.round(),
                    AppColors.loveColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weton Information
            Text(
              'Weton Pasangan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Person 1 Weton
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.loveColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          compatibility.person1Name,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          compatibility.person1Weton,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Neptu: ${compatibility.person1Neptu}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Person 2 Weton
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          compatibility.person2Name,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          compatibility.person2Weton,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Neptu: ${compatibility.person2Neptu}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Interpretation
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interpretasi Hasil',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    compatibility.interpretation,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Suggestions
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saran untuk Pasangan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: compatibility.suggestions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• '),
                            Expanded(
                              child: Text(
                                compatibility.suggestions[index],
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement save functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hasil perhitungan disimpan')),
                      );
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
                      backgroundColor: AppColors.loveColor,
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

  Widget _buildScoreItem(String title, int score, Color color) {
    String scoreLevel = 'Cukup Cocok';
    if (score >= 85) {
      scoreLevel = 'Sangat Cocok';
    } else if (score >= 70) {
      scoreLevel = 'Cocok';
    } else if (score < 60) {
      scoreLevel = 'Kurang Cocok';
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            '$score%',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            scoreLevel,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    } else {
      return name.length > 1 ? name.substring(0, 2) : name;
    }
  }

  String _getCompatibilityLevel(double score) {
    if (score >= 80) return 'Sangat Baik';
    if (score >= 70) return 'Baik';
    if (score >= 60) return 'Cukup Baik';
    return 'Perlu Perhatian';
  }

  void _shareResult() {
    final String shareText = '''
Hasil Kecocokan Jodoh - Pustaka Jawa

${compatibility.person1Name} (${compatibility.person1Weton}) & 
${compatibility.person2Name} (${compatibility.person2Weton})

Tingkat Kecocokan: ${compatibility.totalCompatibility.round()}% - ${_getCompatibilityLevel(compatibility.totalCompatibility)}

Bibit: ${compatibility.bibitScore.round()}%
Bebet: ${compatibility.bebetScore.round()}%
Bobot: ${compatibility.bobotScore.round()}%

Interpretasi:
${compatibility.interpretation}

Saran untuk Pasangan:
${compatibility.suggestions.map((suggestion) => '• $suggestion').join('\n')}

- Dihitung menggunakan aplikasi Pustaka Jawa
''';

    Share.share(shareText);
  }
}

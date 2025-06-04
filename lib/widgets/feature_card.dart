// lib/widgets/feature_card.dart
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  
  const FeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0), // Sedikit kurangi padding atas/bawah jika perlu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Kurangi padding jika perlu
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 2), // << DIUBAH dari 12 ke 8
              Text(
                title,
                style: TextStyle(
                  fontSize: 12, // Anda bisa coba kurangi sedikit jika masih overflow, misal 15
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1, // Pastikan judul tidak terlalu panjang
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), // << DIUBAH dari 4 ke 2
              Text(
                description,
                style: TextStyle(
                  fontSize: 12, // Anda bisa coba kurangi sedikit jika masih overflow, misal 11
                  color: Colors.grey[600],
                ),
                maxLines: 1, 
                overflow: TextOverflow.ellipsis, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
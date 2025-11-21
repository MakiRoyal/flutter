import 'package:flutter/material.dart';

/// Widget d'en-tête gaming pour les pages
class GamingHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const GamingHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF),
            const Color(0xFFFF6B9D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

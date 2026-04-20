import 'package:flutter/material.dart';
import '../../domain/entities/vibe_item.dart';

class VibeCard extends StatelessWidget {
  final VibeItem item;
  final VoidCallback onTap;

  const VibeCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112,
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D1B3E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

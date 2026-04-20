import 'package:flutter/material.dart';
import '../../domain/entities/discover_city.dart';

class PopularCityItem extends StatelessWidget {
  final DiscoverCity city;
  final VoidCallback onTap;

  const PopularCityItem({super.key, required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 74,
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(city.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              city.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D1B3E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      Icons.home_rounded,
      Icons.explore_rounded,
      Icons.luggage_rounded,
      Icons.person_outline_rounded,
    ];

    return SafeArea(
      minimum: const EdgeInsets.only(left: 22, right: 22, bottom: 12),
      child: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final bool isSelected = currentIndex == index;
            return GestureDetector(
              onTap: () => onTap(index),
              child: Icon(
                items[index],
                size: 24,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary.withOpacity(0.7),
              ),
            );
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Beranda'),
          _buildNavItem(1, Icons.notifications_rounded, Icons.notifications_outlined, 'Notifikasi'),
          _buildNavItem(2, Icons.newspaper_rounded, Icons.newspaper_outlined, 'Berita'),
          _buildNavItem(3, Icons.person_rounded, Icons.person_outlined, 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.navLabel.copyWith(
                color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

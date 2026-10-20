import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Bottom navigation mengambang dengan kapsul aktif bergradien.
///
/// Perilaku tetap: menerima [currentIndex] dan [onTap] dari MainShell.
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
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.10),
                blurRadius: 26,
                offset: const Offset(0, 10),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Row(
            children: [
              _buildNavItem(
                0,
                Icons.home_rounded,
                Icons.home_outlined,
                'Beranda',
              ),
              _buildNavItem(
                1,
                Icons.notifications_rounded,
                Icons.notifications_none_rounded,
                'Notifikasi',
              ),
              _buildNavItem(
                2,
                Icons.newspaper_rounded,
                Icons.newspaper_outlined,
                'Berita',
              ),
              _buildNavItem(
                3,
                Icons.person_rounded,
                Icons.person_outline_rounded,
                'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isActive = currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                width: 44,
                height: 30,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.primaryGradient,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(
                              alpha: 0.32,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: -3,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isActive ? activeIcon : inactiveIcon,
                  color: isActive ? Colors.white : AppColors.textTertiary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.navLabel.copyWith(
                  color: isActive
                      ? AppColors.primaryBlue
                      : AppColors.textTertiary,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  fontSize: isActive ? 10.5 : 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

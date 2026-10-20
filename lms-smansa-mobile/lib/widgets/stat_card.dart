import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'surface_card.dart';

/// Stat card dengan ikon berwarna, label kecil, dan angka besar.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showLeftBorder;
  final Color? accentColor;
  final IconData? icon;
  final String? suffix;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.showLeftBorder = false,
    this.accentColor,
    this.icon,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.leftBorderBlue;

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null)
                AppIconTile(
                  icon: icon!,
                  color: accent,
                  size: 36,
                  iconSize: 19,
                  radius: 11,
                ),
              const Spacer(),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.45),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.eyebrow.copyWith(
              color: AppColors.textTertiary,
              fontSize: 9.5,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bigNumber.copyWith(
                    fontSize: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 4),
                Text(
                  suffix!,
                  style: AppTextStyles.smallText.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

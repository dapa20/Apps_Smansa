import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final String type; // 'terlambat' | 'menunggu' | 'selesai' | 'berlangsung' | 'akademik' | 'libur' | 'kegiatan' | 'info'
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: colors.$2),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.chipText.copyWith(color: colors.$2),
          ),
        ],
      ),
    );
  }

  (Color, Color) _getColors() {
    switch (type) {
      case 'terlambat':
      case 'berlangsung':
      case 'akademik':
        return (AppColors.chipRedBg, AppColors.chipRedText);
      case 'menunggu':
      case 'kegiatan':
        return (AppColors.chipYellowBg, AppColors.chipYellowText);
      case 'selesai':
        return (AppColors.chipGreenBg, AppColors.chipGreenText);
      case 'libur':
        return (AppColors.chipPurpleBg, AppColors.chipPurpleText);
      case 'info':
        return (AppColors.chipBlueBg, AppColors.chipBlueText);
      default:
        return (AppColors.chipBlueBg, AppColors.chipBlueText);
    }
  }
}

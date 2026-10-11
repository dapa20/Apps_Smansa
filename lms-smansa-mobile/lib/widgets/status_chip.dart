import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Status chip modern: pill dengan dot indicator di kiri.
/// Mendukung tipe: menunggu, terlambat, selesai, berlangsung, info, kegiatan, penting.
class StatusChip extends StatelessWidget {
  final String label;
  final String type;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
    this.icon,
  });

  Color get _bg {
    switch (type.toLowerCase()) {
      case 'menunggu':
      case 'terlambat':
        return AppColors.chipRedBg;
      case 'selesai':
      case 'dinilai':
      case 'terkumpul':
        return AppColors.chipGreenBg;
      case 'berlangsung':
        return AppColors.chipBlueBg;
      case 'kegiatan':
        return AppColors.chipPurpleBg;
      case 'penting':
      case 'pengumuman':
        return AppColors.chipYellowBg;
      case 'info':
      default:
        return AppColors.surfaceMuted;
    }
  }

  Color get _text {
    switch (type.toLowerCase()) {
      case 'menunggu':
      case 'terlambat':
        return AppColors.chipRedText;
      case 'selesai':
      case 'dinilai':
      case 'terkumpul':
        return AppColors.chipGreenText;
      case 'berlangsung':
        return AppColors.chipBlueText;
      case 'kegiatan':
        return AppColors.chipPurpleText;
      case 'penting':
      case 'pengumuman':
        return AppColors.chipYellowText;
      default:
        return AppColors.textSecondary;
    }
  }

  Color get _dot {
    switch (type.toLowerCase()) {
      case 'menunggu':
      case 'terlambat':
        return AppColors.dangerRed;
      case 'selesai':
      case 'dinilai':
      case 'terkumpul':
        return AppColors.chipGreenText;
      case 'berlangsung':
        return AppColors.primaryBlue;
      case 'kegiatan':
        return AppColors.chipPurpleText;
      case 'penting':
      case 'pengumuman':
        return AppColors.accentYellow;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: _dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          if (icon != null) ...[
            Icon(icon, size: 12, color: _text),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.chipText.copyWith(color: _text),
          ),
        ],
      ),
    );
  }
}
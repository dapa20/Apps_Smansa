import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Status chip modern: pill lembut dengan indikator titik dan border tipis.
///
/// Mendukung tipe: menunggu, terlambat, belum, selesai, dinilai, terkumpul,
/// berlangsung, info, kegiatan, penting, pengumuman, akademik, libur,
/// prestasi, dan fallback netral.
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
      case 'belum':
      case 'libur':
        return AppColors.chipRedBg;
      case 'selesai':
      case 'dinilai':
      case 'terkumpul':
      case 'prestasi':
        return AppColors.chipGreenBg;
      case 'berlangsung':
      case 'akademik':
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
      case 'belum':
      case 'libur':
        return AppColors.chipRedText;
      case 'selesai':
      case 'dinilai':
      case 'terkumpul':
      case 'prestasi':
        return AppColors.chipGreenText;
      case 'berlangsung':
      case 'akademik':
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
      case 'belum':
      case 'libur':
        return AppColors.dangerRed;
      case 'selesai':
      case 'dinilai':
      case 'terkumpul':
      case 'prestasi':
        return AppColors.chipGreenText;
      case 'berlangsung':
      case 'akademik':
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _dot.withValues(alpha: 0.16), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: _dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          if (icon != null) ...[
            Icon(icon, size: 11, color: _text),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.chipText.copyWith(color: _text),
            ),
          ),
        ],
      ),
    );
  }
}

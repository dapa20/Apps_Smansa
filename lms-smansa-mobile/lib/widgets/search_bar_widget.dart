import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Search bar modern berbentuk kapsul putih dengan ikon di kotak tint.
///
/// Perilaku tetap sama:
/// - [onChanged] != null → field bisa diketik.
/// - [onTap] != null → field read-only dan memicu callback saat disentuh.
/// - Tanpa keduanya → hanya menampilkan hint statis.
class SearchBarWidget extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hint = 'Cari Informasi...',
    this.onTap,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap != null ? () => onTap!() : null,
      readOnly: onTap != null && onChanged == null,
      cursorColor: AppColors.primaryBlue,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: hint,
        hintStyle: AppTextStyles.bodySecondary.copyWith(
          color: AppColors.textTertiary,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlueTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: onChanged != null
                ? textField
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
          ),
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.textSecondary,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Search bar modern minimal:
/// - Pill shape (radius 999)
/// - Background surface muted, tanpa shadow berat
/// - Icon search dengan warna secondary
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
      readOnly: onTap != null,
      style: AppTextStyles.bodyText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textTertiary,
          size: 20,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 14,
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: onChanged != null
                ? textField
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      hint,
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
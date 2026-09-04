import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class SearchBarWidget extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    this.hint = 'Cari Informasi...',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Text(hint, style: AppTextStyles.bodySecondary),
          ],
        ),
      ),
    );
  }
}

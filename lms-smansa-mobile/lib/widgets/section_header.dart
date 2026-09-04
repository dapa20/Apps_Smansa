import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionLabel!,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

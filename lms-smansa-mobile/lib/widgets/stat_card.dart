import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showLeftBorder;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.showLeftBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
        border: showLeftBorder
            ? const Border(left: BorderSide(color: AppColors.leftBorderBlue, width: AppConstants.leftBorderWidth))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.chipText.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.bigNumber),
        ],
      ),
    );
  }
}

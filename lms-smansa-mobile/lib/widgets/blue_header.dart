import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// A reusable blue curved header used across many screens.
/// Displays a title, optional subtitle, and optional trailing widgets.
class BlueHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  final List<Widget>? extraContent;

  const BlueHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.height = 180,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WavyClipper(),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: height),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlueDark, AppColors.primaryBlue],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null || trailing != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leading ?? const SizedBox.shrink(),
                    trailing ?? const SizedBox.shrink(),
                  ],
                ),
              if (leading != null || trailing != null) const SizedBox(height: 12),
              Text(title, style: AppTextStyles.headerTitle),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: AppTextStyles.headerSubtitle),
              ],
              if (extraContent != null) ...extraContent!,
            ],
          ),
        ),
      ),
    );
  }
}

class _WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2, size.height + 10,
      size.width, size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

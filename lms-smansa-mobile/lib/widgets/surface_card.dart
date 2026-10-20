import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Kartu permukaan standar aplikasi.
///
/// Putih bersih, border hairline, sudut besar, dan shadow sangat halus.
/// Bisa diberi gradient, aksen, atau dijadikan tappable.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color color;
  final double radius;
  final Color? borderColor;
  final bool shadow;
  final bool strongShadow;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.gradient,
    this.color = AppColors.surface,
    this.radius = 22,
    this.borderColor,
    this.shadow = true,
    this.strongShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final decoration = BoxDecoration(
      color: gradient == null ? color : null,
      gradient: gradient,
      borderRadius: borderRadius,
      border: Border.all(
        color: borderColor ?? AppColors.borderSubtle,
        width: 1,
      ),
      boxShadow: shadow
          ? [
              BoxShadow(
                color: strongShadow
                    ? AppColors.cardShadowStrong
                    : AppColors.cardShadow,
                blurRadius: strongShadow ? 24 : 16,
                offset: Offset(0, strongShadow ? 10 : 6),
                spreadRadius: -6,
              ),
            ]
          : null,
    );

    final content = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: borderRadius, onTap: onTap, child: content),
    );
  }
}

/// Label kecil berhuruf kapital untuk memisahkan kelompok konten.
class SectionLabel extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry padding;

  const SectionLabel(this.label, {super.key, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.eyebrow.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ikon dalam kotak lembut dengan gradient opsional.
class AppIconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final double radius;
  final bool gradient;

  const AppIconTile({
    super.key,
    required this.icon,
    required this.color,
    this.size = 46,
    this.iconSize = 22,
    this.radius = 14,
    this.gradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gradient ? null : color.withValues(alpha: 0.10),
        gradient: gradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, Color.lerp(color, Colors.white, 0.28) ?? color],
              )
            : null,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: gradient
              ? Colors.white.withValues(alpha: 0.22)
              : color.withValues(alpha: 0.16),
          width: 1,
        ),
        boxShadow: gradient
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                  spreadRadius: -4,
                ),
              ]
            : null,
      ),
      child: Icon(icon, color: gradient ? Colors.white : color, size: iconSize),
    );
  }
}

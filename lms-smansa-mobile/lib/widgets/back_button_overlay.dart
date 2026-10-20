import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Tombol kembali reusable yang dipasang di atas header.
///
/// Gaya baru: lingkaran glass blur dengan border tipis putih.
class BackButtonOverlay extends StatelessWidget {
  final VoidCallback? onPressed;
  final double topPadding;
  final double leftPadding;

  const BackButtonOverlay({
    super.key,
    this.onPressed,
    this.topPadding = 8,
    this.leftPadding = 8,
  });

  void _defaultOnPressed(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPadding,
      left: leftPadding,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onPressed ?? _defaultOnPressed(context),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Versi tombol back untuk `Scaffold.appBar` (bila masih digunakan).
class BackLeadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;

  const BackLeadingButton({
    super.key,
    this.onPressed,
    this.color = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final onLightSurface = color != Colors.white;

    return IconButton(
      tooltip: 'Kembali',
      onPressed:
          onPressed ??
          () {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) navigator.pop();
          },
      icon: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: onLightSurface
              ? AppColors.surfaceMuted
              : Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onLightSurface
                ? AppColors.borderSubtle
                : Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Icon(Icons.arrow_back_rounded, color: color, size: 20),
      ),
    );
  }
}

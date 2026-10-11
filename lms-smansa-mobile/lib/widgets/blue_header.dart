import 'package:flutter/material.dart';
import '../core/theme/app_text_styles.dart';

/// A reusable blue curved header used across many screens.
/// Displays a title, optional subtitle, and optional trailing widgets.
///
/// Style: modern minimal dengan gradient halus (deep blue → mid blue → light),
/// padding adaptif dengan [SafeArea] untuk notch/status bar, dan opsional
/// glass overlay + decorative blobs untuk efek premium.
///
/// Tinggi [height] adalah tinggi minimum (ekspansi mengikuti konten).
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
        constraints: BoxConstraints(
          minHeight: height + MediaQuery.of(context).padding.top,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1D4ED8), // primaryBlueDark
              Color(0xFF2563EB), // primaryBlue
              Color(0xFF3B82F6), // lighter blue
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Soft glass overlay (subtle white wash) untuk efek premium
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.10),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ─── Decorative blobs (3 lingkaran pudar tumpang tindih) ─
            // Pattern referensi: 3 blob overlap membentuk pola premium.
            // Blob 1 — besar kanan-atas (overflow keluar header)
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
            ),
            // Blob 2 — medium kiri-tengah, overlap dengan blob 1
            Positioned(
              top: 40,
              left: -120,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
            ),
            // Blob 3 — besar kanan-tengah, overlap dengan blob 1
            Positioned(
              top: 30,
              right: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Konten utama: pakai SafeArea untuk hindarin overlap notch.
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null || trailing != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          leading ?? const SizedBox.shrink(),
                          trailing ?? const SizedBox.shrink(),
                        ],
                      ),
                    if (leading != null || trailing != null)
                      const SizedBox(height: 14),
                    if (title.isNotEmpty)
                      Text(title, style: AppTextStyles.headerTitle),
                    if (subtitle != null) ...[
                      if (title.isNotEmpty) const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: AppTextStyles.headerSubtitle,
                      ),
                    ],
                    if (extraContent != null) ...extraContent!,
                  ],
                ),
              ),
            ),
          ],
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
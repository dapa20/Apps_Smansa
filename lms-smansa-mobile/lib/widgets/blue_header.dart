import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Header gradient yang dipakai hampir di seluruh halaman.
///
/// Desain baru: gradient navy → blue, pola garis halus, glow cyan,
/// sudut bawah membulat, dan tombol kembali bergaya glass.
class BlueHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// Label kecil di atas judul (mis. nama sekolah / kategori halaman).
  final String? eyebrow;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  final List<Widget>? extraContent;
  final bool showBackButton;
  final VoidCallback? onBack;

  const BlueHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.leading,
    this.trailing,
    this.height = 180,
    this.extraContent,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final hasTopRow = leading != null || trailing != null || showBackButton;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColors.heroLinear,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pola garis tipis + glow dekoratif.
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _HeaderPatternPainter()),
            ),
          ),
          Positioned(
            top: -110,
            right: -80,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentCyan.withValues(alpha: 0.22),
                      AppColors.accentCyan.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -70,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasTopRow) ...[
                      Row(
                        children: [
                          if (showBackButton)
                            _GlassBackButton(onPressed: onBack),
                          ?leading,
                          const Spacer(),
                          ?trailing,
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (eyebrow != null) ...[
                      Text(
                        eyebrow!.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.55),
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (title.isNotEmpty)
                      Text(
                        title,
                        style: AppTextStyles.headerTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (subtitle != null) ...[
                      if (title.isNotEmpty) const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        style: AppTextStyles.headerSubtitle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    ...?extraContent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _GlassBackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap:
            onPressed ??
            () {
              final navigator = Navigator.of(context);
              if (navigator.canPop()) navigator.pop();
            },
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
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
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1;

    // Garis vertikal halus.
    for (double x = 24; x < size.width; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Garis horizontal halus.
    for (double y = 28; y < size.height; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Lingkaran outline besar di kanan bawah.
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.07);
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.72),
      size.width * 0.32,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.72),
      size.width * 0.22,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

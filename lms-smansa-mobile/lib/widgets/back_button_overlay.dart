import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Tombol back reusable yang dipasang di atas header (mis. BlueHeader).
///
/// Dipakai untuk halaman yang tidak memiliki `Scaffold.appBar` tapi
/// tetap membutuhkan tombol kembali. Styling: lingkaran semi-transparan
/// dengan ikon putih, sehingga tetap terbaca di atas gradient biru.
///
/// Contoh pemakaian:
///
/// ```dart
/// Scaffold(
///   body: Stack(
///     children: [
///       Column(
///         children: [
///           const BlueHeader(title: 'Tugas Saya'),
///           // ...konten
///         ],
///       ),
///       const BackButtonOverlay(),
///     ],
///   ),
/// )
/// ```
class BackButtonOverlay extends StatelessWidget {
  /// Jika null, akan otomatis memanggil `Navigator.maybePop(context)`.
  final VoidCallback? onPressed;

  /// Padding dari atas setelah SafeArea (default: 8).
  final double topPadding;

  /// Padding dari kiri (default: 8).
  final double leftPadding;

  const BackButtonOverlay({
    super.key,
    this.onPressed,
    this.topPadding = 8,
    this.leftPadding = 8,
  });

  void _defaultOnPressed(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
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
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Versi tombol back yang cocok untuk `Scaffold.appBar`.
///
/// Wrapper kecil agar konsisten warna/iconTheme dengan halaman lain.
/// Pakai ini sebagai `appBar.leading` jika ingin konsisten.
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
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color),
      tooltip: 'Kembali',
      onPressed: onPressed ?? () {
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        }
      },
    );
  }
}
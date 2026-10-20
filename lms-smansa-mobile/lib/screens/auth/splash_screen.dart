import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/auth_service.dart';
import '../../app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    // Auto-login: jika token masih tersimpan, langsung ke beranda.
    bool hasSession = false;
    try {
      hasSession = await AuthService.instance.tryRestoreSession();
    } catch (_) {
      hasSession = false;
    }

    // Validasi token ke server. Jika basi (401), sesi dihapus & diarahkan
    // ke halaman login. Jika server tidak terjangkau, biarkan masuk
    // (halaman akan menampilkan error "gagal memuat data").
    if (hasSession) {
      try {
        hasSession = await AuthService.instance.validateSession();
      } catch (_) {
        hasSession = false;
      }
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      hasSession ? AppRoutes.mainShell : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.heroGradient,
            stops: [0.0, 0.38, 0.72, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Grid halus.
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _SplashGridPainter()),
              ),
            ),
            // Glow cyan kanan atas.
            Positioned(
              top: -90,
              right: -110,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentCyan.withValues(alpha: 0.26),
                      AppColors.accentCyan.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Glow biru kiri bawah.
            Positioned(
              bottom: -140,
              left: -110,
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withValues(alpha: 0.18),
                ),
              ),
            ),
            // Cincin dekoratif.
            Positioned(top: 110, right: -68, child: _OutlineRing(size: 220)),
            Positioned(bottom: 150, left: -90, child: _OutlineRing(size: 240)),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 22,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 850),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 24 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // Logo dengan cincin gradient.
                          Container(
                            width: 152,
                            height: 152,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.55),
                                  Colors.white.withValues(alpha: 0.08),
                                  AppColors.accentCyan.withValues(alpha: 0.5),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentCyan.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/logo_smansa.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.school_rounded,
                                      size: 60,
                                      color: AppColors.primaryBlue,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 34),
                          Text(
                            AppConstants.schoolName,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headerTitle.copyWith(
                              fontSize: 28,
                              letterSpacing: -0.8,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentCyan,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppConstants.tagline,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 9.5,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    // Loading bar tipis + teks.
                    SizedBox(
                      width: 132,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(
                          minHeight: 3,
                          backgroundColor: Color(0x26FFFFFF),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Menyiapkan ruang belajar...',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.appName,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.36),
                            fontSize: 9.5,
                            letterSpacing: 0.6,
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.24),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          AppConstants.appVersion,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.36),
                            fontSize: 9.5,
                          ),
                        ),
                      ],
                    ),
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

class _OutlineRing extends StatelessWidget {
  final double size;

  const _OutlineRing({required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
    );
  }
}

class _SplashGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

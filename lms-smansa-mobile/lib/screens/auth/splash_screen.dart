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
      backgroundColor: AppColors.primaryBlue,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1D4ED8),
              Color(0xFF2563EB),
              Color(0xFF3B82F6),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              top: 120,
              right: 40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // ─── Logo ──────────────────────────────────────────
                    Container(
                      width: 116,
                      height: 116,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20),
                            blurRadius: 28,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo_smansa.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.school,
                              size: 60,
                              color: AppColors.primaryBlue,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ─── Nama Sekolah ──────────────────────────────────
                    Text(
                      AppConstants.schoolName,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headerTitle.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─── Tagline ───────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        AppConstants.tagline,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // ─── Loading ───────────────────────────────────────
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ─── Versi ─────────────────────────────────────────
                    Text(
                      'Loading ${AppConstants.appName}...',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.appVersion,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 8),
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
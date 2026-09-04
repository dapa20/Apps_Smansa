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
            colors: [AppColors.primaryBlueDark, AppColors.primaryBlue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ─── Logo ──────────────────────────────────────────
                Container(
                  width: 110,
                  height: 110,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 24,
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
                          size: 56,
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
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                // ─── Tagline ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppConstants.tagline,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.smallText.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      letterSpacing: 1.5,
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),

                const SizedBox(height: 18),

                // ─── Versi ─────────────────────────────────────────
                Text(
                  'Loading ${AppConstants.appName}...',
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.appVersion,
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

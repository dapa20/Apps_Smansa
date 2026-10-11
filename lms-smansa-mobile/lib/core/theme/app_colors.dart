import 'package:flutter/material.dart';

/// Palet warna aplikasi LMS SMANSA Mobile.
/// Menggunakan blue (#2563EB) sebagai warna utama, konsisten dengan brand sekolah.
///
/// Warna tambahan untuk desain modern:
/// - [primaryBlueTint] / [primaryBlueShade] → variasi biru
/// - [glassOverlay] → efek glassmorphism header
/// - [borderSubtle] → border tipis 1px ala Linear/Vercel
/// - [surfaceMuted] → background surface subtle
class AppColors {
  AppColors._();

  // ====== Primary Brand ======
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueTint = Color(0xFFEFF6FF);
  static const Color primaryBlueShade = Color(0xFF1E40AF);

  // ====== Background & Surface ======
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  // ====== Text ======
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // ====== Accents ======
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color accentYellow = Color(0xFFF59E0B);

  // ====== Status Chips ======
  static const Color chipRedBg = Color(0xFFFEF2F2);
  static const Color chipRedText = Color(0xFFDC2626);
  static const Color chipYellowBg = Color(0xFFFFFBEB);
  static const Color chipYellowText = Color(0xFFD97706);
  static const Color chipGreenBg = Color(0xFFECFDF5);
  static const Color chipGreenText = Color(0xFF059669);
  static const Color chipPurpleBg = Color(0xFFF5F3FF);
  static const Color chipPurpleText = Color(0xFF7C3AED);
  static const Color chipBlueBg = Color(0xFFEFF6FF);
  static const Color chipBlueText = Color(0xFF2563EB);

  // ====== Modern Tokens ======
  /// Border tipis 1px (Linear/Vercel style) untuk card dengan shadow halus.
  static const Color borderSubtle = Color(0xFFE2E8F0);

  /// Overlay untuk efek glassmorphism (alpha rendah di atas gradient).
  static const Color glassOverlay = Color(0x14FFFFFF); // 8% white

  /// Inner divider halus.
  static const Color divider = Color(0xFFE5E7EB);

  /// Shadow kartu (alpha rendah, blur besar) — gaya modern soft.
  static const Color cardShadow = Color(0x0F0F172A); // ~6% slate-900

  /// Left border accent (untuk beberapa card list).
  static const Color leftBorderBlue = Color(0xFF2563EB);
}
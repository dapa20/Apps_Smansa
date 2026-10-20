import 'package:flutter/material.dart';

/// Palet warna aplikasi LMS SMANSA Mobile.
///
/// Arah desain: "Deep Ocean Academic" — biru navy yang tenang dipadukan
/// dengan aksen cyan, mint, dan amber. Permukaan terang dengan tint biru
/// tipis agar terasa premium namun tetap ringan dan mudah dibaca.
class AppColors {
  AppColors._();

  // ====== Primary Brand ======
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueTint = Color(0xFFEDF3FF);
  static const Color primaryBlueShade = Color(0xFF1E40AF);

  /// Warna paling gelap untuk header, teks kuat, dan gradient.
  static const Color navy = Color(0xFF0A1B45);
  static const Color deepBlue = Color(0xFF14327A);

  // ====== Background & Surface ======
  static const Color background = Color(0xFFF4F7FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEEF3FB);
  static const Color surfaceAlt = Color(0xFFF8FAFF);

  // ====== Text ======
  static const Color textPrimary = Color(0xFF0B1220);
  static const Color textSecondary = Color(0xFF5A6B85);
  static const Color textTertiary = Color(0xFF93A1B8);

  // ====== Accents ======
  static const Color dangerRed = Color(0xFFE11D48);
  static const Color accentYellow = Color(0xFFF59E0B);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentCyan = Color(0xFF22D3EE);
  static const Color accentMint = Color(0xFF10B981);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentTeal = Color(0xFF14B8A6);

  // ====== Status Chips ======
  static const Color chipRedBg = Color(0xFFFFEDF1);
  static const Color chipRedText = Color(0xFFBE123C);
  static const Color chipYellowBg = Color(0xFFFFF7E6);
  static const Color chipYellowText = Color(0xFFB45309);
  static const Color chipGreenBg = Color(0xFFE9FBF3);
  static const Color chipGreenText = Color(0xFF047857);
  static const Color chipPurpleBg = Color(0xFFF3EFFF);
  static const Color chipPurpleText = Color(0xFF6D28D9);
  static const Color chipBlueBg = Color(0xFFEAF1FF);
  static const Color chipBlueText = Color(0xFF1D4ED8);

  // ====== Modern Tokens ======
  /// Border tipis 1px untuk card dengan shadow halus.
  static const Color borderSubtle = Color(0xFFE3EAF5);
  static const Color borderStrong = Color(0xFFD3DEF0);

  /// Overlay untuk efek glassmorphism di atas gradient.
  static const Color glassOverlay = Color(0x1FFFFFFF);

  /// Inner divider halus.
  static const Color divider = Color(0xFFEBF0F8);

  /// Shadow kartu (alpha rendah, blur besar) — soft modern.
  static const Color cardShadow = Color(0x0D0B1B3A);
  static const Color cardShadowStrong = Color(0x1A0B1B3A);

  /// Left border accent (untuk beberapa card list).
  static const Color leftBorderBlue = Color(0xFF2563EB);

  // ====== Gradients ======
  /// Gradient utama untuk hero header & splash.
  static const List<Color> heroGradient = [
    Color(0xFF081538),
    Color(0xFF102C6B),
    Color(0xFF1D4ED8),
    Color(0xFF3B82F6),
  ];

  /// Gradient tombol utama.
  static const List<Color> primaryGradient = [
    Color(0xFF1D4ED8),
    Color(0xFF3B82F6),
  ];

  /// Gradient aksen cyan.
  static const List<Color> cyanGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF22D3EE),
  ];

  /// Gradient mint.
  static const List<Color> mintGradient = [
    Color(0xFF059669),
    Color(0xFF34D399),
  ];

  /// Gradient amber.
  static const List<Color> amberGradient = [
    Color(0xFFD97706),
    Color(0xFFFBBF24),
  ];

  /// Gradient ungu.
  static const List<Color> purpleGradient = [
    Color(0xFF6D28D9),
    Color(0xFFA78BFA),
  ];

  static const LinearGradient heroLinear = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: heroGradient,
    stops: [0.0, 0.38, 0.72, 1.0],
  );
}

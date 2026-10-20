import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography scale untuk desain "Deep Ocean Academic".
///
/// Display & heading memakai Plus Jakarta Sans (geometris, modern, ramah),
/// dengan tracking negatif tipis agar terasa seperti aplikasi kelas atas.
class AppTextStyles {
  AppTextStyles._();

  // ====== Display & Header (untuk BlueHeader / Splash) ======
  static TextStyle headerTitle = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.6,
    height: 1.15,
  );

  static TextStyle headerSubtitle = GoogleFonts.plusJakartaSans(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: Colors.white.withValues(alpha: 0.78),
    letterSpacing: 0.1,
    height: 1.45,
  );

  static TextStyle display = GoogleFonts.plusJakartaSans(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.9,
    height: 1.15,
  );

  // ====== Section Title (H2) ======
  static TextStyle sectionTitle = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
    height: 1.25,
  );

  // ====== Card Title (H3) ======
  static TextStyle cardTitle = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.35,
  );

  // ====== Body ======
  static TextStyle bodyText = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
  );

  static TextStyle bodySecondary = GoogleFonts.plusJakartaSans(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ====== Small / Caption ======
  static TextStyle smallText = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );

  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
    letterSpacing: 0.3,
  );

  /// Label kecil dengan huruf kapital dan tracking lebar (eyebrow).
  static TextStyle eyebrow = GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    color: AppColors.textTertiary,
    letterSpacing: 1.8,
  );

  // ====== Chip Text ======
  static TextStyle chipText = GoogleFonts.plusJakartaSans(
    fontSize: 10.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.6,
  );

  // ====== Nav Label (bottom navigation) ======
  static TextStyle navLabel = GoogleFonts.plusJakartaSans(
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // ====== Big Number (nilai, statistik) ======
  static TextStyle bigNumber = GoogleFonts.plusJakartaSans(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryBlue,
    letterSpacing: -1.1,
    height: 1.05,
  );

  // ====== Letter Grade ======
  static TextStyle letterGrade = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.accentYellow,
    letterSpacing: 0,
  );

  // ====== Button Text ======
  static TextStyle buttonText = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );
}

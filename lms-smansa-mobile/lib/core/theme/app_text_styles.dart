import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle headerTitle = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle headerSubtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white.withValues(alpha: 0.85),
  );

  static TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySecondary = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle smallText = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle chipText = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static TextStyle navLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bigNumber = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlue,
  );

  static TextStyle letterGrade = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.accentYellow,
  );
}

class AppConstants {
  AppConstants._();

  static const String appName = 'SMANSA Mobile LMS';
  static const String appVersion = 'v2.4.0';
  static const String schoolName = 'SMA Negeri 1 Bumiayu';
  static const String tagline = 'INSTITUTIONAL DIGITAL WORKSPACE';
  static const String currentSemester = 'Semester Ganjil 2023/2024';
  static const String tahunAjaran = '2023/2024';

  // Spacing constants (multi-4 grid)
  static const double screenPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double cardRadius = 20.0;
  static const double chipRadius = 8.0;
  static const double buttonRadius = 14.0;
  static const double itemSpacing = 12.0;
  static const double sectionSpacing = 24.0;
  static const double leftBorderWidth = 4.0;
  static const double bottomNavHeight = 64.0;

  // Responsive breakpoints
  static const double mobileSmall = 360.0;
  static const double mobileMedium = 480.0;
  static const double tabletSmall = 600.0;
  static const double tabletLarge = 840.0;

  /// Klasifikasi lebar layar: small (phone kecil), medium (phone),
  /// large (phone besar / phablet), extraLarge (tablet/desktop).
  static ScreenSize getScreenSize(double width) {
    if (width < mobileSmall) return ScreenSize.small;
    if (width < mobileMedium) return ScreenSize.medium;
    if (width < tabletSmall) return ScreenSize.large;
    return ScreenSize.extraLarge;
  }

  /// Padding layar yang menyesuaikan lebar device.
  static double responsivePadding(double width) {
    final size = getScreenSize(width);
    switch (size) {
      case ScreenSize.small:
        return 16.0;
      case ScreenSize.medium:
        return 20.0;
      case ScreenSize.large:
        return 24.0;
      case ScreenSize.extraLarge:
        return 32.0;
    }
  }

  /// Lebar maksimal konten (di atas ini akan dipusatkan + margin auto).
  /// Berguna agar tampilan lebar seperti iPad / desktop tidak stretched.
  static const double maxContentWidth = 600.0;
}

enum ScreenSize { small, medium, large, extraLarge }

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart';
import '../screens/main_shell.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/jadwal/jadwal_screen.dart';
import '../screens/kalender/kalender_screen.dart';
import '../screens/tugas/tugas_screen.dart';
import '../screens/ujian/ujian_screen.dart';
import '../screens/riwayat/riwayat_screen.dart';
import '../screens/smansago/smansago_screen.dart';
import '../screens/pemindai/pemindai_screen.dart';
import '../screens/profil/data_diri_screen.dart';
import '../screens/profil/pengaturan_akun_screen.dart';
import '../screens/materi/materi_screen.dart';

class LmsSmansaApp extends StatelessWidget {
  const LmsSmansaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMANSA Mobile LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.mainShell: (_) => const MainShell(),
        AppRoutes.jadwal: (_) => const JadwalScreen(),
        AppRoutes.kalender: (_) => const KalenderScreen(),
        AppRoutes.tugas: (_) => const TugasScreen(),
        AppRoutes.ujian: (_) => const UjianScreen(),
        AppRoutes.riwayat: (_) => const RiwayatScreen(),
        AppRoutes.smansago: (_) => const SmansagoScreen(),
        AppRoutes.pemindai: (_) => const PemindaiScreen(),
        AppRoutes.dataDiri: (_) => const DataDiriScreen(),
        AppRoutes.materi: (_) => const MateriScreen(),
        AppRoutes.pengaturanAkun: (_) => const PengaturanAkunScreen(),
      },
    );
  }
}

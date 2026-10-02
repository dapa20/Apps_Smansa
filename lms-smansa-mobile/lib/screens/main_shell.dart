import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../app/main_shell_controller.dart';
import 'beranda/beranda_screen.dart';
import 'notifikasi/notifikasi_screen.dart';
import 'berita/berita_screen.dart';
import 'profil/profil_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    BerandaScreen(),
    NotifikasiScreen(),
    BeritaScreen(),
    ProfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Sinkronkan index MainShell dengan controller global
    MainShellController.instance.addListener(_onControllerChanged);
    _currentIndex = MainShellController.instance.currentIndex;
  }

  @override
  void dispose() {
    MainShellController.instance.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {
      _currentIndex = MainShellController.instance.currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          MainShellController.instance.switchToTab(index);
        },
      ),
    );
  }
}

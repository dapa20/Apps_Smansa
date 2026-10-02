import 'package:flutter/foundation.dart';

/// Controller global untuk [MainShell]. Memungkinkan widget lain
/// (mis. BerandaScreen) meminta perpindahan tab bawah.
///
/// Dipakai ketika user menekan tombol "Lihat Semua" di Berita Terbaru
/// — langsung loncat ke tab Berita di MainShell tanpa push halaman baru.
class MainShellController extends ChangeNotifier {
  MainShellController._();
  static final MainShellController instance = MainShellController._();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  /// Index tab di MainShell.
  ///   0 = Beranda, 1 = Notifikasi, 2 = Berita, 3 = Profil
  void switchToTab(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }
}
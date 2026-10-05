import 'package:flutter/foundation.dart';

/// Controller global untuk [MainShell]. Memungkinkan widget lain
/// (mis. BerandaScreen) meminta perpindahan tab bawah.

/// Dipakai ketika user menekan tombol "Lihat Semua" di Berita Terbaru
class MainShellController extends ChangeNotifier {
  MainShellController._();
  static final MainShellController instance = MainShellController._();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void switchToTab(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }
}
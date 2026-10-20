import 'package:flutter/foundation.dart';

/// Controller global untuk [MainShell]. Memungkinkan widget lain



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
import 'package:flutter/foundation.dart';
import '../core/api/api_repository.dart';

/// Controller global untuk status notifikasi siswa. Dipakai oleh BerandaScreen
class NotificationBadgeController extends ChangeNotifier {
  NotificationBadgeController._();
  static final NotificationBadgeController instance =
      NotificationBadgeController._();

  int _unreadCount = 0;
  bool _loaded = false;
  bool _loading = false;

  int get unreadCount => _unreadCount;
  bool get hasUnread => _unreadCount > 0;
  bool get loaded => _loaded;
  bool get loading => _loading;

  Future<void> refresh() async {
    if (_loading) return;
    _loading = true;
    try {
      final list = await ApiRepository.instance.getPengumuman();
      _unreadCount = list.length;
      _loaded = true;
    } catch (_) {
      
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    if (_unreadCount > 0) {
      _unreadCount = 0;
      notifyListeners();
    }
  }

  void reset() {
    _unreadCount = 0;
    _loaded = false;
    _loading = false;
  }
}
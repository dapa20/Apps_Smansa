import 'package:flutter/foundation.dart';
import '../core/api/api_repository.dart';

/// Controller global untuk status notifikasi siswa. Dipakai oleh BerandaScreen
/// (badge merah di icon bell) dan NotifikasiScreen (penanda sudah dibaca).
///
/// Logika sederhana: "baru" diartikan sebagai pengumuman yang ada di database
/// (siapapun yang datanya belum pernah dilihat). Tidak butuh schema tambahan.
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

  /// Hitung jumlah notifikasi (pengumuman) dari API.
  Future<void> refresh() async {
    if (_loading) return;
    _loading = true;
    try {
      final list = await ApiRepository.instance.getPengumuman();
      _unreadCount = list.length;
      _loaded = true;
    } catch (_) {
      // Jika gagal (mis. offline), biarkan nilai lama.
      // Loaded tetap false → badge tidak ditampilkan.
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Tandai semua sudah dibaca (dipanggil ketika user masuk ke tab Notifikasi).
  void markAllAsRead() {
    if (_unreadCount > 0) {
      _unreadCount = 0;
      notifyListeners();
    }
  }

  /// Reset (untuk logout).
  void reset() {
    _unreadCount = 0;
    _loaded = false;
    _loading = false;
  }
}
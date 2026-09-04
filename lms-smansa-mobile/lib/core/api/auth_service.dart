import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'api_config.dart';

/// Menangani autentikasi siswa: login, logout, simpan/muat token,
/// serta status login (untuk auto-login saat splash).
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final ApiClient _client = ApiClient();

  /// Token siswa yang sedang aktif (null jika belum login).
  String? get token => _client.token;

  /// True jika sudah login (token tersimpan).
  bool get isLoggedIn => _client.token != null && _client.token!.isNotEmpty;

  /// Data siswa hasil login (dari shared_preferences cache).
  Map<String, dynamic>? cachedSiswa;

  /// Login ke server. Simpan token + data siswa ke local storage.
  Future<Map<String, dynamic>> login({
    required String nis,
    required String password,
  }) async {
    final res = await _client.post(
      '/auth/login.php',
      body: {'nis': nis, 'password': password},
    );

    final token = res['token'] as String?;
    final siswa = res['siswa'] as Map<String, dynamic>?;
    if (token == null || siswa == null) {
      throw ApiException('Respons login tidak valid.');
    }

    _client.token = token;
    cachedSiswa = siswa;

    // Simpan ke shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.tokenKey, token);
    await prefs.setString(ApiConfig.siswaKey, jsonEncode(siswa));

    return res;
  }

  /// Cek apakah ada token tersimpan (untuk auto-login).
  Future<bool> tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConfig.tokenKey);
    final siswaRaw = prefs.getString(ApiConfig.siswaKey);

    if (token == null || token.isEmpty) {
      return false;
    }

    _client.token = token;
    if (siswaRaw != null) {
      try {
        cachedSiswa = jsonDecode(siswaRaw) as Map<String, dynamic>;
      } catch (_) {
        cachedSiswa = null;
      }
    }
    return true;
  }

  /// Validasi token ke server. Jika token basi/tidak valid (401),
  /// sesi lokal dihapus dan mengembalikan false (harus login ulang).
  /// Jika error jaringan / server tidak terjangkau, kembalikan true
  /// (biarkan sesi, halaman akan menampilkan error "gagal memuat").
  Future<bool> validateSession() async {
    try {
      await _client.get('/profil.php');
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await logout();
        return false;
      }
      // Error lain (mis. server down, 500): jangan paksa logout.
      return true;
    } catch (_) {
      // Jaringan bermasalah: jangan paksa logout.
      return true;
    }
  }

  /// Logout: hapus token lokal DAN curry token di server.
  Future<void> logout() async {
    try {
      await _client.post('/auth/logout.php');
    } catch (_) {
      // Abaikan error server saat logout; tetap bersihkan lokal.
    }
    _client.token = null;
    cachedSiswa = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);
    await prefs.remove(ApiConfig.siswaKey);
  }

  /// Dapatkan ApiClient dengan token aktif.
  ApiClient get client => _client;
}

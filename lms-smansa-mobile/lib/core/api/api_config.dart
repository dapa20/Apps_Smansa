/// Konfigurasi akses API backend web guru SMANSA.
///
/// Catatan penting:
///  - Saat dijalankan di **emulator Android**, server lokal diakses lewat
///    `http://10.0.2.2/<path>` (alias ke localhost host machine).
///  - Saat dijalankan di **browser/perangkat fisik**, ganti dengan IP
///    LAN komputer, contoh `http://192.168.1.10/lms-smansa`.
class ApiConfig {
  ApiConfig._();

  /// Base URL backend (tanpa trailing slash).
  static const String baseUrl = 'http://10.0.2.2/lms-smansa';

  /// Root path API (tanpa trailing slash).
  static const String apiPath = '$baseUrl/api';

  /// Nama file yang dipakai menyimpan token di shared_preferences.
  static const String tokenKey = 'siswa_token';

  /// Key penyimpanan data siswa di local (untuk tampilan cepat / cache).
  static const String siswaKey = 'siswa_data';
}

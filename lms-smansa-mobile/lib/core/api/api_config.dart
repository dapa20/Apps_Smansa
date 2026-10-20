



///    `http://10.0.2.2/<path>` (alias ke localhost host machine).
///    LAN komputer, contoh `http://192.168.1.10/lms-smansa`.
class ApiConfig {
  ApiConfig._();

  /// - **Chrome (web)**: gunakan `http://localhost/lms-smansa`.
  /// - **Emulator Android**: gunakan `http://10.0.2.2/lms-smansa`.
  /// - **Perangkat fisik Android**: gunakan IP LAN PC, mis. `http://192.168.1.10/lms-smansa`.
  static const String baseUrl = 'http://localhost/lms-smansa';
  static const String apiPath = '$baseUrl/api';
  static const String tokenKey = 'siswa_token';
  static const String siswaKey = 'siswa_data';
}

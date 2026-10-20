import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'auth_service.dart';

/// memakai token aktif dari [AuthService].
class ApiRepository {
  ApiRepository._();

  static final ApiRepository instance = ApiRepository._();

  ApiClient get _client => AuthService.instance.client;

  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _client.get('/dashboard.php');
    return res['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getJadwal({String? hari}) async {
    final res = await _client.get(
      '/jadwal.php',
      query: {if (hari != null && hari.isNotEmpty) 'hari': hari},
    );
    final data = res['data'] as Map<String, dynamic>;
    return (data['jadwal'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getTugas({String jenis = ''}) async {
    final res = await _client.get(
      '/tugas.php',
      query: {if (jenis.isNotEmpty) 'jenis': jenis},
    );
    return (res['data'] as List).cast<Map<String, dynamic>>();
  }

  /// [filePath] = path file lokal yang akan diunggah.
  /// [fileName] = nama file asli (untuk keperluan server).
  Future<Map<String, dynamic>> kumpulTugas({
    required int tugasId,
    String? catatan,
    String? filePath,
    String? fileName,
  }) async {
    if (filePath != null && filePath.isNotEmpty) {
      return _client.postMultipart(
        '/tugas_kumpul.php',
        fields: {'tugas_id': '$tugasId', 'catatan': catatan ?? ''},
        files: {
          'file_jawaban': await http.MultipartFile.fromPath(
            'file_jawaban',
            filePath,
            filename: fileName ?? filePath.split('/').last,
          ),
        },
      );
    }
    return _client.post(
      '/tugas_kumpul.php',
      body: {'tugas_id': tugasId, 'catatan': catatan ?? ''},
    );
  }

  Future<List<Map<String, dynamic>>> getMateriDaftarMapel() async {
    final res = await _client.get('/materi.php');
    return (res['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getMateriDetail(int mapelId) async {
    final res = await _client.get(
      '/materi.php',
      query: {'mapel_id': '$mapelId', 'detail': '1'},
    );
    return res['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getKehadiran({int limit = 30}) async {
    final res = await _client.get('/kehadiran.php', query: {'limit': '$limit'});
    return res['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getNilai({
    String semester = 'Ganjil',
    String? tahunAjaran,
  }) async {
    final res = await _client.get(
      '/nilai.php',
      query: {
        'semester': semester,
        if (tahunAjaran != null) 'tahun_ajaran': tahunAjaran,
      },
    );
    return res['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getPengumuman() async {
    final res = await _client.get('/pengumuman.php');
    return (res['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getKalender() async {
    final res = await _client.get('/kalender.php');
    return res['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProfil() async {
    final res = await _client.get('/profil.php');
    return res['data'] as Map<String, dynamic>;
  }

  /// Ubah password siswa.
  /// Return [success] = true kalau berhasil, false kalau gagal.
  /// [message] berisi pesan dari server (untuk ditampilkan ke user).
  Future<Map<String, dynamic>> updatePassword({
    required String passwordLama,
    required String passwordBaru,
    required String passwordKonfirmasi,
  }) async {
    final res = await _client.post(
      '/password_update.php',
      body: {
        'password_lama': passwordLama,
        'password_baru': passwordBaru,
        'password_konfirmasi': passwordKonfirmasi,
      },
    );
    return res;
  }
}

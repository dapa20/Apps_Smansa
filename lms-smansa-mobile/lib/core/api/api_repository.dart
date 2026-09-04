import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'auth_service.dart';

/// Repository layanan data siswa. Semua method memanggil API backend
/// memakai token aktif dari [AuthService].
class ApiRepository {
  ApiRepository._();

  static final ApiRepository instance = ApiRepository._();

  ApiClient get _client => AuthService.instance.client;

  /// Data dashboard (beranda): tugas aktif, persen kehadiran, materi terbaru, pengumuman.
  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _client.get('/dashboard.php');
    return res['data'] as Map<String, dynamic>;
  }

  /// Jadwal pelajaran berdasarkan kelas siswa. Opsional filter `hari` (Senin-Sabtu).
  Future<List<Map<String, dynamic>>> getJadwal({String? hari}) async {
    final res = await _client.get(
      '/jadwal.php',
      query: {if (hari != null && hari.isNotEmpty) 'hari': hari},
    );
    final data = res['data'] as Map<String, dynamic>;
    return (data['jadwal'] as List).cast<Map<String, dynamic>>();
  }

  /// Daftar tugas & ujian siswa (opsional filter jenis).
  Future<List<Map<String, dynamic>>> getTugas({String jenis = ''}) async {
    final res = await _client.get(
      '/tugas.php',
      query: {if (jenis.isNotEmpty) 'jenis': jenis},
    );
    return (res['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Kumpulkan tugas. Opsional sertakan file jawaban (upload via multipart).
  /// [filePath] = path file lokal yang akan diunggah.
  /// [fileName] = nama file asli (untuk keperluan server).
  Future<Map<String, dynamic>> kumpulTugas({
    required int tugasId,
    String? catatan,
    String? filePath,
    String? fileName,
  }) async {
    if (filePath != null && filePath.isNotEmpty) {
      // Upload dengan file jawaban (multipart/form-data).
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

  /// Daftar mapel yang dipelajari (untuk menu Materi).
  Future<List<Map<String, dynamic>>> getMateriDaftarMapel() async {
    final res = await _client.get('/materi.php');
    return (res['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Detail materi per mapel (sections & items).
  Future<Map<String, dynamic>> getMateriDetail(int mapelId) async {
    final res = await _client.get(
      '/materi.php',
      query: {'mapel_id': '$mapelId', 'detail': '1'},
    );
    return res['data'] as Map<String, dynamic>;
  }

  /// Riwayat kehadiran & ringkasan.
  Future<Map<String, dynamic>> getKehadiran({int limit = 30}) async {
    final res = await _client.get('/kehadiran.php', query: {'limit': '$limit'});
    return res['data'] as Map<String, dynamic>;
  }

  /// Nilai siswa per semester.
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

  /// Daftar pengumuman.
  Future<List<Map<String, dynamic>>> getPengumuman() async {
    final res = await _client.get('/pengumuman.php');
    return (res['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Kalender akademik realtime (jadwal ujian + deadline tugas + libur nasional).
  Future<Map<String, dynamic>> getKalender() async {
    final res = await _client.get('/kalender.php');
    return res['data'] as Map<String, dynamic>;
  }

  /// Profil lengkap siswa.
  Future<Map<String, dynamic>> getProfil() async {
    final res = await _client.get('/profil.php');
    return res['data'] as Map<String, dynamic>;
  }
}

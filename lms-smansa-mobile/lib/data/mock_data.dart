import 'package:flutter/material.dart';
import '../models/siswa.dart';
import '../models/jadwal.dart';
import '../models/tugas.dart';
import '../models/ujian.dart';
import '../models/nilai_mapel.dart';
import '../models/semester_summary.dart';
import '../models/berita.dart';
import '../models/event_kalender.dart';
import '../models/portal_item.dart';

// ─── SISWA ──────────────────────────────────────────────────────────
class MockSiswa {
  static const siswaLogin = Siswa(
    id: 4,
    nis: '1920104',
    nisn: '0045612389',
    namaLengkap: 'Aditya Pratama',
    kelas: 'XII MIPA 1',
    foto: null,
    statusKehadiran: 98.0,
    poinAkademik: 1240,
  );
}

// ─── JADWAL ─────────────────────────────────────────────────────────
class MockJadwal {
  static const Map<String, List<JadwalItem>> jadwalPerHari = {
    'Senin': [
      JadwalItem(jamMulai: '07:15', jamSelesai: '08:45', namaMapel: 'Upacara Bendera', namaGuru: '', ruang: 'Lapangan Utama'),
      JadwalItem(jamMulai: '08:45', jamSelesai: '09:00', namaMapel: 'Istirahat', namaGuru: '', ruang: '', isIstirahat: true),
      JadwalItem(jamMulai: '09:00', jamSelesai: '10:30', namaMapel: 'Matematika Wajib', namaGuru: 'Drs. Budi Santoso, M.Pd', ruang: 'Ruang XI MIPA 1', tugasAktif: 1),
      JadwalItem(jamMulai: '10:30', jamSelesai: '12:00', namaMapel: 'Fisika', namaGuru: 'Dra. Siti Aminah', ruang: 'Lab Fisika 2'),
    ],
    'Selasa': [
      JadwalItem(jamMulai: '07:00', jamSelesai: '08:30', namaMapel: 'Bahasa Indonesia', namaGuru: 'Pak Herman', ruang: 'Ruang XII MIPA 1'),
      JadwalItem(jamMulai: '08:30', jamSelesai: '08:45', namaMapel: 'Istirahat', namaGuru: '', ruang: '', isIstirahat: true),
      JadwalItem(jamMulai: '08:45', jamSelesai: '10:15', namaMapel: 'Kimia', namaGuru: 'Ibu Ratna, S.Pd', ruang: 'Lab Kimia'),
      JadwalItem(jamMulai: '10:15', jamSelesai: '11:45', namaMapel: 'Sejarah', namaGuru: 'Bu Rina', ruang: 'Ruang XII MIPA 1'),
    ],
    'Rabu': [
      JadwalItem(jamMulai: '07:00', jamSelesai: '08:30', namaMapel: 'Fisika Lanjut', namaGuru: 'Drs. Bambang', ruang: 'Lab A'),
      JadwalItem(jamMulai: '08:30', jamSelesai: '08:45', namaMapel: 'Istirahat', namaGuru: '', ruang: '', isIstirahat: true),
      JadwalItem(jamMulai: '08:45', jamSelesai: '10:15', namaMapel: 'Bahasa Inggris', namaGuru: 'Mr. Dani', ruang: 'Ruang XII MIPA 1'),
      JadwalItem(jamMulai: '10:15', jamSelesai: '11:45', namaMapel: 'Matematika Peminatan', namaGuru: 'Drs. Budi Santoso, M.Pd', ruang: 'Ruang XII MIPA 1'),
    ],
    'Kamis': [
      JadwalItem(jamMulai: '07:00', jamSelesai: '08:30', namaMapel: 'Biologi', namaGuru: 'Ibu Dewi, S.Pd', ruang: 'Lab Biologi'),
      JadwalItem(jamMulai: '08:30', jamSelesai: '08:45', namaMapel: 'Istirahat', namaGuru: '', ruang: '', isIstirahat: true),
      JadwalItem(jamMulai: '08:45', jamSelesai: '10:15', namaMapel: 'Pendidikan Agama', namaGuru: 'Ustadz Ahmad', ruang: 'Ruang XII MIPA 1'),
      JadwalItem(jamMulai: '10:15', jamSelesai: '11:45', namaMapel: 'PPKN', namaGuru: 'Pak Wahyu', ruang: 'Ruang XII MIPA 1'),
    ],
    'Jumat': [
      JadwalItem(jamMulai: '07:00', jamSelesai: '08:30', namaMapel: 'Olahraga', namaGuru: 'Pak Joko', ruang: 'Lapangan'),
      JadwalItem(jamMulai: '08:30', jamSelesai: '08:45', namaMapel: 'Istirahat', namaGuru: '', ruang: '', isIstirahat: true),
      JadwalItem(jamMulai: '08:45', jamSelesai: '10:15', namaMapel: 'Seni Budaya', namaGuru: 'Bu Lina', ruang: 'Ruang Seni'),
    ],
  };
}

// ─── TUGAS ───────────────────────────────────────────────────────────
class MockTugas {
  static final List<Tugas> belumSelesai = [
    Tugas(
      id: 1,
      judul: 'Laporan Praktikum Fisika: Gerak Jatuh Bebas',
      namaMapel: 'Fisika Lanjut',
      status: 'menunggu',
      deadline: DateTime.now().add(const Duration(days: 1, hours: 12)),
      aksiLabel: 'Kerjakan',
    ),
    Tugas(
      id: 2,
      judul: 'Analisis Novel "Bumi Manusia" Bab 1-5',
      namaMapel: 'Bahasa Indonesia',
      status: 'terlambat',
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      aksiLabel: 'Kirim Susulan',
    ),
    Tugas(
      id: 3,
      judul: 'Tugas Matriks dan Vektor Lanjutan',
      namaMapel: 'Matematika Peminatan',
      status: 'menunggu',
      deadline: DateTime.now().add(const Duration(days: 5)),
      aksiLabel: 'Detail',
    ),
  ];

  static final List<Tugas> selesai = [
    Tugas(id: 4, judul: 'PR Aljabar Bab 3', namaMapel: 'Matematika Wajib', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 7))),
    Tugas(id: 5, judul: 'Essay Sejarah Indonesia', namaMapel: 'Sejarah', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 10))),
    Tugas(id: 6, judul: 'Laporan Praktikum Kimia', namaMapel: 'Kimia', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 12))),
    Tugas(id: 7, judul: 'Presentasi Biologi Sel', namaMapel: 'Biologi', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 14))),
    Tugas(id: 8, judul: 'Tugas Trigonometri', namaMapel: 'Matematika Wajib', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 15))),
    Tugas(id: 9, judul: 'Reading Comprehension', namaMapel: 'Bahasa Inggris', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 17))),
    Tugas(id: 10, judul: 'Analisis Puisi', namaMapel: 'Bahasa Indonesia', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 20))),
    Tugas(id: 11, judul: 'Hukum Newton I & II', namaMapel: 'Fisika Lanjut', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 22))),
    Tugas(id: 12, judul: 'Reaksi Redoks', namaMapel: 'Kimia', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 25))),
    Tugas(id: 13, judul: 'Soal Integral', namaMapel: 'Matematika Peminatan', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 28))),
    Tugas(id: 14, judul: 'Makalah PPKN', namaMapel: 'PPKN', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 30))),
    Tugas(id: 15, judul: 'Listening Practice', namaMapel: 'Bahasa Inggris', status: 'selesai', deadline: DateTime.now().subtract(const Duration(days: 32))),
  ];
}

// ─── UJIAN ───────────────────────────────────────────────────────────
class MockUjian {
  static final List<Ujian> berlangsung = [
    Ujian(
      id: 1,
      judul: 'Ujian Tengah Semester - Biologi',
      jenis: 'uts',
      namaMapel: 'Biologi',
      namaGuru: 'Bpk. Budi Santoso',
      namaKelas: 'Kelas XI MIPA 1',
      jumlahSoal: 40,
      tipeSoal: 'Pilihan Ganda',
      jadwal: DateTime.now(),
      sisaMenit: 45,
      status: 'berlangsung',
    ),
  ];

  static final List<Ujian> mendatang = [
    Ujian(
      id: 2,
      judul: 'Kuis Harian - Matematika Peminatan',
      jenis: 'kuis',
      namaMapel: 'Matematika',
      namaGuru: 'Ibu Rina',
      namaKelas: 'XII MIPA 1',
      jumlahSoal: 20,
      tipeSoal: 'Pilihan Ganda',
      jadwal: DateTime.now().add(const Duration(days: 1)),
      status: 'mendatang',
    ),
    Ujian(
      id: 3,
      judul: 'Ulangan Harian - Sejarah Indonesia',
      jenis: 'kuis',
      namaMapel: 'Sejarah',
      namaGuru: 'Bpk. Andi',
      namaKelas: 'XII MIPA 1',
      jumlahSoal: 25,
      tipeSoal: 'Pilihan Ganda & Essay',
      jadwal: DateTime.now().add(const Duration(days: 3)),
      status: 'mendatang',
    ),
  ];
}

// ─── NILAI ───────────────────────────────────────────────────────────
class MockNilai {
  static const List<SemesterSummary> semesters = [
    SemesterSummary(semesterKe: 4, tahunAjaran: '2023/2024', periode: 'Genap', ips: 90.2, target: 85.0),
    SemesterSummary(semesterKe: 3, tahunAjaran: '2023/2024', periode: 'Ganjil', ips: 88.5, target: 85.0),
    SemesterSummary(semesterKe: 2, tahunAjaran: '2022/2023', periode: 'Genap', ips: 86.7, target: 82.0),
    SemesterSummary(semesterKe: 1, tahunAjaran: '2022/2023', periode: 'Ganjil', ips: 84.3, target: 80.0),
  ];

  static const double rataRataKumulatif = 88.5;

  static List<NilaiMapel> nilaiSemester4 = [
    NilaiMapel(namaMapel: 'Matematika Wajib', namaGuru: 'Pak Budi S.', kkm: 75, nilaiAkhir: 92, hurufMutu: 'A', ikonColor: const Color(0xFF2563EB), ikonLabel: 'Σ'),
    NilaiMapel(namaMapel: 'Fisika', namaGuru: 'Bu Siti A.', kkm: 75, nilaiAkhir: 88, hurufMutu: 'A-', ikonColor: const Color(0xFFDC2626), ikonLabel: '√'),
    NilaiMapel(namaMapel: 'Bahasa Indonesia', namaGuru: 'Pak Herman', kkm: 78, nilaiAkhir: 95, hurufMutu: 'A+', ikonColor: const Color(0xFFF59E0B), ikonLabel: '📖'),
    NilaiMapel(namaMapel: 'Sejarah', namaGuru: 'Bu Rina', kkm: 75, nilaiAkhir: 82, hurufMutu: 'B', ikonColor: const Color(0xFF6B7280), ikonLabel: '🏛'),
    NilaiMapel(namaMapel: 'Kimia', namaGuru: 'Bu Ratna', kkm: 75, nilaiAkhir: 89, hurufMutu: 'A-', ikonColor: const Color(0xFF059669), ikonLabel: '⚗'),
    NilaiMapel(namaMapel: 'Biologi', namaGuru: 'Bu Dewi', kkm: 75, nilaiAkhir: 91, hurufMutu: 'A', ikonColor: const Color(0xFF7C3AED), ikonLabel: '🧬'),
  ];
}

// ─── BERITA ──────────────────────────────────────────────────────────
class MockBerita {
  static final List<Berita> daftarBerita = [
    Berita(
      id: 1,
      judul: 'Persiapan Ujian Akhir Semester Genap 2024',
      kategori: 'pengumuman',
      konten: 'Mohon seluruh siswa mempersiapkan diri untuk UAS. Jadwal dapat dilihat di menu Kalender Akademik.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Berita(
      id: 2,
      judul: 'Siswa SMANSA Raih Medali Olimpiade Sains',
      kategori: 'prestasi',
      konten: 'Selamat kepada tim olimpiade sains yang berhasil meraih medali emas di kompetisi tingkat provinsi.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Berita(
      id: 3,
      judul: 'Jadwal Kegiatan Class Meeting',
      kategori: 'kegiatan',
      konten: 'Class meeting akan dilaksanakan pada tanggal 15-17 Juni 2024. Pendaftaran dibuka via formulir online.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Berita(
      id: 4,
      judul: 'Update Sistem Presensi Digital',
      kategori: 'pengumuman',
      konten: 'Sistem presensi digital telah diperbarui. Pastikan aplikasi mobile Anda sudah versi terbaru.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
}

// ─── KALENDER ────────────────────────────────────────────────────────
class MockKalender {
  static final List<EventKalender> events = [
    EventKalender(
      tanggalMulai: DateTime(2023, 10, 10),
      tanggalSelesai: DateTime(2023, 10, 13),
      judul: 'Ujian Tengah Semester (UTS)',
      kategori: 'akademik',
      waktu: '07:00 - 12:00 WIB',
      deskripsi: 'Persiapkan diri dengan baik. Jadwal lengkap per mata pelajaran dapat diunduh di portal pengumuman.',
    ),
    EventKalender(
      tanggalMulai: DateTime(2023, 10, 28),
      tanggalSelesai: DateTime(2023, 10, 28),
      judul: 'Hari Sumpah Pemuda',
      kategori: 'libur',
      lokasi: 'Libur Nasional',
    ),
    EventKalender(
      tanggalMulai: DateTime(2023, 11, 10),
      tanggalSelesai: DateTime(2023, 11, 10),
      judul: 'HUT SMANSA ke-45',
      kategori: 'kegiatan',
      lokasi: 'Lapangan Utama',
      deskripsi: 'Acara puncak peringatan hari ulang tahun sekolah. Wajib dihadiri oleh seluruh siswa.',
    ),
    EventKalender(
      tanggalMulai: DateTime(2023, 12, 4),
      tanggalSelesai: DateTime(2023, 12, 9),
      judul: 'Ujian Akhir Semester (UAS)',
      kategori: 'akademik',
      waktu: '07:00 - 12:00 WIB',
    ),
    EventKalender(
      tanggalMulai: DateTime(2023, 12, 25),
      tanggalSelesai: DateTime(2024, 1, 1),
      judul: 'Libur Natal & Tahun Baru',
      kategori: 'libur',
    ),
  ];
}

// ─── SMANSAGO ────────────────────────────────────────────────────────
class MockSmansago {
  static const List<PortalItem> portals = [
    PortalItem(judul: 'E-Rapor', deskripsi: 'Lihat rapor digital', ikonName: 'assignment'),
    PortalItem(judul: 'Perpustakaan', deskripsi: 'Katalog buku', ikonName: 'menu_book'),
    PortalItem(judul: 'Ekstrakurikuler', deskripsi: 'Info ekskul', ikonName: 'sports_basketball'),
    PortalItem(judul: 'Pengumuman', deskripsi: 'Info terbaru', ikonName: 'campaign', hasNotification: true),
  ];

  static const List<Map<String, String>> socialMedia = [
    {'nama': 'Instagram', 'icon': 'camera_alt'},
    {'nama': 'YouTube', 'icon': 'play_circle'},
    {'nama': 'Website', 'icon': 'language'},
  ];
}

// ─── NOTIFIKASI ──────────────────────────────────────────────────────
class MockNotifikasi {
  static final List<Map<String, dynamic>> daftarNotifikasi = [
    {
      'judul': 'Tugas Baru: Laporan Praktikum Fisika',
      'deskripsi': 'Drs. Bambang menambahkan tugas baru untuk kelas XII MIPA 1',
      'tipe': 'tugas',
      'waktu': DateTime.now().subtract(const Duration(hours: 1)),
      'dibaca': false,
    },
    {
      'judul': 'Nilai Matematika Telah Diperbarui',
      'deskripsi': 'Nilai UTS Matematika Wajib Anda telah diinput oleh guru',
      'tipe': 'nilai',
      'waktu': DateTime.now().subtract(const Duration(hours: 3)),
      'dibaca': false,
    },
    {
      'judul': 'Pengumuman: Jadwal UAS',
      'deskripsi': 'Jadwal Ujian Akhir Semester telah dipublikasikan',
      'tipe': 'pengumuman',
      'waktu': DateTime.now().subtract(const Duration(days: 1)),
      'dibaca': true,
    },
    {
      'judul': 'Kehadiran Tercatat',
      'deskripsi': 'Kehadiran Anda hari ini telah dicatat: Hadir',
      'tipe': 'kehadiran',
      'waktu': DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      'dibaca': true,
    },
    {
      'judul': 'Tugas Deadline Besok',
      'deskripsi': 'Jangan lupa kumpulkan tugas Bahasa Indonesia sebelum besok',
      'tipe': 'tugas',
      'waktu': DateTime.now().subtract(const Duration(days: 2)),
      'dibaca': true,
    },
  ];
}

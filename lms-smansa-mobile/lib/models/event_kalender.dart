class EventKalender {
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String judul;
  final String kategori; // 'akademik' | 'libur' | 'kegiatan'
  final String? waktu;
  final String? lokasi;
  final String? deskripsi;

  const EventKalender({
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.judul,
    required this.kategori,
    this.waktu,
    this.lokasi,
    this.deskripsi,
  });
}

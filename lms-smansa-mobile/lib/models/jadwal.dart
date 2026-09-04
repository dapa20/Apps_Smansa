class JadwalItem {
  final String jamMulai;
  final String jamSelesai;
  final String namaMapel;
  final String namaGuru;
  final String ruang;
  final bool isIstirahat;
  final int tugasAktif;

  const JadwalItem({
    required this.jamMulai,
    required this.jamSelesai,
    required this.namaMapel,
    required this.namaGuru,
    required this.ruang,
    this.isIstirahat = false,
    this.tugasAktif = 0,
  });

  factory JadwalItem.fromJson(Map<String, dynamic> json) {
    return JadwalItem(
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      namaMapel: json['nama_mapel'],
      namaGuru: json['nama_guru'] ?? '',
      ruang: json['ruang'] ?? '',
      isIstirahat: json['is_istirahat'] ?? false,
      tugasAktif: json['tugas_aktif'] ?? 0,
    );
  }
}

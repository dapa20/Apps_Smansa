class Siswa {
  final int id;
  final String nis;
  final String nisn;
  final String namaLengkap;
  final String kelas;
  final String? foto;
  final double statusKehadiran;
  final int poinAkademik;

  const Siswa({
    required this.id,
    required this.nis,
    required this.nisn,
    required this.namaLengkap,
    required this.kelas,
    this.foto,
    required this.statusKehadiran,
    required this.poinAkademik,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'],
      nis: json['nis'],
      nisn: json['nisn'],
      namaLengkap: json['nama_lengkap'],
      kelas: json['kelas'],
      foto: json['foto'],
      statusKehadiran: (json['status_kehadiran'] as num).toDouble(),
      poinAkademik: json['poin_akademik'],
    );
  }
}

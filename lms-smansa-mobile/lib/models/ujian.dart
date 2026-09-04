class Ujian {
  final int id;
  final String judul;
  final String jenis; // 'kuis' | 'uts' | 'uas'
  final String namaMapel;
  final String namaGuru;
  final String namaKelas;
  final int jumlahSoal;
  final String tipeSoal;
  final DateTime jadwal;
  final int? sisaMenit;
  final String status; // 'berlangsung' | 'mendatang' | 'selesai'

  const Ujian({
    required this.id,
    required this.judul,
    required this.jenis,
    required this.namaMapel,
    required this.namaGuru,
    required this.namaKelas,
    required this.jumlahSoal,
    required this.tipeSoal,
    required this.jadwal,
    this.sisaMenit,
    required this.status,
  });

  factory Ujian.fromJson(Map<String, dynamic> json) {
    return Ujian(
      id: json['id'],
      judul: json['judul'],
      jenis: json['jenis'],
      namaMapel: json['nama_mapel'],
      namaGuru: json['nama_guru'],
      namaKelas: json['nama_kelas'],
      jumlahSoal: json['jumlah_soal'],
      tipeSoal: json['tipe_soal'],
      jadwal: DateTime.parse(json['jadwal']),
      sisaMenit: json['sisa_menit'],
      status: json['status'],
    );
  }
}

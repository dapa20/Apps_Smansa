class Tugas {
  final int id;
  final String judul;
  final String namaMapel;
  final String status; // 'menunggu' | 'terlambat' | 'selesai'
  final DateTime deadline;
  final String? aksiLabel; // 'Kerjakan' | 'Kirim Susulan' | 'Detail'

  const Tugas({
    required this.id,
    required this.judul,
    required this.namaMapel,
    required this.status,
    required this.deadline,
    this.aksiLabel,
  });

  factory Tugas.fromJson(Map<String, dynamic> json) {
    return Tugas(
      id: json['id'],
      judul: json['judul'],
      namaMapel: json['nama_mapel'],
      status: json['status'],
      deadline: DateTime.parse(json['tanggal_deadline']),
      aksiLabel: json['aksi_label'],
    );
  }
}

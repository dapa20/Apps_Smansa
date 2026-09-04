class Berita {
  final int id;
  final String judul;
  final String kategori; // 'pengumuman' | 'prestasi' | 'kegiatan'
  final String? gambarUrl;
  final String konten;
  final DateTime createdAt;

  const Berita({
    required this.id,
    required this.judul,
    required this.kategori,
    this.gambarUrl,
    required this.konten,
    required this.createdAt,
  });
}

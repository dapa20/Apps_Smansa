class PortalItem {
  final String judul;
  final String deskripsi;
  final String ikonName;
  final String? url;
  final bool hasNotification;

  const PortalItem({
    required this.judul,
    required this.deskripsi,
    required this.ikonName,
    this.url,
    this.hasNotification = false,
  });
}

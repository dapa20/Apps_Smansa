import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../app/notification_badge_controller.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  List<Map<String, dynamic>>? _pengumuman;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Tandai semua notifikasi sudah dibaca saat user masuk tab ini
    NotificationBadgeController.instance.markAllAsRead();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ApiRepository.instance.getPengumuman();
      if (!mounted) return;
      setState(() {
        _pengumuman = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BlueHeader(title: 'Notifikasi'),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
            ],
          ),
        ),
      );
    }

    final list = _pengumuman ?? [];
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada notifikasi.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildNotifCard(list[index]),
    );
  }

  Widget _buildNotifCard(Map<String, dynamic> notif) {
    final tipe = (notif['kategori'] ?? 'info') as String;
    final waktuRaw = notif['created_at'] as String?;
    final waktu = waktuRaw != null ? DateTime.tryParse(waktuRaw) : null;

    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (tipe.toLowerCase()) {
      case 'tugas':
        icon = Icons.assignment;
        iconColor = AppColors.primaryBlue;
        iconBg = AppColors.chipBlueBg;
        break;
      case 'nilai':
        icon = Icons.stars;
        iconColor = AppColors.chipGreenText;
        iconBg = AppColors.chipGreenBg;
        break;
      case 'pengumuman':
      case 'penting':
        icon = Icons.campaign;
        iconColor = AppColors.chipYellowText;
        iconBg = AppColors.chipYellowBg;
        break;
      case 'kehadiran':
        icon = Icons.fact_check;
        iconColor = AppColors.chipPurpleText;
        iconBg = AppColors.chipPurpleBg;
        break;
      default:
        icon = Icons.notifications;
        iconColor = AppColors.textSecondary;
        iconBg = AppColors.divider;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['judul'] ?? '-', style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(notif['isi'] ?? '', style: AppTextStyles.bodySecondary),
                const SizedBox(height: 8),
                Text(
                  waktu != null ? _formatWaktu(waktu) : '',
                  style: AppTextStyles.smallText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatWaktu(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit yang lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam yang lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy, HH:mm').format(time);
    }
  }
}

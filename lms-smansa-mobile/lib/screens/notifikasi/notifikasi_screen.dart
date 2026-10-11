import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
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
        const BlueHeader(title: 'Notifikasi', subtitle: 'Pengumuman terbaru untukmu'),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primaryBlue,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 36,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
            ],
          ),
        ),
      );
    }

    final list = _pengumuman ?? [];
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_rounded,
                size: 40,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada notifikasi',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: 4),
            Text(
              'Notifikasi baru akan muncul di sini',
              style: AppTextStyles.smallText,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.responsivePadding(MediaQuery.of(context).size.width),
        vertical: 20,
      ),
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
        icon = Icons.assignment_rounded;
        iconColor = AppColors.primaryBlue;
        iconBg = AppColors.chipBlueBg;
        break;
      case 'nilai':
        icon = Icons.stars_rounded;
        iconColor = AppColors.chipGreenText;
        iconBg = AppColors.chipGreenBg;
        break;
      case 'pengumuman':
      case 'penting':
        icon = Icons.campaign_rounded;
        iconColor = AppColors.chipYellowText;
        iconBg = AppColors.chipYellowBg;
        break;
      case 'kehadiran':
        icon = Icons.fact_check_rounded;
        iconColor = AppColors.chipPurpleText;
        iconBg = AppColors.chipPurpleBg;
        break;
      default:
        icon = Icons.notifications_rounded;
        iconColor = AppColors.textSecondary;
        iconBg = AppColors.surfaceMuted;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['judul'] ?? '-', style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(
                  notif['isi'] ?? '',
                  style: AppTextStyles.bodySecondary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  waktu != null ? _formatWaktu(waktu) : '',
                  style: AppTextStyles.caption,
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
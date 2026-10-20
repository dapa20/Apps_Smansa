import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';
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
    final list = _pengumuman ?? [];

    return Column(
      children: [
        BlueHeader(
          eyebrow: 'Pusat Informasi',
          title: 'Notifikasi',
          subtitle: 'Semua kabar terbaru untukmu, di satu tempat.',
          height: 150,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mark_email_read_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  _loading ? 'Memuat' : '${list.length} pesan',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const AppLoadingView(message: 'Memuat notifikasi...');
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    final list = _pengumuman ?? [];
    if (list.isEmpty) {
      return const AppEmptyView(
        icon: Icons.notifications_off_rounded,
        title: 'Belum ada notifikasi',
        subtitle: 'Notifikasi baru akan muncul di sini.',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primaryBlue,
      backgroundColor: Colors.white,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppConstants.responsivePadding(MediaQuery.of(context).size.width),
          20,
          AppConstants.responsivePadding(MediaQuery.of(context).size.width),
          28,
        ),
        children: [
          Row(
            children: [
              Text('Terbaru', style: AppTextStyles.sectionTitle),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${list.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Dibaca otomatis',
                style: AppTextStyles.caption.copyWith(fontSize: 9.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < list.length; i++) ...[
            _buildNotifCard(list[i]),
            if (i != list.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildNotifCard(Map<String, dynamic> notif) {
    final tipe = (notif['kategori'] ?? 'info') as String;
    final waktuRaw = notif['created_at'] as String?;
    final waktu = waktuRaw != null ? DateTime.tryParse(waktuRaw) : null;

    final style = _styleFor(tipe);

    return SurfaceCard(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconTile(
            icon: style.icon,
            color: style.color,
            size: 46,
            iconSize: 21,
            radius: 14,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: style.color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        style.label,
                        style: AppTextStyles.chipText.copyWith(
                          color: style.color,
                          fontSize: 8.5,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      waktu != null ? _formatWaktu(waktu) : '',
                      style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notif['judul'] ?? '-',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  notif['isi'] ?? '',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _NotifStyle _styleFor(String tipe) {
    switch (tipe.toLowerCase()) {
      case 'tugas':
        return const _NotifStyle(
          icon: Icons.assignment_rounded,
          color: AppColors.primaryBlue,
          label: 'TUGAS',
        );
      case 'nilai':
        return const _NotifStyle(
          icon: Icons.stars_rounded,
          color: AppColors.accentMint,
          label: 'NILAI',
        );
      case 'pengumuman':
      case 'penting':
        return const _NotifStyle(
          icon: Icons.campaign_rounded,
          color: AppColors.accentAmber,
          label: 'PENGUMUMAN',
        );
      case 'kehadiran':
        return const _NotifStyle(
          icon: Icons.fact_check_rounded,
          color: AppColors.accentPurple,
          label: 'KEHADIRAN',
        );
      default:
        return const _NotifStyle(
          icon: Icons.notifications_rounded,
          color: AppColors.textSecondary,
          label: 'INFO',
        );
    }
  }

  String _formatWaktu(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(time);
    }
  }
}

class _NotifStyle {
  final IconData icon;
  final Color color;
  final String label;

  const _NotifStyle({
    required this.icon,
    required this.color,
    required this.label,
  });
}

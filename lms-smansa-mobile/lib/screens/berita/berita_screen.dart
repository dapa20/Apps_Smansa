import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  List<Map<String, dynamic>>? _pengumuman;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
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
        BlueHeader(
          eyebrow: 'Kabar Sekolah',
          title: 'Berita & Pengumuman',
          subtitle: 'Informasi terkini dari SMA Negeri 1 Bumiayu.',
          height: 150,
          trailing: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: const Icon(
              Icons.newspaper_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const AppLoadingView(message: 'Memuat berita sekolah...');
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    final list = _pengumuman ?? [];
    if (list.isEmpty) {
      return const AppEmptyView(
        icon: Icons.newspaper_rounded,
        title: 'Belum ada berita',
        subtitle: 'Berita terbaru akan muncul di sini.',
      );
    }

    final first = list.first;
    final rest = list.skip(1).toList();

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
          _buildFeaturedCard(first),
          if (rest.isNotEmpty) ...[
            const SizedBox(height: 26),
            Row(
              children: [
                Text('Semua Berita', style: AppTextStyles.sectionTitle),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${rest.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < rest.length; i++) ...[
              _buildBeritaCard(rest[i]),
              if (i != rest.length - 1) const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> item) {
    final kategori = (item['kategori'] ?? 'info') as String;
    final createdAt = item['created_at'] != null
        ? DateTime.tryParse(item['created_at'] as String)
        : null;
    final accent = _categoryColor(kategori);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 22,
            offset: const Offset(0, 10),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover abstrak karena data tidak menyertakan gambar.
          Container(
            height: 132,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent,
                  Color.lerp(accent, AppColors.navy, 0.55) ?? accent,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -28,
                  top: -34,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Positioned(
                  right: 28,
                  bottom: -44,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 34,
                  top: 34,
                  child: Icon(
                    _categoryIcon(kategori),
                    color: Colors.white.withValues(alpha: 0.28),
                    size: 64,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'BERITA UTAMA',
                              style: AppTextStyles.chipText.copyWith(
                                color: Colors.white,
                                fontSize: 8.5,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        kategori.toUpperCase(),
                        style: AppTextStyles.chipText.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 9,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      createdAt != null
                          ? DateFormat('EEEE, dd MMMM yyyy').format(createdAt)
                          : '-',
                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  item['judul'] ?? '-',
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 18,
                    height: 1.3,
                    letterSpacing: -0.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item['isi'] ?? '',
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'Baca selengkapnya',
                      style: AppTextStyles.caption.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 13, color: accent),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(
                        Icons.bookmark_outline_rounded,
                        size: 16,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeritaCard(Map<String, dynamic> pengumuman) {
    final kategori = (pengumuman['kategori'] ?? 'info') as String;
    final createdAt = pengumuman['created_at'] != null
        ? DateTime.tryParse(pengumuman['created_at'] as String)
        : null;

    final accent = _categoryColor(kategori);
    final statusType = _statusType(kategori);

    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blok tanggal.
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: [
                Text(
                  createdAt != null ? DateFormat('dd').format(createdAt) : '--',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: accent,
                    fontSize: 19,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  createdAt != null
                      ? DateFormat('MMM').format(createdAt).toUpperCase()
                      : '---',
                  style: AppTextStyles.caption.copyWith(
                    color: accent,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusChip(label: kategori.toUpperCase(), type: statusType),
                    const Spacer(),
                    if (createdAt != null)
                      Text(
                        DateFormat('yyyy').format(createdAt),
                        style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pengumuman['judul'] ?? '-',
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 14,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  pengumuman['isi'] ?? '',
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'pengumuman':
      case 'penting':
        return AppColors.accentAmber;
      case 'prestasi':
        return AppColors.accentMint;
      case 'kegiatan':
        return AppColors.accentPurple;
      default:
        return AppColors.primaryBlue;
    }
  }

  String _statusType(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'pengumuman':
      case 'penting':
        return 'penting';
      case 'prestasi':
        return 'selesai';
      case 'kegiatan':
        return 'kegiatan';
      default:
        return 'info';
    }
  }

  IconData _categoryIcon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'prestasi':
        return Icons.emoji_events_rounded;
      case 'kegiatan':
        return Icons.celebration_rounded;
      case 'pengumuman':
        return Icons.campaign_rounded;
      default:
        return Icons.article_rounded;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/responsive_container.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';
import '../../app/routes.dart';
import '../../app/main_shell_controller.dart';
import '../../app/notification_badge_controller.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  String get _nama {
    final siswa = _data?['siswa'];
    if (siswa is Map<String, dynamic> && siswa['nama_lengkap'] != null) {
      return siswa['nama_lengkap'] as String;
    }
    return 'Siswa';
  }

  String get _namaKelas {
    final siswa = _data?['siswa'];
    if (siswa is Map<String, dynamic> && siswa['nama_kelas'] != null) {
      return siswa['nama_kelas'] as String;
    }
    return AppConstants.currentSemester;
  }

  List<dynamic> get _pengumuman => (_data?['pengumuman'] as List?) ?? const [];

  List<dynamic> get _materiTerbaru =>
      (_data?['materi_terbaru'] as List?) ?? const [];

  @override
  void initState() {
    super.initState();
    _load();
    NotificationBadgeController.instance.addListener(_onBadgeChanged);
    NotificationBadgeController.instance.refresh();
  }

  @override
  void dispose() {
    NotificationBadgeController.instance.removeListener(_onBadgeChanged);
    super.dispose();
  }

  void _onBadgeChanged() {
    if (mounted) setState(() {}); 
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ApiRepository.instance.getDashboard();
      if (!mounted) return;
      setState(() {
        _data = data;
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
    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primaryBlue,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildCustomHeader(context),
                Positioned(
                  bottom: -27,
                  left: 0,
                  right: 0,
                  child: SearchBarWidget(
                    hint: 'Cari informasi, materi, atau tugas...',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 46),
            if (_loading)
              const AppLoadingView(
                message: 'Memuat ruang belajar kamu...',
                compact: true,
              )
            else if (_error != null)
              AppErrorView(message: _error!, onRetry: _load)
            else ...[
              ResponsivePadding(child: _buildGridMenu(context)),
              const SizedBox(height: 26),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: SectionHeader(
                  title: 'Berita Terbaru',
                  subtitle: 'Informasi terkini dari sekolah',
                  count: _pengumuman.length,
                  actionLabel: 'Lihat semua',
                  onActionTap: () {
                    MainShellController.instance.switchToTab(2);
                  },
                ),
              ),
              const SizedBox(height: 14),
              _buildPengumumanHorizontal(),
              const SizedBox(height: 26),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: SectionHeader(
                  title: 'Materi Terbaru',
                  subtitle: 'Lanjutkan belajarmu',
                  actionLabel: 'Lihat Semua',
                  onActionTap: () {
                    Navigator.pushNamed(context, AppRoutes.materi);
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildMateriTerbaru(),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: AppColors.heroLinear,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Stack(
        children: [
          
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _HeaderPatternPainter()),
            ),
          ),
          // Glow cyan.
          Positioned(
            top: -100,
            right: -80,
            child: IgnorePointer(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentCyan.withValues(alpha: 0.24),
                      AppColors.accentCyan.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -90,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 54),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.navy.withValues(alpha: 0.22),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo_smansa.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.school_rounded,
                              color: AppColors.primaryBlue,
                              size: 24,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.schoolName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppConstants.tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 8,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildNotificationButton(context),
                      const SizedBox(width: 8),
                      _buildProfileButton(context),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.accentAmber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          _namaKelas,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w700,
                            fontSize: 9.5,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Halo, $_nama',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headerTitle.copyWith(
                      fontSize: 25,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Siap untuk belajar hal baru hari ini?',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headerSubtitle.copyWith(
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      _buildHeaderStat(
                        icon: Icons.campaign_rounded,
                        value: '${_pengumuman.length}',
                        label: 'Pengumuman',
                        color: AppColors.accentAmber,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      _buildHeaderStat(
                        icon: Icons.menu_book_rounded,
                        value: '${_materiTerbaru.length}',
                        label: 'Materi baru',
                        color: AppColors.accentCyan,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontSize: 13,
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withValues(alpha: 0.52),
                fontSize: 8.5,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    final badge = NotificationBadgeController.instance;
    final showBadge = badge.loaded && badge.hasUnread;

    return Tooltip(
      message: 'Notifikasi',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            MainShellController.instance.switchToTab(1);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              if (showBadge)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.navy, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return Tooltip(
      message: 'Profil',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.dataDiri);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primaryBlue,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    final menus = [
      {
        'icon': Icons.calendar_month_rounded,
        'label': 'Kalender\nAkademik',
        'route': AppRoutes.kalender,
        'color': AppColors.primaryBlue,
      },
      {
        'icon': Icons.qr_code_scanner_rounded,
        'label': 'Pemindai\nKartu',
        'route': AppRoutes.pemindai,
        'color': AppColors.accentPurple,
      },
      {
        'icon': Icons.history_edu_rounded,
        'label': 'Riwayat\nAkademik',
        'route': AppRoutes.riwayat,
        'color': AppColors.accentMint,
      },
      {
        'icon': Icons.assignment_rounded,
        'label': 'Tugas',
        'route': AppRoutes.tugas,
        'color': AppColors.accentAmber,
      },
      {
        'icon': Icons.quiz_rounded,
        'label': 'Ujian',
        'route': AppRoutes.ujian,
        'color': AppColors.dangerRed,
      },
      {
        'icon': Icons.rocket_launch_rounded,
        'label': 'SMANSAGo',
        'route': AppRoutes.smansago,
        'color': AppColors.accentPink,
      },
      {
        'icon': Icons.schedule_rounded,
        'label': 'Jadwal\nSiswa',
        'route': AppRoutes.jadwal,
        'color': AppColors.primaryBlue,
      },
      {
        'icon': Icons.folder_open_rounded,
        'label': 'Materi',
        'route': AppRoutes.materi,
        'color': AppColors.accentTeal,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Menu Cepat', style: AppTextStyles.sectionTitle),
            const Spacer(),
            Text(
              '${menus.length} layanan',
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final size = AppConstants.getScreenSize(
              MediaQuery.of(context).size.width,
            );
            final int cols = switch (size) {
              ScreenSize.small => 4,
              ScreenSize.medium => 4,
              ScreenSize.large => 5,
              ScreenSize.extraLarge => 6,
            };
            final double spacing = width < 340 ? 8 : 11;
            final double itemWidth = (width - spacing * (cols - 1)) / cols;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: menus.map((menu) {
                final accent = menu['color'] as Color;
                return SizedBox(
                  width: itemWidth,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        if (menu['route'] != null) {
                          Navigator.pushNamed(context, menu['route'] as String);
                        }
                      },
                      child: Container(
                        height: 104,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.borderSubtle,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                              spreadRadius: -6,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIconTile(
                              icon: menu['icon'] as IconData,
                              color: accent,
                              size: width < 340 ? 38 : 42,
                              iconSize: width < 340 ? 19 : 21,
                              radius: 13,
                              gradient: true,
                            ),
                            const SizedBox(height: 9),
                            Text(
                              menu['label'] as String,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.smallText.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: width < 340 ? 10 : 10.5,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPengumumanHorizontal() {
    if (_pengumuman.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.responsivePadding(
            MediaQuery.of(context).size.width,
          ),
        ),
        child: const AppEmptyView(
          icon: Icons.campaign_outlined,
          title: 'Belum ada pengumuman',
          subtitle: 'Informasi baru dari sekolah akan muncul di sini.',
        ),
      );
    }

    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _pengumuman.length,
        itemBuilder: (context, index) {
          final berita = _pengumuman[index] as Map<String, dynamic>;
          final kategori = (berita['kategori'] ?? 'info') as String;
          final createdAt = berita['created_at'] != null
              ? DateTime.tryParse(berita['created_at'] as String)
              : null;

          final accent = _categoryColor(kategori);

          return Container(
            width: 286,
            margin: const EdgeInsets.only(right: 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                  spreadRadius: -8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        accent.withValues(alpha: 0.14),
                        accent.withValues(alpha: 0.04),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(_categoryIcon(kategori), color: accent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        kategori.toUpperCase(),
                        style: AppTextStyles.chipText.copyWith(
                          color: accent,
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      if (createdAt != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            DateFormat('dd MMM').format(createdAt),
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 9.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          berita['judul'] as String? ?? '-',
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 14.5,
                            height: 1.35,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
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
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 13,
                              color: accent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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

  IconData _categoryIcon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'pengumuman':
      case 'penting':
        return Icons.campaign_rounded;
      case 'prestasi':
        return Icons.emoji_events_rounded;
      case 'kegiatan':
        return Icons.celebration_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  Widget _buildMateriTerbaru() {
    if (_materiTerbaru.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.responsivePadding(
            MediaQuery.of(context).size.width,
          ),
        ),
        child: const AppEmptyView(
          icon: Icons.menu_book_outlined,
          title: 'Belum ada materi',
          subtitle: 'Materi dari guru akan tampil di sini.',
        ),
      );
    }

    final items = _materiTerbaru.take(3).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.responsivePadding(
          MediaQuery.of(context).size.width,
        ),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _buildMateriRow(items[i] as Map<String, dynamic>, index: i),
              if (i != items.length - 1)
                const Divider(
                  height: 1,
                  indent: 74,
                  endIndent: 16,
                  color: AppColors.divider,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMateriRow(Map<String, dynamic> materi, {required int index}) {
    const accents = [
      AppColors.primaryBlue,
      AppColors.accentTeal,
      AppColors.accentPurple,
    ];
    final accent = accents[index % accents.length];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      child: Row(
        children: [
          AppIconTile(
            icon: Icons.description_rounded,
            color: accent,
            size: 44,
            iconSize: 21,
            radius: 13,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  materi['judul'] as String? ?? '-',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        materi['nama_mapel'] as String? ?? '-',
                        style: AppTextStyles.smallText.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textTertiary,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    for (double x = 24; x < size.width; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 28; y < size.height; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.55),
      size.width * 0.34,
      ring,
    );
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.55),
      size.width * 0.24,
      ring,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

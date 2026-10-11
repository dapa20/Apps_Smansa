import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/responsive_container.dart';
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
    // Refresh badge notifikasi & listen perubahannya
    NotificationBadgeController.instance.addListener(_onBadgeChanged);
    NotificationBadgeController.instance.refresh();
  }

  @override
  void dispose() {
    NotificationBadgeController.instance.removeListener(_onBadgeChanged);
    super.dispose();
  }

  void _onBadgeChanged() {
    if (mounted) setState(() {}); // rebuild header untuk update badge
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
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 120),
          child: CircularProgressIndicator(),
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
              const Icon(
                Icons.cloud_off,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildCustomHeader(context),
              Positioned(
                bottom: -22,
                left: 0,
                right: 0,
                child: SearchBarWidget(
                  hint: 'Cari Informasi...',
                  onTap: () {},
                ),
              ),
            ],
          ),
          // Spacer yang cukup supaya search bar tidak overlap
          // dengan menu grid di bawahnya.
          const SizedBox(height: 50),
          ResponsivePadding(
            child: _buildGridMenu(context),
          ),
          const SizedBox(height: AppConstants.sectionSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Berita Terbaru',
              actionLabel: 'Lihat semua',
              onActionTap: () {
                // Pindah ke tab Berita di MainShell (index 2)
                MainShellController.instance.switchToTab(2);
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildPengumumanHorizontal(),
          const SizedBox(height: AppConstants.sectionSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Materi Terbaru',
              actionLabel: 'Lihat Semua',
              onActionTap: () {
                Navigator.pushNamed(context, AppRoutes.materi);
              },
            ),
          ),
          _buildMateriTerbaru(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    // Pakai SafeArea untuk hindarin overlap dengan status bar / notch.
    return ClipPath(
      clipper: _WavyClipper(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + 24,
          20,
          80,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1D4ED8),
              Color(0xFF2563EB),
              Color(0xFF3B82F6),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Subtle glass overlay (soft white wash top → bottom-right)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.10),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ─── Decorative blobs (3 overlap) ──────────────────────
            // Blob 1 — besar kanan-atas (overflow keluar header)
            Positioned(
              top: -110,
              right: -90,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
            ),
            // Blob 2 — medium kiri-bawah (overflow)
            Positioned(
              bottom: -80,
              left: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
            ),
            // Blob 3 — medium kanan-tengah, overlap dengan blob 1
            Positioned(
              top: 40,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Image.asset('assets/images/logo_smansa.png'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.schoolName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppConstants.tagline,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Tombol notifikasi + badge merah
                        _buildNotificationButton(context),
                        const SizedBox(width: 8),
                        // Tombol profile avatar
                        _buildProfileButton(context),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              _namaKelas,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Halo, $_nama',
                            style: AppTextStyles.headerTitle.copyWith(
                              fontSize: 22,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Semangat belajar hari ini!',
                            style: AppTextStyles.headerSubtitle.copyWith(
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.waving_hand_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
            // Pindah ke tab Notifikasi (index 1 di MainShell)
            MainShellController.instance.switchToTab(1);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              if (showBadge)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.dangerRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dangerRed.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
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
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
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
        'color': const Color(0xFF7C3AED),
      },
      {
        'icon': Icons.history_edu_rounded,
        'label': 'Riwayat\nAkademik',
        'route': AppRoutes.riwayat,
        'color': const Color(0xFF059669),
      },
      {
        'icon': Icons.assignment_rounded,
        'label': 'Tugas',
        'route': AppRoutes.tugas,
        'color': const Color(0xFFD97706),
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
        'color': const Color(0xFFDB2777),
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
        'color': const Color(0xFF14B8A6),
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    // Hitung lebar item berdasarkan lebar layar.
    // Mobile: 4 kolom, tablet: 6-8 kolom. Spacing adaptif.
    final size = AppConstants.getScreenSize(screenWidth);
    final int cols = switch (size) {
      ScreenSize.small => 4,
      ScreenSize.medium => 4,
      ScreenSize.large => 5,
      ScreenSize.extraLarge => 6,
    };
    final double hPadding = AppConstants.responsivePadding(screenWidth);
    final double spacing = screenWidth < AppConstants.mobileMedium ? 12 : 20;
    final double totalSpacing = spacing * (cols - 1);
    final double itemWidth =
        ((screenWidth - hPadding * 2 - totalSpacing) / cols).clamp(60.0, 100.0);
    final double iconSize = size == ScreenSize.small ? 46 : 54;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.start,
      children: menus.map((menu) {
        final accent = menu['color'] as Color;
        return GestureDetector(
          onTap: () {
            if (menu['route'] != null) {
              Navigator.pushNamed(context, menu['route'] as String);
            }
          },
          child: SizedBox(
            width: itemWidth,
            child: Column(
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.18),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    menu['icon'] as IconData,
                    color: accent,
                    size: size == ScreenSize.small ? 22 : 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menu['label'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
                ],
              ),
            ),
          );
        }).toList(),
    );
  }

  Widget _buildPengumumanHorizontal() {
    if (_pengumuman.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Tidak ada pengumuman.',
          style: AppTextStyles.bodySecondary,
        ),
      );
    }

    return SizedBox(
      height: 168,
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

          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderSubtle,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusChip(
                      label: kategori.toUpperCase(),
                      type: kategori == 'pengumuman' ? 'menunggu' : 'info',
                    ),
                    if (createdAt != null)
                      Text(
                        DateFormat('dd MMM').format(createdAt),
                        style: AppTextStyles.caption,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  berita['judul'] as String,
                  style: AppTextStyles.cardTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'Baca selengkapnya',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMateriTerbaru() {
    if (_materiTerbaru.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('Belum ada materi.', style: AppTextStyles.bodySecondary),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _materiTerbaru.take(3).map((item) {
          final materi = item as Map<String, dynamic>;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderSubtle,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: AppColors.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        materi['judul'] as String,
                        style: AppTextStyles.cardTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        materi['nama_mapel'] as String,
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 10,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

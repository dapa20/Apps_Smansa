import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_chip.dart';
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
                bottom: -24,
                left: 0,
                right: 0,
                child: SearchBarWidget(hint: 'Cari Informasi...', onTap: () {}),
              ),
            ],
          ),
          const SizedBox(height: 44),
          _buildGridMenu(context),
          const SizedBox(height: AppConstants.sectionSpacing),
          SectionHeader(
            title: 'Berita Terbaru',
            actionLabel: 'Lihat Semua',
            onActionTap: () {
              // Pindah ke tab Berita di MainShell (index 2)
              MainShellController.instance.switchToTab(2);
            },
          ),
          const SizedBox(height: 16),
          _buildPengumumanHorizontal(),
          const SizedBox(height: AppConstants.sectionSpacing),
          SectionHeader(
            title: 'Materi Terbaru',
            actionLabel: 'Lihat Semua',
            onActionTap: () {
              // Buka halaman Materi sebagai halaman penuh dengan back button
              Navigator.pushNamed(context, AppRoutes.materi);
            },
          ),
          const SizedBox(height: 16),
          _buildMateriTerbaru(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return ClipPath(
      clipper: _WavyClipper(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 48, 20, 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlueDark, AppColors.primaryBlue],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset('assets/images/logo_smansa.png'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.schoolName,
                          style: AppTextStyles.bodyText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppConstants.tagline,
                          style: AppTextStyles.smallText.copyWith(
                            color: Colors.white70,
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _namaKelas,
                          style: AppTextStyles.smallText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Halo, $_nama', style: AppTextStyles.headerTitle),
                      const SizedBox(height: 4),
                      Text(
                        'Semangat belajar hari ini!',
                        style: AppTextStyles.headerSubtitle,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_people,
                    size: 60,
                    color: Colors.white54,
                  ),
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
        'icon': Icons.calendar_month,
        'label': 'Kalender\nAkademik',
        'route': AppRoutes.kalender,
      },
      {
        'icon': Icons.qr_code_scanner,
        'label': 'Pemindai\nKartu',
        'route': AppRoutes.pemindai,
      },
      {
        'icon': Icons.history_edu,
        'label': 'Riwayat\nAkademik',
        'route': AppRoutes.riwayat,
      },
      {'icon': Icons.assignment, 'label': 'Tugas', 'route': AppRoutes.tugas},
      {'icon': Icons.quiz, 'label': 'Ujian', 'route': AppRoutes.ujian},
      {
        'icon': Icons.rocket_launch,
        'label': 'SMANSAGo',
        'route': AppRoutes.smansago,
      },
      {
        'icon': Icons.schedule,
        'label': 'Jadwal\nSiswa',
        'route': AppRoutes.jadwal,
      },
      {'icon': Icons.folder_open, 'label': 'Materi', 'route': AppRoutes.materi},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = ((screenWidth - 40 - 60) / 4).clamp(50.0, 90.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.spaceBetween,
        children: menus.map((menu) {
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
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.chipBlueBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      menu['icon'] as IconData,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    menu['label'] as String,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.smallText.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
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
      height: 160,
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
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                        style: AppTextStyles.smallText,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  berita['judul'] as String,
                  style: AppTextStyles.cardTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  'Baca selengkapnya',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
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
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                left: BorderSide(color: AppColors.primaryBlue, width: 4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.chipBlueBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: AppColors.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
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

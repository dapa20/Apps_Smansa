import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../core/api/auth_service.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/responsive_container.dart';
import '../../app/routes.dart';
import '../../app/notification_badge_controller.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  Map<String, dynamic>? get _siswa => _data?['siswa'] as Map<String, dynamic>?;
  Map<String, dynamic>? get _kehadiran =>
      _data?['kehadiran'] as Map<String, dynamic>?;

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
      final data = await ApiRepository.instance.getProfil();
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

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar'),
        content: const Text('Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    await AuthService.instance.logout();
    NotificationBadgeController.instance.reset();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = AppConstants.getScreenSize(width);

    // Header biru compact (tinggi 100). Avatar setengah keluar
    // (offset 70) sehingga avatar dari top header = 70, dengan
    // tinggi avatar 76, avatar berakhir di y = 146.
    final double headerHeight = size == ScreenSize.small ? 95 : 110;
    final double avatarOffset = size == ScreenSize.small ? 65 : 78;
    final double avatarSize = size == ScreenSize.small ? 76 : 88;
    // Spacer di bawah avatar = tinggi avatar + ruang kosong supaya
    // tidak overlap dengan nama & stat cards.
    final double avatarSpacer =
        size == ScreenSize.small ? 50 : 58;

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header polos (tanpa title karena avatar akan overlap).
            // Title dipindah ke konten utama di bawah avatar.
            SizedBox(
              height: headerHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  BlueHeader(
                    title: '',
                    height: headerHeight,
                  ),
                  // Avatar diposisikan center, setengah di dalam & di luar header.
                  Positioned(
                    top: avatarOffset,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: avatarSize,
                        height: avatarSize,
                        child: _buildAvatarCircle(size: avatarSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer supaya konten berikutnya tidak tertutup avatar.
            SizedBox(height: avatarSpacer),

            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryBlue,
                ),
              )
            else if (_error != null)
              ResponsivePadding(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _load,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Nama & NISN & kelas — di bawah avatar, bukan di atas.
              // Hindari tumpang tindih dengan avatar.
              _buildNameSection(),
              const SizedBox(height: 16),
              // Stat cards (KEHADIRAN & TOTAL HADIR) — pakai responsive padding
              ResponsivePadding(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Pada layar sempit (<360), tampilkan stacked vertikal
                    if (constraints.maxWidth < 280) {
                      return Column(
                        children: [
                          StatCard(
                            label: 'KEHADIRAN',
                            value:
                                '${_kehadiran?['persen_hadir'] ?? 0}%',
                            icon: Icons.check_circle_outline_rounded,
                            accentColor: AppColors.chipGreenText,
                          ),
                          const SizedBox(height: 12),
                          StatCard(
                            label: 'TOTAL HADIR',
                            value:
                                '${_kehadiran?['hadir'] ?? 0}/${_kehadiran?['total'] ?? 0}',
                            icon: Icons.event_available_rounded,
                            accentColor: AppColors.primaryBlue,
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'KEHADIRAN',
                            value:
                                '${_kehadiran?['persen_hadir'] ?? 0}%',
                            icon: Icons.check_circle_outline_rounded,
                            accentColor: AppColors.chipGreenText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            label: 'TOTAL HADIR',
                            value:
                                '${_kehadiran?['hadir'] ?? 0}/${_kehadiran?['total'] ?? 0}',
                            icon: Icons.event_available_rounded,
                            accentColor: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Menu PENGATURAN AKUN — section title + 3 menu cards
              ResponsivePadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'PENGATURAN AKUN',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    _buildMenuCard(
                      context: context,
                      icon: Icons.person_outline_rounded,
                      title: 'Data Diri',
                      subtitle: 'Lihat dan ubah data pribadimu',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.dataDiri),
                    ),
                    _buildMenuCard(
                      context: context,
                      icon: Icons.history_rounded,
                      title: 'Riwayat Nilai',
                      subtitle: 'Lihat transkrip nilai akademik',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.riwayat),
                    ),
                    _buildMenuCard(
                      context: context,
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan Akun',
                      subtitle: 'Ubah password dan kelola akun',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.pengaturanAkun,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Tombol logout
              ResponsivePadding(
                child: _buildLogoutCard(),
              ),
            ],

            const SizedBox(height: 24),
            Text(AppConstants.appVersion, style: AppTextStyles.caption),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCircle({double size = 92}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 5),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Icon(
        Icons.person_rounded,
        size: size * 0.5,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildNameSection() {
    final nama = _siswa?['nama_lengkap'] as String? ?? 'Siswa';
    final nisn = _siswa?['nisn'] as String? ?? '-';
    final kelas = (_siswa?['nama_kelas'] as String? ?? 'Kelas');

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            nama,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 20,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.badge_outlined,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                nisn,
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.chipYellowBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            kelas.toUpperCase(),
            style: AppTextStyles.chipText.copyWith(
              color: AppColors.chipYellowText,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.smallText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _logout,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.chipRedBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.dangerRed.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: AppColors.dangerRed,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Keluar',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.dangerRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../core/api/auth_service.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/responsive_container.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
    final avatarSize = size == ScreenSize.small ? 82.0 : 92.0;

    return Container(
      color: AppColors.background,
      child: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header + avatar overlapping.
              Stack(
                clipBehavior: Clip.none,
                children: [
                  BlueHeader(
                    eyebrow: 'Akun Siswa',
                    title: 'Profil Saya',
                    subtitle: 'Kelola data dan keamanan akunmu.',
                    height: 116,
                    trailing: _buildSettingsButton(context),
                  ),
                  Positioned(
                    bottom: -40,
                    left: 0,
                    right: 0,
                    child: Center(child: _buildAvatarCircle(size: avatarSize)),
                  ),
                ],
              ),
              const SizedBox(height: 54),

              if (_loading)
                const AppLoadingView(message: 'Memuat profil...', compact: true)
              else if (_error != null)
                AppErrorView(message: _error!, onRetry: _load)
              else ...[
                _buildNameSection(),
                const SizedBox(height: 20),
                ResponsivePadding(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 280) {
                        return Column(
                          children: [
                            StatCard(
                              label: 'Kehadiran',
                              value: '${_kehadiran?['persen_hadir'] ?? 0}',
                              suffix: '%',
                              icon: Icons.check_circle_outline_rounded,
                              accentColor: AppColors.accentMint,
                            ),
                            const SizedBox(height: 12),
                            StatCard(
                              label: 'Total Hadir',
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
                              label: 'Kehadiran',
                              value: '${_kehadiran?['persen_hadir'] ?? 0}',
                              suffix: '%',
                              icon: Icons.check_circle_outline_rounded,
                              accentColor: AppColors.accentMint,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              label: 'Total Hadir',
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
                const SizedBox(height: 24),
                ResponsivePadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel(
                        'Pengaturan Akun',
                        padding: EdgeInsets.only(left: 4, bottom: 12),
                      ),
                      _buildMenuGroup(context),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ResponsivePadding(child: _buildLogoutCard()),
              ],

              const SizedBox(height: 26),
              Text(
                '${AppConstants.appName} ${AppConstants.appVersion}',
                style: AppTextStyles.caption.copyWith(fontSize: 9.5),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.pushNamed(context, AppRoutes.pengaturanAkun),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: const Icon(
            Icons.settings_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarCircle({double size = 92}) {
    final nama = _siswa?['nama_lengkap'] as String? ?? 'Siswa';
    final initials = _initials(nama);

    return Container(
      width: size + 8,
      height: size + 8,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.accentCyan],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Center(
          child: Text(
            initials,
            style: AppTextStyles.display.copyWith(
              fontSize: size * 0.30,
              color: AppColors.primaryBlue,
              letterSpacing: -1,
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String nama) {
    final parts = nama
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
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
              fontSize: 21,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.badge_outlined,
              size: 13,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'NISN $nisn',
                style: AppTextStyles.smallText.copyWith(fontSize: 11.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryBlueTint,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 12,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 5),
              Text(
                kelas.toUpperCase(),
                style: AppTextStyles.chipText.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup(BuildContext context) {
    final menus = [
      {
        'icon': Icons.person_outline_rounded,
        'title': 'Data Diri',
        'subtitle': 'Lihat dan ubah data pribadimu',
        'color': AppColors.primaryBlue,
        'onTap': () => Navigator.pushNamed(context, AppRoutes.dataDiri),
      },
      {
        'icon': Icons.history_rounded,
        'title': 'Riwayat Nilai',
        'subtitle': 'Lihat transkrip nilai akademik',
        'color': AppColors.accentMint,
        'onTap': () => Navigator.pushNamed(context, AppRoutes.riwayat),
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Pengaturan Akun',
        'subtitle': 'Ubah password dan kelola akun',
        'color': AppColors.accentPurple,
        'onTap': () => Navigator.pushNamed(context, AppRoutes.pengaturanAkun),
      },
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < menus.length; i++) ...[
            _buildMenuRow(
              icon: menus[i]['icon'] as IconData,
              title: menus[i]['title'] as String,
              subtitle: menus[i]['subtitle'] as String,
              color: menus[i]['color'] as Color,
              onTap: menus[i]['onTap'] as VoidCallback,
            ),
            if (i != menus.length - 1)
              const Divider(
                height: 1,
                indent: 70,
                endIndent: 16,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Row(
            children: [
              AppIconTile(
                icon: icon,
                color: color,
                size: 40,
                iconSize: 19,
                radius: 12,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 13.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.smallText.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                  size: 17,
                ),
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
        borderRadius: BorderRadius.circular(18),
        onTap: _logout,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.chipRedBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.dangerRed.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.dangerRed,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Keluar dari akun',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.dangerRed,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.dangerRed,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

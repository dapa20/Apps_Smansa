import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/api/api_repository.dart';
import '../../core/api/auth_service.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/responsive_container.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';

class DataDiriScreen extends StatefulWidget {
  const DataDiriScreen({super.key});

  @override
  State<DataDiriScreen> createState() => _DataDiriScreenState();
}

class _DataDiriScreenState extends State<DataDiriScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  Map<String, dynamic>? get _siswa => _data?['siswa'] as Map<String, dynamic>?;
  Map<String, dynamic>? get _kehadiran =>
      _data?['kehadiran'] as Map<String, dynamic>?;

  @override
  void initState() {
    super.initState();
    // Pakai cache siswa dulu (supaya profil tampil cepat),
    // lalu refresh dari API di background.
    _data = AuthService.instance.cachedSiswa == null
        ? null
        : {'siswa': AuthService.instance.cachedSiswa};
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

  String _jenisKelamin(String? jk) {
    switch (jk) {
      case 'L':
        return 'Laki-laki';
      case 'P':
        return 'Perempuan';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading && _siswa == null
          ? Column(
              children: [
                BlueHeader(
                  eyebrow: 'Identitas Siswa',
                  title: 'Data Diri',
                  subtitle: 'Informasi lengkap akun siswamu.',
                  height: 110,
                  showBackButton: true,
                ),
                const Expanded(
                  child: AppLoadingView(message: 'Memuat data diri...'),
                ),
              ],
            )
          : _error != null && _siswa == null
          ? Column(
              children: [
                BlueHeader(
                  eyebrow: 'Identitas Siswa',
                  title: 'Data Diri',
                  subtitle: 'Informasi lengkap akun siswamu.',
                  height: 110,
                  showBackButton: true,
                ),
                Expanded(
                  child: AppErrorView(message: _error!, onRetry: _load),
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.primaryBlue,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlueHeader(
                      eyebrow: 'Identitas Siswa',
                      title: 'Data Diri',
                      subtitle: 'Informasi lengkap akun siswamu.',
                      height: 110,
                      showBackButton: true,
                      extraContent: [
                        const SizedBox(height: 20),
                        _buildIdentityHero(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ResponsivePadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIdentityCard(),
                          const SizedBox(height: 16),
                          _buildKehadiranCard(),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildIdentityHero() {
    final siswa = _siswa ?? {};
    final nama = siswa['nama_lengkap']?.toString() ?? 'Siswa';
    final kelas = siswa['nama_kelas']?.toString() ?? '-';
    final nis = siswa['nis']?.toString() ?? '-';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFDCE9FF)],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _initials(nama),
                style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        kelas.toUpperCase(),
                        style: AppTextStyles.chipText.copyWith(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'NIS $nis',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.62),
                          fontSize: 9.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.verified_rounded,
            color: AppColors.accentCyan,
            size: 22,
          ),
        ],
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

  Widget _buildIdentityCard() {
    final siswa = _siswa ?? {};

    final rows = <Map<String, String>>[
      {'label': 'NIS', 'value': siswa['nis']?.toString() ?? '-'},
      {'label': 'NISN', 'value': siswa['nisn']?.toString() ?? '-'},
      {
        'label': 'Nama Lengkap',
        'value': siswa['nama_lengkap']?.toString() ?? '-',
      },
      {
        'label': 'Jenis Kelamin',
        'value': _jenisKelamin(siswa['jenis_kelamin'] as String?),
      },
      {'label': 'Kelas', 'value': siswa['nama_kelas']?.toString() ?? '-'},
      {'label': 'Tingkat', 'value': siswa['tingkat']?.toString() ?? '-'},
      {'label': 'Program', 'value': siswa['program']?.toString() ?? '-'},
      {
        'label': 'Tahun Ajaran',
        'value': siswa['tahun_ajaran']?.toString() ?? '-',
      },
      {'label': 'Wali Kelas', 'value': siswa['wali_kelas']?.toString() ?? '-'},
      {
        'label': 'Status',
        'value': (siswa['status']?.toString() ?? '-').toUpperCase(),
      },
    ];

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIconTile(
                icon: Icons.person_outline_rounded,
                color: AppColors.primaryBlue,
                size: 40,
                iconSize: 19,
                radius: 12,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identitas Siswa',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                    ),
                    Text(
                      'Data resmi yang tercatat di sekolah',
                      style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  _buildDataRow(rows[i]['label']!, rows[i]['value']!),
                  if (i != rows.length - 1)
                    const Divider(height: 1, color: AppColors.divider),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKehadiranCard() {
    final k = _kehadiran ?? const {};
    final total = k['total'] ?? 0;
    final hadir = k['hadir'] ?? 0;
    final izin = k['izin'] ?? 0;
    final sakit = k['sakit'] ?? 0;
    final alpa = k['alpa'] ?? 0;
    final persen = (k['persen_hadir'] ?? 0).toString();
    final progress = ((double.tryParse(persen) ?? 0) / 100).clamp(0.0, 1.0);

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIconTile(
                icon: Icons.fact_check_rounded,
                color: AppColors.accentMint,
                size: 40,
                iconSize: 19,
                radius: 12,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Kehadiran',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                    ),
                    Text(
                      'Total $total pertemuan tercatat',
                      style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              Text(
                '$persen%',
                style: AppTextStyles.bigNumber.copyWith(
                  fontSize: 20,
                  color: AppColors.accentMint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  'Hadir',
                  '$hadir',
                  AppColors.accentMint,
                  AppColors.chipGreenBg,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniStat(
                  'Izin',
                  '$izin',
                  AppColors.primaryBlue,
                  AppColors.chipBlueBg,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniStat(
                  'Sakit',
                  '$sakit',
                  AppColors.accentAmber,
                  AppColors.chipYellowBg,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniStat(
                  'Alpa',
                  '$alpa',
                  AppColors.dangerRed,
                  AppColors.chipRedBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentMint,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                'Kehadiran semester ini',
                style: AppTextStyles.caption.copyWith(fontSize: 9.5),
              ),
              const Spacer(),
              Icon(
                Icons.verified_rounded,
                size: 12,
                color: progress >= 0.75
                    ? AppColors.accentMint
                    : AppColors.accentAmber,
              ),
              const SizedBox(width: 4),
              Text(
                progress >= 0.75 ? 'Sangat baik' : 'Perlu ditingkatkan',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 9.5,
                  color: progress >= 0.75
                      ? AppColors.accentMint
                      : AppColors.accentAmber,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    Color color,
    Color background,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.10)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(color: color, fontSize: 17),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color.withValues(alpha: 0.75),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppTextStyles.smallText.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../core/api/auth_service.dart';
import '../../widgets/back_button_overlay.dart';

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
    // Pakai cache siswa dulu (supaya Hasil riwayat baru tampil cepat),
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: const BackLeadingButton(color: Colors.white),
        title: Text(
          'Data Diri',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading && _siswa == null
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _siswa == null
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppConstants.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(),
                        const SizedBox(height: 16),
                        _buildIdentityCard(),
                        const SizedBox(height: 16),
                        _buildKehadiranCard(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
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
    );
  }

  Widget _buildProfileCard() {
    final siswa = _siswa ?? {};
    final nis = siswa['nis'] ?? '-';
    final nisn = siswa['nisn'] ?? '-';
    final nama = siswa['nama_lengkap'] ?? 'Siswa';
    final kelas = siswa['nama_kelas'] ?? '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlueDark, AppColors.primaryBlue],
        ),
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(Icons.person, size: 40, color: AppColors.primaryBlue),
          ),
          const SizedBox(height: 12),
          Text(
            nama,
            style: AppTextStyles.headerTitle.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              kelas.toString().toUpperCase(),
              style: AppTextStyles.chipText.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 14,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                'NIS: $nis',
                style: AppTextStyles.smallText.copyWith(color: Colors.white70),
              ),
              const SizedBox(width: 12),
              Text(
                'NISN: $nisn',
                style: AppTextStyles.smallText.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard() {
    final siswa = _siswa ?? {};
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.chipBlueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('Identitas Siswa', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, height: 1),
          _buildDataRow('NIS', siswa['nis']?.toString() ?? '-'),
          _buildDataRow('NISN', siswa['nisn']?.toString() ?? '-'),
          _buildDataRow('Nama Lengkap', siswa['nama_lengkap']?.toString() ?? '-'),
          _buildDataRow(
            'Jenis Kelamin',
            _jenisKelamin(siswa['jenis_kelamin'] as String?),
          ),
          _buildDataRow('Kelas', siswa['nama_kelas']?.toString() ?? '-'),
          _buildDataRow('Tingkat', siswa['tingkat']?.toString() ?? '-'),
          _buildDataRow('Program', siswa['program']?.toString() ?? '-'),
          _buildDataRow('Tahun Ajaran', siswa['tahun_ajaran']?.toString() ?? '-'),
          _buildDataRow('Wali Kelas', siswa['wali_kelas']?.toString() ?? '-'),
          _buildDataRow(
            'Status',
            (siswa['status']?.toString() ?? '-').toUpperCase(),
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.chipGreenBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fact_check,
                  color: AppColors.chipGreenText,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('Ringkasan Kehadiran', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Hadir', '$hadir', AppColors.chipGreenText),
              _buildStat('Izin', '$izin', AppColors.chipBlueText),
              _buildStat('Sakit', '$sakit', AppColors.chipYellowText),
              _buildStat('Alpa', '$alpa', AppColors.chipRedText),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.chipBlueBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Persentase Kehadiran',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$persen%',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total $total pertemuan tercatat',
            style: AppTextStyles.smallText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(color: color, fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.smallText),
      ],
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
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
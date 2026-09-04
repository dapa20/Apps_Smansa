import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/section_header.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final List<String> _semesters = ['Ganjil', 'Genap'];
  int _semesterIndex = 0;

  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  String get _selectedSemester => _semesters[_semesterIndex];

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
      final data = await ApiRepository.instance.getNilai(
        semester: _selectedSemester,
      );
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

  void _changeSemester(int index) {
    if (index == _semesterIndex) return;
    setState(() {
      _semesterIndex = index;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppConstants.appName,
          style: AppTextStyles.headerTitle.copyWith(
            color: AppColors.primaryBlue,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const BlueHeader(
                  title: 'Riwayat Akademik',
                  subtitle: 'Pantau perkembangan nilai dan prestasimu',
                  height: 180,
                ),
                Positioned(
                  bottom: -30,
                  left: 20,
                  right: 20,
                  child: _buildSummaryCard(),
                ),
              ],
            ),
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Pilih Semester', style: AppTextStyles.sectionTitle),
            ),
            const SizedBox(height: 12),
            _buildSemesterSelector(),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildRingkasanSemester(),
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(title: 'Detail Nilai Mata Pelajaran'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildNilaiList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rata-rata Semester', style: AppTextStyles.bodySecondary),
              const SizedBox(height: 4),
              Text(
                (_data?['rata_rata'] ?? '0').toString(),
                style: AppTextStyles.bigNumber,
              ),
              const SizedBox(height: 4),
              Text(
                '${_data?['jumlah_mapel'] ?? 0} Mata Pelajaran',
                style: AppTextStyles.smallText,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.chipBlueBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up,
              color: AppColors.primaryBlue,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_semesters.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildSemesterPill(
              'Semester ${_semesters[index]}',
              index == _semesterIndex,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSemesterPill(String text, bool isActive) {
    return GestureDetector(
      onTap: () => _changeSemester(
        isActive ? _semesterIndex : _semesters.indexOf(text.split(' ').last),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primaryBlue : AppColors.divider,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.bodyText.copyWith(
            color: isActive ? Colors.white : AppColors.textPrimary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRingkasanSemester() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          const Icon(Icons.cloud_off, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
        ],
      );
    }

    final rataRata = ((_data?['rata_rata'] ?? 0.0) as num).toDouble();
    final target = 75.0;

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
        border: const Border(
          left: BorderSide(
            color: AppColors.accentYellow,
            width: AppConstants.leftBorderWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan Semester $_selectedSemester',
                style: AppTextStyles.cardTitle,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chipYellowBg,
                  borderRadius: BorderRadius.circular(AppConstants.chipRadius),
                ),
                child: Text(
                  'IPS',
                  style: AppTextStyles.chipText.copyWith(
                    color: AppColors.chipYellowText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_data?['tahun_ajaran'] ?? '-'}',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rataRata.toString(),
                style: AppTextStyles.bigNumber.copyWith(
                  color: AppColors.accentYellow,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('/ 100', style: AppTextStyles.bodySecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (rataRata / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (target / 100).clamp(0.0, 1.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.textPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Target: $target', style: AppTextStyles.smallText),
              Text(
                rataRata >= target ? 'Tercapai' : 'Belum',
                style: AppTextStyles.smallText.copyWith(
                  color: rataRata >= target
                      ? AppColors.chipGreenText
                      : AppColors.chipRedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNilaiList() {
    if (_loading || _error != null) {
      return const SizedBox.shrink();
    }

    final daftarNilai = (_data?['daftar_nilai'] as List?) ?? [];
    if (daftarNilai.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'Belum ada nilai untuk semester ini.',
            style: AppTextStyles.bodySecondary,
          ),
        ),
      );
    }

    return Column(
      children: daftarNilai.map((item) {
        final nilai = item as Map<String, dynamic>;
        return _buildNilaiCard(nilai);
      }).toList(),
    );
  }

  Widget _buildNilaiCard(Map<String, dynamic> nilai) {
    final namaMapel = nilai['nama_mapel'] ?? '-';
    final nilaiAkhir = (nilai['nilai_akhir'] ?? 0.0).toString();

    String hurufMutu = '-';
    final na = (nilai['nilai_akhir'] ?? 0.0) as num;
    if (na >= 90) {
      hurufMutu = 'A';
    } else if (na >= 80) {
      hurufMutu = 'B';
    } else if (na >= 70) {
      hurufMutu = 'C';
    } else if (na >= 60) {
      hurufMutu = 'D';
    } else {
      hurufMutu = 'E';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.chipBlueBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Σ',
                  style: TextStyle(fontSize: 24, color: AppColors.primaryBlue),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(namaMapel, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Text(
                      'T1: ${nilai['tugas_1'] ?? '-'} • T2: ${nilai['tugas_2'] ?? '-'} • UTS: ${nilai['uts'] ?? '-'} • UAS: ${nilai['uas'] ?? '-'}',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nilai Akhir', style: AppTextStyles.bodyText),
              Row(
                children: [
                  Text(
                    nilaiAkhir,
                    style: AppTextStyles.bigNumber.copyWith(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(hurufMutu, style: AppTextStyles.letterGrade),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

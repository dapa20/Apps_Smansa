import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/section_header.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';

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
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BlueHeader(
                eyebrow: 'Pencapaian Belajar',
                title: 'Riwayat Akademik',
                subtitle: 'Pantau perkembangan nilai dan prestasimu.',
                height: 104,
                showBackButton: true,
              ),
              const SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: _buildSummaryCard(),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: Row(
                  children: [
                    Text('Semester', style: AppTextStyles.sectionTitle),
                    const Spacer(),
                    Text(
                      'Pilih periode',
                      style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildSemesterSelector(),
              const SizedBox(height: 22),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: _buildRingkasanSemester(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: const SectionHeader(
                  title: 'Detail Nilai',
                  subtitle: 'Nilai per mata pelajaran',
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.responsivePadding(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: _buildNilaiList(),
              ),
              const SizedBox(height: 38),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final rata = (_data?['rata_rata'] ?? 0).toString();
    final jumlahMapel = _data?['jumlah_mapel'] ?? 0;

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1B45), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.22),
            blurRadius: 26,
            offset: const Offset(0, 12),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentCyan.withValues(alpha: 0.10),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RATA-RATA SEMESTER',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 8.5,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          rata,
                          style: AppTextStyles.bigNumber.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '/ 100',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$jumlahMapel mata pelajaran',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColors.accentCyan,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.responsivePadding(
          MediaQuery.of(context).size.width,
        ),
      ),
      child: Row(
        children: List.generate(_semesters.length, (index) {
          final isActive = index == _semesterIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => _changeSemester(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: index == 0 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primaryBlue.withValues(alpha: 0.28)
                        : AppColors.borderSubtle,
                    width: isActive ? 1.3 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(
                              alpha: 0.10,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                            spreadRadius: -6,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primaryBlue
                            : AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Semester ${_semesters[index]}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isActive
                            ? AppColors.primaryBlue
                            : AppColors.textSecondary,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRingkasanSemester() {
    if (_loading) {
      return const AppLoadingView(
        message: 'Memuat nilai semester...',
        compact: true,
      );
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    final rataRata = ((_data?['rata_rata'] ?? 0.0) as num).toDouble();
    final target = 75.0;

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Semester $_selectedSemester',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_data?['tahun_ajaran'] ?? '-'}',
                      style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chipYellowBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.accentAmber.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  'IPS',
                  style: AppTextStyles.chipText.copyWith(
                    color: AppColors.chipYellowText,
                    fontSize: 8.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rataRata.toString(),
                style: AppTextStyles.bigNumber.copyWith(
                  color: AppColors.accentAmber,
                  fontSize: 32,
                ),
              ),
              const SizedBox(width: 7),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ 100',
                  style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: rataRata >= target
                      ? AppColors.chipGreenBg
                      : AppColors.chipRedBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  rataRata >= target ? 'Tercapai' : 'Belum',
                  style: AppTextStyles.chipText.copyWith(
                    color: rataRata >= target
                        ? AppColors.chipGreenText
                        : AppColors.chipRedText,
                    fontSize: 8.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (rataRata / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentAmber,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Target: ${target.toStringAsFixed(0)}',
                style: AppTextStyles.caption.copyWith(fontSize: 9.5),
              ),
              const Spacer(),
              Text(
                '${((rataRata / target) * 100).clamp(0, 999).toStringAsFixed(0)}% dari target',
                style: AppTextStyles.caption.copyWith(fontSize: 9.5),
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
      return const AppEmptyView(
        icon: Icons.grading_rounded,
        title: 'Belum ada nilai',
        subtitle: 'Belum ada nilai untuk semester ini.',
      );
    }

    return Column(
      children: [
        for (int i = 0; i < daftarNilai.length; i++) ...[
          _buildNilaiCard(daftarNilai[i] as Map<String, dynamic>),
          if (i != daftarNilai.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildNilaiCard(Map<String, dynamic> nilai) {
    final namaMapel = nilai['nama_mapel'] ?? '-';
    final nilaiAkhir = (nilai['nilai_akhir'] ?? 0.0).toString();

    final na = (nilai['nilai_akhir'] ?? 0.0) as num;
    String hurufMutu;
    Color gradeColor;
    if (na >= 90) {
      hurufMutu = 'A';
      gradeColor = AppColors.accentMint;
    } else if (na >= 80) {
      hurufMutu = 'B';
      gradeColor = AppColors.primaryBlue;
    } else if (na >= 70) {
      hurufMutu = 'C';
      gradeColor = AppColors.accentAmber;
    } else if (na >= 60) {
      hurufMutu = 'D';
      gradeColor = AppColors.accentPurple;
    } else {
      hurufMutu = 'E';
      gradeColor = AppColors.dangerRed;
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              AppIconTile(
                icon: Icons.menu_book_rounded,
                color: gradeColor,
                size: 42,
                iconSize: 20,
                radius: 12,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  namaMapel,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    nilaiAkhir,
                    style: AppTextStyles.bigNumber.copyWith(
                      fontSize: 22,
                      color: gradeColor,
                    ),
                  ),
                  Text(
                    'Nilai akhir',
                    style: AppTextStyles.caption.copyWith(fontSize: 8),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: gradeColor.withValues(alpha: 0.16)),
                ),
                child: Text(
                  hurufMutu,
                  style: AppTextStyles.letterGrade.copyWith(
                    fontSize: 14,
                    color: gradeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                _buildScoreItem('T1', '${nilai['tugas_1'] ?? '-'}'),
                _buildScoreDivider(),
                _buildScoreItem('T2', '${nilai['tugas_2'] ?? '-'}'),
                _buildScoreDivider(),
                _buildScoreItem('UTS', '${nilai['uts'] ?? '-'}'),
                _buildScoreDivider(),
                _buildScoreItem('UAS', '${nilai['uas'] ?? '-'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 8.5,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildScoreDivider() {
    return Container(width: 1, height: 22, color: AppColors.borderSubtle);
  }
}

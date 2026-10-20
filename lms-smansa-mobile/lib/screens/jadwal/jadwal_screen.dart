import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/surface_card.dart';
import '../../widgets/state_views.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  final List<String> _hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];
  String _selectedHari = _defaultHari();

  List<Map<String, dynamic>> _jadwal = [];
  bool _loading = true;
  String? _error;

  static String _defaultHari() {
    const daftar = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final now = DateTime.now();
    // DateTime.monday = 1 ... sunday = 7
    final idx = now.weekday - 1;
    if (idx >= 0 && idx < daftar.length) return daftar[idx];
    return 'Senin';
  }

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
      final data = await ApiRepository.instance.getJadwal();
      if (!mounted) return;
      setState(() {
        _jadwal = data;
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

  List<Map<String, dynamic>> get _jadwalSelected {
    return _jadwal.where((j) => (j['hari'] ?? '') == _selectedHari).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              BlueHeader(
                eyebrow: 'Agenda Belajar',
                title: 'Jadwal Pelajaran',
                subtitle: AppConstants.currentSemester,
                height: 110,
                showBackButton: true,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.today_rounded,
                        color: AppColors.accentAmber,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _selectedHari,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(bottom: -28, left: 16, right: 16, child: _buildTabs()),
            ],
          ),
          const SizedBox(height: 46),
          Expanded(child: _buildTimeline()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 8),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _hari.length,
        itemBuilder: (context, index) {
          final hari = _hari[index];
          final isSelected = hari == _selectedHari;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedHari = hari;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.primaryGradient,
                      )
                    : null,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.28),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: -4,
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                hari,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline() {
    if (_loading) {
      return const AppLoadingView(message: 'Memuat jadwal pelajaran...');
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    final jadwalList = _jadwalSelected;

    if (jadwalList.isEmpty) {
      return AppEmptyView(
        icon: Icons.event_busy_rounded,
        title: 'Tidak ada jadwal',
        subtitle: 'Belum ada pelajaran untuk hari $_selectedHari.',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primaryBlue,
      backgroundColor: Colors.white,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 26),
        itemCount: jadwalList.length,
        itemBuilder: (context, index) {
          final jadwal = jadwalList[index];
          final isLast = index == jadwalList.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 54,
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueTint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          jadwal['jam_mulai'] ?? '--:--',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 9.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            color: isLast
                                ? Colors.transparent
                                : AppColors.borderStrong,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildScheduleCard(jadwal),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> jadwal) {
    final namaGuru = (jadwal['nama_guru'] ?? '').toString();
    final ruang = (jadwal['ruang'] ?? '').toString();
    final isIstirahat = (jadwal['nama_mapel'] ?? '')
        .toString()
        .toLowerCase()
        .contains('istirahat');

    return SurfaceCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconTile(
                icon: isIstirahat
                    ? Icons.free_breakfast_rounded
                    : Icons.menu_book_rounded,
                color: isIstirahat
                    ? AppColors.accentAmber
                    : AppColors.primaryBlue,
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
                      jadwal['nama_mapel'] ?? '-',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${jadwal['jam_mulai'] ?? ''} – ${jadwal['jam_selesai'] ?? ''}',
                          style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isIstirahat) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildMeta(
                    Icons.person_outline_rounded,
                    namaGuru.isNotEmpty ? namaGuru : '-',
                  ),
                ),
                if (ruang.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Flexible(child: _buildMeta(Icons.room_outlined, ruang)),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textTertiary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

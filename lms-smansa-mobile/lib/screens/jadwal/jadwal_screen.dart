import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(AppConstants.appName, style: AppTextStyles.cardTitle),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          BlueHeader(
            title: 'Jadwal Pelajaran',
            subtitle: AppConstants.currentSemester,
            height: 140,
          ),
          _buildTabs(),
          Expanded(child: _buildTimeline()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            child: Container(
              margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.chipBlueBg : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      )
                    : Border.all(color: Colors.transparent),
              ),
              child: Center(
                child: Text(
                  hari,
                  style: AppTextStyles.bodyText.copyWith(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    decoration: isSelected
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: AppColors.primaryBlue,
                  ),
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
      return const Center(child: CircularProgressIndicator());
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

    final jadwalList = _jadwalSelected;

    if (jadwalList.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada jadwal $_selectedHari',
          style: AppTextStyles.bodySecondary,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: jadwalList.length,
      itemBuilder: (context, index) {
        final jadwal = jadwalList[index];
        final isLast = index == jadwalList.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 60,
                child: Column(
                  children: [
                    Text(
                      jadwal['jam_mulai'] ?? '--:--',
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isLast
                            ? Colors.transparent
                            : AppColors.primaryBlue.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildScheduleCard(jadwal),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> jadwal) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  jadwal['nama_mapel'] ?? '-',
                  style: AppTextStyles.cardTitle,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    jadwal['jam_mulai'] ?? '',
                    style: AppTextStyles.smallText.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    jadwal['jam_selesai'] ?? '',
                    style: AppTextStyles.smallText.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  (jadwal['nama_guru'] ?? '').toString().isNotEmpty
                      ? jadwal['nama_guru'] as String
                      : '-',
                  style: AppTextStyles.bodySecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.room_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  jadwal['ruang'] ?? '',
                  style: AppTextStyles.bodySecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

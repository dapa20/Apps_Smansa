import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';
import 'package:intl/intl.dart';

class TugasScreen extends StatefulWidget {
  const TugasScreen({super.key});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  bool isSelesaiTab = false;
  List<Map<String, dynamic>> _tugas = [];
  bool _loading = true;
  String? _error;

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
      final data = await ApiRepository.instance.getTugas();
      if (!mounted) return;
      setState(() {
        _tugas = data;
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

  List<Map<String, dynamic>> get _activeTugas {
    if (isSelesaiTab) {
      return _tugas
          .where(
            (t) =>
                (t['display_status'] ?? '') == 'terkumpul' ||
                (t['display_status'] ?? '') == 'dinilai',
          )
          .toList();
    }
    return _tugas
        .where(
          (t) =>
              (t['display_status'] ?? '') == 'menunggu' ||
              (t['display_status'] ?? '') == 'terlambat' ||
              (t['display_status'] ?? '') == 'belum',
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlueHeader(
                  leading: Row(
                    children: [
                      const Icon(Icons.school, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'SMANSA',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                  title: 'Tugas Saya',
                  subtitle:
                      'Kelola dan pantau tugas akademik Anda dengan mudah',
                  height: 200,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPadding,
                  ),
                  child: _buildBody(),
                ),
                const SizedBox(height: 30),
              ],
            ),
            Positioned(
              top: 155,
              left: AppConstants.screenPadding,
              right: AppConstants.screenPadding,
              child: _buildPillTabs(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
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
      );
    }

    final activeTugasList = _activeTugas;
    if (activeTugasList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            isSelesaiTab ? 'Belum ada tugas selesai' : 'Tidak ada tugas aktif',
            style: AppTextStyles.bodySecondary,
          ),
        ),
      );
    }

    return Column(
      children: activeTugasList.map((t) => _buildTugasCard(t)).toList(),
    );
  }

  Widget _buildPillTabs() {
    final belumCount = _tugas
        .where(
          (t) =>
              (t['display_status'] ?? '') == 'menunggu' ||
              (t['display_status'] ?? '') == 'terlambat' ||
              (t['display_status'] ?? '') == 'belum',
        )
        .length;
    final selesaiCount = _tugas.length - belumCount;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isSelesaiTab = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isSelesaiTab
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Belum Selesai ($belumCount)',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: !isSelesaiTab
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isSelesaiTab = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelesaiTab
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Selesai ($selesaiCount)',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelesaiTab
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTugasCard(Map<String, dynamic> tugas) {
    final status = (tugas['display_status'] ?? 'menunggu') as String;
    final bool isOverdue = status == 'terlambat';
    final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
    final deadlineStr = tugas['tanggal_deadline'] as String?;
    final deadline = deadlineStr != null
        ? DateTime.tryParse(deadlineStr)
        : null;

    String statusType = 'menunggu';
    if (status == 'terlambat' || status == 'belum') {
      statusType = 'terlambat';
    } else if (status == 'terkumpul' || status == 'dinilai') {
      statusType = 'selesai';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.itemSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppColors.leftBorderBlue,
                width: AppConstants.leftBorderWidth,
              ),
            ),
          ),
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusChip(label: status.toUpperCase(), type: statusType),
                  const Icon(Icons.more_horiz, color: AppColors.textSecondary),
                ],
              ),
              const SizedBox(height: 12),
              Text(tugas['judul'] ?? '-', style: AppTextStyles.cardTitle),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.menu_book,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      tugas['nama_mapel'] ?? '',
                      style: AppTextStyles.smallText,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: AppColors.divider, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: isOverdue
                            ? AppColors.dangerRed
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        deadline != null ? formatter.format(deadline) : '-',
                        style: AppTextStyles.smallText.copyWith(
                          color: isOverdue
                              ? AppColors.dangerRed
                              : AppColors.textSecondary,
                          fontWeight: isOverdue
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  if (status != 'terkumpul' && status != 'dinilai')
                    Text(
                      status == 'terlambat' ? 'Kirim Susulan' : 'Kerjakan',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/back_button_overlay.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackLeadingButton(),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          AppConstants.appName,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primaryBlue,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                BlueHeader(
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
          ),
          Positioned(
            top: 175,
            left: AppConstants.screenPadding,
            right: AppConstants.screenPadding,
            child: _buildPillTabs(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryBlue,
          ),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 32,
                color: AppColors.textSecondary,
              ),
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
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelesaiTab
                      ? Icons.task_alt_rounded
                      : Icons.assignment_outlined,
                  size: 36,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isSelesaiTab
                    ? 'Belum ada tugas selesai'
                    : 'Tidak ada tugas aktif',
                style: AppTextStyles.bodySecondary,
              ),
            ],
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
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isSelesaiTab = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isSelesaiTab
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelesaiTab
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusChip(label: status.toUpperCase(), type: statusType),
                const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(tugas['judul'] ?? '-', style: AppTextStyles.cardTitle),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
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
                      Icons.calendar_today_rounded,
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
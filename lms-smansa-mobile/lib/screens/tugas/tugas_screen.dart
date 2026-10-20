import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/api/api_repository.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/state_views.dart';

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

  int get _belumCount => _tugas
      .where(
        (t) =>
            (t['display_status'] ?? '') == 'menunggu' ||
            (t['display_status'] ?? '') == 'terlambat' ||
            (t['display_status'] ?? '') == 'belum',
      )
      .length;

  int get _selesaiCount => _tugas.length - _belumCount;

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
                eyebrow: 'Manajemen Tugas',
                title: 'Tugas Saya',
                subtitle: 'Kelola dan pantau tugas akademikmu dengan mudah.',
                height: 112,
                showBackButton: true,
                extraContent: [
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _buildHeaderPill(
                        Icons.pending_actions_rounded,
                        '$_belumCount belum selesai',
                        AppColors.accentAmber,
                      ),
                      const SizedBox(width: 8),
                      _buildHeaderPill(
                        Icons.task_alt_rounded,
                        '$_selesaiCount selesai',
                        AppColors.accentMint,
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: -28,
                left: 16,
                right: 16,
                child: _buildPillTabs(),
              ),
            ],
          ),
          const SizedBox(height: 46),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeaderPill(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const AppLoadingView(message: 'Memuat daftar tugas...');
    }

    if (_error != null) {
      return AppErrorView(message: _error!, onRetry: _load);
    }

    final activeTugasList = _activeTugas;
    if (activeTugasList.isEmpty) {
      return AppEmptyView(
        icon: isSelesaiTab ? Icons.task_alt_rounded : Icons.assignment_outlined,
        title: isSelesaiTab
            ? 'Belum ada tugas selesai'
            : 'Tidak ada tugas aktif',
        subtitle: isSelesaiTab
            ? 'Tugas yang sudah kamu kumpulkan akan tampil di sini.'
            : 'Semua tugas sudah kamu selesaikan. Kerja bagus!',
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primaryBlue,
      backgroundColor: Colors.white,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 26),
        itemCount: activeTugasList.length,
        itemBuilder: (context, index) {
          return _buildTugasCard(activeTugasList[index]);
        },
      ),
    );
  }

  Widget _buildPillTabs() {
    return Container(
      height: 58,
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isSelesaiTab = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: !isSelesaiTab
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.primaryGradient,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pending_actions_rounded,
                      size: 15,
                      color: !isSelesaiTab
                          ? Colors.white
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Belum ($_belumCount)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: !isSelesaiTab
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isSelesaiTab = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: isSelesaiTab
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.primaryGradient,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt_rounded,
                      size: 15,
                      color: isSelesaiTab
                          ? Colors.white
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Selesai ($_selesaiCount)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: isSelesaiTab
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
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
    final bool isDone = status == 'terkumpul' || status == 'dinilai';
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

    final accent = isDone
        ? AppColors.accentMint
        : isOverdue
        ? AppColors.dangerRed
        : AppColors.primaryBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -8,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusChip(
                          label: status.toUpperCase(),
                          type: statusType,
                        ),
                        const Spacer(),
                        Icon(
                          isDone
                              ? Icons.check_circle_rounded
                              : Icons.more_horiz_rounded,
                          color: isDone
                              ? AppColors.accentMint
                              : AppColors.textTertiary,
                          size: 19,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tugas['judul'] ?? '-',
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.menu_book_rounded,
                                size: 11,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                tugas['nama_mapel'] ?? '-',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 9.5,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        Icon(
                          isOverdue
                              ? Icons.warning_amber_rounded
                              : Icons.schedule_rounded,
                          size: 14,
                          color: isOverdue
                              ? AppColors.dangerRed
                              : AppColors.textTertiary,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            deadline != null ? formatter.format(deadline) : '-',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 9.5,
                              color: isOverdue
                                  ? AppColors.dangerRed
                                  : AppColors.textSecondary,
                              fontWeight: isOverdue
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isDone)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              status == 'terlambat'
                                  ? 'Kirim Susulan'
                                  : 'Kerjakan',
                              style: AppTextStyles.caption.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w700,
                                fontSize: 9.5,
                              ),
                            ),
                          )
                        else
                          Row(
                            children: [
                              const Icon(
                                Icons.verified_rounded,
                                size: 12,
                                color: AppColors.accentMint,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Selesai',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.accentMint,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

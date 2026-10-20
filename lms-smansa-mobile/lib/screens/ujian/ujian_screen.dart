import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock_data.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/surface_card.dart';

class UjianScreen extends StatelessWidget {
  const UjianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlueHeader(
              eyebrow: 'Evaluasi Belajar',
              title: 'Ujian & Kuis',
              subtitle: 'Kerjakan ujian dengan jujur dan tepat waktu.',
              height: 104,
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
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accentCyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${MockUjian.berlangsung.length} berlangsung',
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
            const SizedBox(height: 18),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.responsivePadding(
                  MediaQuery.of(context).size.width,
                ),
              ),
              child: _buildInstruksiCard(),
            ),
            const SizedBox(height: 24),
            _buildUjianBerlangsung(context),
            const SizedBox(height: 24),
            _buildUjianMendatang(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruksiCard() {
    final instructions = [
      'Pastikan koneksi internet stabil sebelum memulai.',
      'Waktu akan terus berjalan meski aplikasi diminimize.',
      'Kerjakan dengan jujur. Sistem mendeteksi kecurangan.',
      'Jangan lupa menekan tombol "Selesai" di akhir ujian.',
    ];

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIconTile(
                icon: Icons.gavel_rounded,
                color: AppColors.accentAmber,
                size: 36,
                iconSize: 18,
                radius: 11,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instruksi Penting',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 13.5),
                    ),
                    Text(
                      'Baca sebelum memulai ujian',
                      style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < instructions.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accentAmber.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accentAmber,
                      fontWeight: FontWeight.w800,
                      fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    instructions[i],
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 11,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            if (i != instructions.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildUjianBerlangsung(BuildContext context) {
    final ujian = MockUjian.berlangsung.first;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.responsivePadding(
          MediaQuery.of(context).size.width,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Sedang Berlangsung', style: AppTextStyles.sectionTitle),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.chipRedBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'WAJIB',
                  style: AppTextStyles.chipText.copyWith(
                    color: AppColors.dangerRed,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0B1B45), Color(0xFF173B8F)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.24),
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
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentCyan.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: -30,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const StatusChip(
                            label: 'BERLANGSUNG',
                            type: 'berlangsung',
                            icon: Icons.timer_rounded,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentAmber,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.hourglass_bottom_rounded,
                                  size: 12,
                                  color: AppColors.navy,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${ujian.sisaMenit} menit',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ujian.judul,
                        style: AppTextStyles.headerTitle.copyWith(
                          fontSize: 19,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 14,
                        runSpacing: 6,
                        children: [
                          _buildDarkMeta(
                            Icons.class_outlined,
                            '${ujian.namaKelas} • ${ujian.namaGuru}',
                          ),
                          _buildDarkMeta(
                            Icons.format_list_bulleted_rounded,
                            '${ujian.jumlahSoal} soal • ${ujian.tipeSoal}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.navy,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Mulai Ujian',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(width: 7),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 17,
                                color: AppColors.navy,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.62)),
        const SizedBox(width: 5),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.68),
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUjianMendatang(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.responsivePadding(
          MediaQuery.of(context).size.width,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Ujian Mendatang', style: AppTextStyles.sectionTitle),
              const Spacer(),
              Text(
                '${MockUjian.mendatang.length} jadwal',
                style: AppTextStyles.caption.copyWith(fontSize: 9.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < MockUjian.mendatang.length; i++) ...[
            _buildUpcomingCard(MockUjian.mendatang[i]),
            if (i != MockUjian.mendatang.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(dynamic ujian) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueTint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.event_rounded,
                        size: 12,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatter.format(ujian.jadwal),
                        style: AppTextStyles.chipText.copyWith(
                          color: AppColors.primaryBlue,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  ujian.jenis.toString().toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 8.5,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 13, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ujian.judul,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ujian.namaMapel,
                      style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.format_list_bulleted_rounded,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${ujian.jumlahSoal} soal',
                      style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderSubtle),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.lock_clock_rounded,
                      size: 15,
                      color: AppColors.textTertiary,
                    ),
                    label: Text(
                      'Belum Dibuka',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock_data.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/back_button_overlay.dart';

class UjianScreen extends StatelessWidget {
  const UjianScreen({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlueHeader(
                  title: 'Ujian & Kuis Aktif',
                  subtitle: 'Kerjakan ujian dengan jujur dan tepat waktu',
                  height: 220,
                ),
                const SizedBox(height: 70), // space for overlapping card
                _buildUjianBerlangsung(),
                const SizedBox(height: AppConstants.sectionSpacing),
                _buildUjianMendatang(),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            top: 195,
            left: AppConstants.screenPadding,
            right: AppConstants.screenPadding,
            child: _buildInstruksiCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruksiCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text('Instruksi Penting', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstruksiItem(
            '1',
            'Pastikan koneksi internet stabil sebelum memulai.',
          ),
          const SizedBox(height: 4),
          _buildInstruksiItem(
            '2',
            'Waktu akan terus berjalan meski aplikasi diminimize.',
          ),
          const SizedBox(height: 4),
          _buildInstruksiItem(
            '3',
            'Kerjakan dengan jujur. Sistem mendeteksi kecurangan.',
          ),
          const SizedBox(height: 4),
          _buildInstruksiItem(
            '4',
            'Jangan lupa menekan tombol "Selesai" di akhir ujian.',
          ),
        ],
      ),
    );
  }

  Widget _buildInstruksiItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. ',
          style: AppTextStyles.bodySecondary.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(text, style: AppTextStyles.bodySecondary),
        ),
      ],
    );
  }

  Widget _buildUjianBerlangsung() {
    final ujian = MockUjian.berlangsung.first;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ujian Berlangsung (Wajib Segera)',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppConstants.itemSpacing),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderSubtle,
                width: 1,
              ),
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
                      const StatusChip(
                        label: 'SEDANG BERLANGSUNG',
                        type: 'berlangsung',
                        icon: Icons.timer_rounded,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.chipRedBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Sisa: ${ujian.sisaMenit} Menit',
                          style: GoogleFonts.inter(
                            color: AppColors.dangerRed,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(ujian.judul, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.class_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${ujian.namaKelas} • ${ujian.namaGuru}',
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.format_list_bulleted_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${ujian.jumlahSoal} Soal • ${ujian.tipeSoal}',
                        style: AppTextStyles.smallText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Mulai Ujian',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUjianMendatang() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ujian Mendatang', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppConstants.itemSpacing),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: MockUjian.mendatang.length,
            itemBuilder: (context, index) {
              final ujian = MockUjian.mendatang[index];
              final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
              return Container(
                margin: const EdgeInsets.only(
                  bottom: AppConstants.itemSpacing,
                ),
                padding: const EdgeInsets.all(AppConstants.cardPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.borderSubtle,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.event_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatter.format(ujian.jadwal),
                            style: AppTextStyles.chipText.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(ujian.judul, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(ujian.namaMapel, style: AppTextStyles.smallText),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.format_list_bulleted_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${ujian.jumlahSoal} Soal',
                          style: AppTextStyles.smallText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: AppColors.borderSubtle,
                          ),
                        ),
                        child: Text(
                          'Belum Dibuka',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
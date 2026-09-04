import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock_data.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/status_chip.dart';
import 'package:intl/intl.dart';

class UjianScreen extends StatelessWidget {
  const UjianScreen({super.key});

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
                      const Icon(Icons.assignment, color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'PORTAL EVALUASI',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
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
            Positioned(
              top: 155,
              left: AppConstants.screenPadding,
              right: AppConstants.screenPadding,
              child: _buildInstruksiCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruksiCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text('Instruksi Penting', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstruksiItem('1', 'Pastikan koneksi internet stabil sebelum memulai.'),
          const SizedBox(height: 4),
          _buildInstruksiItem('2', 'Waktu akan terus berjalan meski aplikasi diminimize.'),
          const SizedBox(height: 4),
          _buildInstruksiItem('3', 'Kerjakan dengan jujur. Sistem mendeteksi kecurangan.'),
          const SizedBox(height: 4),
          _buildInstruksiItem('4', 'Jangan lupa menekan tombol "Selesai" di akhir ujian.'),
        ],
      ),
    );
  }

  Widget _buildInstruksiItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$number. ', style: AppTextStyles.bodySecondary),
        Expanded(
          child: Text(text, style: AppTextStyles.bodySecondary),
        ),
      ],
    );
  }

  Widget _buildUjianBerlangsung() {
    final ujian = MockUjian.berlangsung.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ujian Berlangsung (Wajib Segera)', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppConstants.itemSpacing),
          Container(
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
                    left: BorderSide(color: AppColors.leftBorderBlue, width: AppConstants.leftBorderWidth),
                  ),
                ),
                padding: const EdgeInsets.all(AppConstants.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const StatusChip(label: 'SEDANG BERLANGSUNG', type: 'berlangsung', icon: Icons.timer),
                        Text(
                          'Sisa: ${ujian.sisaMenit} Menit',
                          style: GoogleFonts.inter(color: AppColors.dangerRed, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(ujian.judul, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.class_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${ujian.namaKelas} • ${ujian.namaGuru}', style: AppTextStyles.smallText),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.format_list_bulleted, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${ujian.jumlahSoal} Soal • ${ujian.tipeSoal}', style: AppTextStyles.smallText),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Mulai Ujian',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
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

  Widget _buildUjianMendatang() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
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
                margin: const EdgeInsets.only(bottom: AppConstants.itemSpacing),
                padding: const EdgeInsets.all(AppConstants.cardPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            formatter.format(ujian.jadwal),
                            style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(ujian.judul, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.menu_book, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(ujian.namaMapel, style: AppTextStyles.smallText),
                        const SizedBox(width: 12),
                        const Icon(Icons.format_list_bulleted, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${ujian.jumlahSoal} Soal', style: AppTextStyles.smallText),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                          ),
                          side: const BorderSide(color: AppColors.divider),
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

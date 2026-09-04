import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock_data.dart';

class DataDiriScreen extends StatelessWidget {
  const DataDiriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final siswa = MockSiswa.siswaLogin;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: Text('Data Diri', style: AppTextStyles.headerTitle.copyWith(fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow('NIS', siswa.nis),
              const Divider(color: AppColors.divider, height: 32),
              _buildDataRow('NISN', siswa.nisn),
              const Divider(color: AppColors.divider, height: 32),
              _buildDataRow('Nama Lengkap', siswa.namaLengkap),
              const Divider(color: AppColors.divider, height: 32),
              _buildDataRow('Kelas', siswa.kelas),
              const Divider(color: AppColors.divider, height: 32),
              _buildDataRow('Jenis Kelamin', 'Laki-laki'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.smallText),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

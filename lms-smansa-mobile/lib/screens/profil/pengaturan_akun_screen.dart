import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../core/api/auth_service.dart';
import '../../widgets/back_button_overlay.dart';
import '../../app/routes.dart';

class PengaturanAkunScreen extends StatefulWidget {
  const PengaturanAkunScreen({super.key});

  @override
  State<PengaturanAkunScreen> createState() => _PengaturanAkunScreenState();
}

class _PengaturanAkunScreenState extends State<PengaturanAkunScreen> {
  final _passwordLamaC = TextEditingController();
  final _passwordBaruC = TextEditingController();
  final _passwordKonfirmasiC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureLama = true;
  bool _obscureBaru = true;
  bool _obscureKonfirmasi = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _passwordLamaC.dispose();
    _passwordBaruC.dispose();
    _passwordKonfirmasiC.dispose();
    super.dispose();
  }

  Future<void> _handleSimpanPassword() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    try {
      final res = await ApiRepository.instance.updatePassword(
        passwordLama: _passwordLamaC.text,
        passwordBaru: _passwordBaruC.text,
        passwordKonfirmasi: _passwordKonfirmasiC.text,
      );
      if (!mounted) return;

      final success = res['success'] == true;
      final message = res['message']?.toString() ??
          (success ? 'Password berhasil diubah.' : 'Gagal mengubah password.');

      if (success) {
        // Tampilkan dialog sukses & kosongkan field
        _passwordLamaC.clear();
        _passwordBaruC.clear();
        _passwordKonfirmasiC.clear();
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.chipGreenText),
                SizedBox(width: 8),
                Text('Berhasil'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        await _showErrorDialog(message);
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Gagal mengubah password: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.dangerRed),
            SizedBox(width: 8),
            Text('Gagal'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: const BackLeadingButton(color: Colors.white),
        title: Text(
          'Pengaturan Akun',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('KEAMANAN'),
              const SizedBox(height: 12),
              _buildPasswordCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('LAINNYA'),
              const SizedBox(height: 12),
              _buildAboutCard(),
              const SizedBox(height: 16),
              _buildLogoutCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String label) {
    return Text(
      label,
      style: AppTextStyles.chipText.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.chipBlueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ubah Password', style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(
                      'Pastikan password baru minimal 6 karakter & kombinasi huruf-angka.',
                      style: AppTextStyles.smallText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Password Saat Ini',
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordLamaC,
            obscureText: _obscureLama,
            decoration: _buildInputDecoration(
              hint: 'Masukkan password lama',
              icon: Icons.lock_outline,
              obscure: _obscureLama,
              onToggle: () => setState(() => _obscureLama = !_obscureLama),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Password lama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          Text(
            'Password Baru',
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordBaruC,
            obscureText: _obscureBaru,
            decoration: _buildInputDecoration(
              hint: 'Minimal 6 karakter, huruf & angka',
              icon: Icons.lock_reset,
              obscure: _obscureBaru,
              onToggle: () => setState(() => _obscureBaru = !_obscureBaru),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Password baru wajib diisi';
              }
              if (v.length < 6) {
                return 'Password baru minimal 6 karakter';
              }
              if (!RegExp(r'[A-Za-z]').hasMatch(v) ||
                  !RegExp(r'[0-9]').hasMatch(v)) {
                return 'Password harus kombinasi huruf dan angka';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Konfirmasi Password Baru',
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordKonfirmasiC,
            obscureText: _obscureKonfirmasi,
            decoration: _buildInputDecoration(
              hint: 'Ketik ulang password baru',
              icon: Icons.lock_reset,
              obscure: _obscureKonfirmasi,
              onToggle: () => setState(
                  () => _obscureKonfirmasi = !_obscureKonfirmasi),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Konfirmasi password wajib diisi';
              }
              if (v != _passwordBaruC.text) {
                return 'Konfirmasi tidak cocok dengan password baru';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _handleSimpanPassword,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.save, size: 18),
              label: const Text('Simpan Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.school_outlined,
            title: AppConstants.schoolName,
            subtitle: AppConstants.tagline,
          ),
          const Divider(color: AppColors.divider, height: 24),
          _buildInfoRow('Versi Aplikasi', AppConstants.appVersion),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Semester Aktif',
            AppConstants.currentSemester,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.chipBlueBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyText),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.smallText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySecondary),
        Text(
          value,
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildLogoutCard() {
    return GestureDetector(
      onTap: _handleLogout,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.chipRedBg,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.dangerRed),
            SizedBox(width: 8),
            Text(
              'Keluar dari Akun',
              style: TextStyle(
                color: AppColors.dangerRed,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: onToggle,
      ),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dangerRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.6),
      ),
    );
  }
}
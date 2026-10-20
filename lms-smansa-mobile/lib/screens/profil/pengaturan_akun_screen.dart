import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_repository.dart';
import '../../core/api/auth_service.dart';
import '../../widgets/blue_header.dart';
import '../../widgets/responsive_container.dart';
import '../../widgets/surface_card.dart';
import '../../app/routes.dart';
import '../../app/notification_badge_controller.dart';

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
      final message =
          res['message']?.toString() ??
          (success ? 'Password berhasil diubah.' : 'Gagal mengubah password.');

      if (success) {
        _passwordLamaC.clear();
        _passwordBaruC.clear();
        _passwordKonfirmasiC.clear();
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.chipGreenText,
                ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.dangerRed),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
    NotificationBadgeController.instance.reset();
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BlueHeader(
                eyebrow: 'Keamanan Akun',
                title: 'Pengaturan Akun',
                subtitle: 'Perbarui password dan kelola informasi akunmu.',
                height: 96,
                showBackButton: true,
              ),
              const SizedBox(height: 20),
              ResponsivePadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel(
                      'Keamanan',
                      padding: EdgeInsets.only(left: 4, bottom: 12),
                    ),
                    _buildPasswordCard(),
                    const SizedBox(height: 24),
                    const SectionLabel(
                      'Lainnya',
                      padding: EdgeInsets.only(left: 4, bottom: 12),
                    ),
                    _buildAboutCard(),
                    const SizedBox(height: 16),
                    _buildLogoutCard(),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCard() {
    final baru = _passwordBaruC.text;
    final hasLength = baru.length >= 6;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(baru);
    final hasNumber = RegExp(r'[0-9]').hasMatch(baru);
    final strength = [
      hasLength,
      hasLetter,
      hasNumber,
    ].where((element) => element).length;

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIconTile(
                icon: Icons.shield_outlined,
                color: AppColors.primaryBlue,
                size: 42,
                iconSize: 20,
                radius: 13,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubah Password',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14.5),
                    ),
                    Text(
                      'Gunakan kombinasi huruf dan angka yang kuat.',
                      style: AppTextStyles.smallText.copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLabel('Password Saat Ini'),
          const SizedBox(height: 7),
          TextFormField(
            controller: _passwordLamaC,
            obscureText: _obscureLama,
            style: AppTextStyles.bodyMedium,
            decoration: _buildInputDecoration(
              hint: 'Masukkan password lama',
              icon: Icons.lock_outline_rounded,
              obscure: _obscureLama,
              onToggle: () => setState(() => _obscureLama = !_obscureLama),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Password lama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          _buildLabel('Password Baru'),
          const SizedBox(height: 7),
          TextFormField(
            controller: _passwordBaruC,
            obscureText: _obscureBaru,
            style: AppTextStyles.bodyMedium,
            onChanged: (_) => setState(() {}),
            decoration: _buildInputDecoration(
              hint: 'Minimal 6 karakter, huruf & angka',
              icon: Icons.lock_reset_rounded,
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
          const SizedBox(height: 10),
          // Indikator kekuatan password (visual, tidak mengubah validasi).
          Row(
            children: List.generate(3, (index) {
              final active = strength > index;
              final color = strength == 1
                  ? AppColors.dangerRed
                  : strength == 2
                  ? AppColors.accentAmber
                  : AppColors.accentMint;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
                  decoration: BoxDecoration(
                    color: active ? color : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _buildRequirement('6+ karakter', hasLength),
              _buildRequirement('Huruf', hasLetter),
              _buildRequirement('Angka', hasNumber),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabel('Konfirmasi Password Baru'),
          const SizedBox(height: 7),
          TextFormField(
            controller: _passwordKonfirmasiC,
            obscureText: _obscureKonfirmasi,
            style: AppTextStyles.bodyMedium,
            decoration: _buildInputDecoration(
              hint: 'Ketik ulang password baru',
              icon: Icons.lock_reset_rounded,
              obscure: _obscureKonfirmasi,
              onToggle: () =>
                  setState(() => _obscureKonfirmasi = !_obscureKonfirmasi),
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
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _handleSimpanPassword,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.4,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 18),
              label: const Text('Simpan Password'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String label, bool met) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 13,
          color: met ? AppColors.accentMint : AppColors.textTertiary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 9.5,
            color: met ? AppColors.accentMint : AppColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.eyebrow.copyWith(
        color: AppColors.textSecondary,
        fontSize: 9.5,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildAboutCard() {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              const AppIconTile(
                icon: Icons.school_rounded,
                color: AppColors.primaryBlue,
                size: 42,
                iconSize: 20,
                radius: 13,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.schoolName,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 13.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppConstants.tagline,
                      style: AppTextStyles.caption.copyWith(fontSize: 8.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                _buildInfoRow('Versi Aplikasi', AppConstants.appVersion),
                const Divider(height: 1, color: AppColors.divider),
                _buildInfoRow('Semester Aktif', AppConstants.currentSemester),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.smallText.copyWith(fontSize: 11.5)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _handleLogout,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.chipRedBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.dangerRed.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.dangerRed,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Keluar dari akun',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.dangerRed,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.dangerRed,
                size: 17,
              ),
            ],
          ),
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
      hintStyle: AppTextStyles.bodySecondary.copyWith(
        color: AppColors.textTertiary,
        fontSize: 12.5,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: Icon(icon, color: AppColors.textSecondary, size: 19),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: AppColors.textSecondary,
          size: 19,
        ),
        onPressed: onToggle,
      ),
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

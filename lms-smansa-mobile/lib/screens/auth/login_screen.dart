import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_client.dart';
import '../../core/api/auth_service.dart';
import '../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nisController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final nis = _nisController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await AuthService.instance.login(nis: nis, password: password);
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Ganti seluruh stack dengan MainShell (tidak bisa kembali ke login)
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.mainShell,
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showErrorDialog('Login Gagal', e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showErrorDialog(
        'Login Gagal',
        'Tidak dapat terhubung ke server. Pastikan server web guru aktif, lalu coba lagi.',
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Header ─────────────────────────────────────────────
            ClipPath(
              clipper: _LoginCurveClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 72, 24, 72),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryBlueDark, AppColors.primaryBlue],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo_smansa.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppConstants.schoolName,
                      style: AppTextStyles.headerTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Masuk untuk mengakses LMS',
                      style: AppTextStyles.headerSubtitle,
                    ),
                  ],
                ),
              ),
            ),

            // ─── Form ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Transform.translate(
                offset: const Offset(0, -32),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang 👋',
                          style: AppTextStyles.sectionTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Silakan masuk menggunakan akun siswa Anda',
                          style: AppTextStyles.bodySecondary,
                        ),
                        const SizedBox(height: 24),

                        // NIS
                        Text(
                          'NIS',
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nisController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: AppTextStyles.bodyText,
                          decoration: _inputDecoration(
                            hint: 'Masukkan NIS',
                            icon: Icons.badge_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'NIS tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        Text(
                          'Password',
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: AppTextStyles.bodyText,
                          decoration:
                              _inputDecoration(
                                hint: 'Masukkan password',
                                icon: Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                          onFieldSubmitted: (_) => _handleLogin(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Lupa password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _showErrorDialog(
                                'Lupa Password',
                                'Silakan hubungi operator/administrator sekolah untuk mereset password Anda.',
                              );
                            },
                            child: Text(
                              'Lupa Password?',
                              style: AppTextStyles.smallText.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Tombol Login
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text('MASUK'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Footer ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.chipBlueBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Gunakan NIS & password yang diberikan oleh sekolah Anda.',
                            style: AppTextStyles.smallText.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '© ${DateTime.now().year} ${AppConstants.schoolName}',
                    style: AppTextStyles.smallText.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodySecondary,
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

class _LoginCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

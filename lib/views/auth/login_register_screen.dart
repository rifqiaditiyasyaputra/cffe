import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../customer/main_navigation.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Login Controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Register Controllers
  final _regNameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPasswordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Brand Logo & Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCoffee,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_cafe, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'KopiKita',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryCoffee,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Selamat Datang Kembali!',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Masuk ke akun Anda atau jelajahi menu hangat kami.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 24),

              // Tab Bar (Masuk / Daftar)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.primaryCoffee,
                  labelColor: AppTheme.primaryCoffee,
                  unselectedLabelColor: AppTheme.textMuted,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Masuk'),
                    Tab(text: 'Daftar'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tab Bar View Form Area
              SizedBox(
                height: 340,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Login Form
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'contoh@email.com',
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Email wajib diisi';
                              if (!val.contains('@')) return 'Format email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _loginPasswordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Kata Sandi',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Kata sandi wajib diisi';
                              if (val.length < 6) return 'Minimal 6 karakter';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  bool success = authProvider.login(
                                    _loginEmailController.text,
                                    _loginPasswordController.text,
                                  );
                                  if (success) {
                                    _navigateToHome();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Gagal login. Periksa email & kata sandi.')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Masuk'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Register Form
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _regNameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Lengkap',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Nama wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _regEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (val) => val == null || !val.contains('@') ? 'Email valid dibutuhkan' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _regPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Kata Sandi',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (val) => val == null || val.length < 6 ? 'Minimal 6 karakter' : null,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_registerFormKey.currentState!.validate()) {
                                  authProvider.register(
                                    _regNameController.text,
                                    _regEmailController.text,
                                    _regPasswordController.text,
                                  );
                                  _navigateToHome();
                                }
                              },
                              child: const Text('Daftar Akun'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              // Guest Access Option
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    authProvider.loginAsGuest();
                    _navigateToHome();
                  },
                  icon: const Icon(Icons.explore_outlined, color: AppTheme.mochaBrown),
                  label: Text(
                    'Masuk sebagai Tamu (Lihat Menu)',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryCoffee,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

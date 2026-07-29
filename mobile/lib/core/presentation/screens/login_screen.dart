import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/app_state_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    // Run shimmer once at the beginning
    _shimmerController.forward();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppStateProvider>();
      final success = await appState.login(email, password);

      if (success) {
        if (mounted) {
          // Navigation will happen automatically because main.dart watches appState.isAuthenticated
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales inválidas')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final message = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onyx,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hydroelectric Name with Splash Style (Shader)
                      AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          final baseColor = Color.lerp(
                            Colors.white10,
                            AppColors.volt,
                            _shimmerController.value,
                          )!;

                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  baseColor,
                                  baseColor,
                                  Colors.yellowAccent,
                                  Colors.white,
                                  Colors.yellowAccent,
                                  baseColor,
                                  baseColor,
                                ],
                                stops: [
                                  0.0,
                                  (_shimmerController.value - 0.2).clamp(0.0, 1.0),
                                  (_shimmerController.value - 0.1).clamp(0.0, 1.0),
                                  _shimmerController.value.clamp(0.0, 1.0),
                                  (_shimmerController.value + 0.1).clamp(0.0, 1.0),
                                  (_shimmerController.value + 0.2).clamp(0.0, 1.0),
                                  1.0,
                                ],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'QARWAQIRU MICHAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'SISTEMA DE GESTIÓN ELÉCTRICA',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.1),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 30,
                        height: 1,
                        color: AppColors.volt.withOpacity(0.3),
                      ),
                      const SizedBox(height: 60),

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'EMAIL',
                        icon: Icons.alternate_email,
                      ),
                      const SizedBox(height: 25),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'CONTRASEÑA',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: 50),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppColors.volt,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: AppColors.volt.withOpacity(0.5), width: 1),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.volt,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'ENTRAR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 2,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer Brand
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'INVOLT . INFIRA',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.15),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            hintText,
            style: const TextStyle(
              color: AppColors.volt,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            cursorColor: AppColors.volt,
            decoration: InputDecoration(
              hintText: '...',
              hintStyle: const TextStyle(color: Colors.white10),
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white12,
                        size: 20,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

}

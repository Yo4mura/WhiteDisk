import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'home_screen.dart';

// ==================== AUTH SCREEN ====================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;

  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    _controller2 = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    _controller3 = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _controller4 = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    // Простая валидация
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    if (!isLogin && _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите имя')),
      );
      return;
    }

    // Переход на главную страницу
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _handleGoogleAuth() {
    // Здесь будет логика Google авторизации
    // Пока просто переходим на главную
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Rotating vinyls background
          // Top Left - Grey vinyl
          Positioned(
            top: 100,
            left: -30,
            child: _buildRotatingVinyl(
              _controller1,
              170,
              Colors.grey.shade800,
              imagePath: 'assets/vinyl1.png',
            ),
          ),
          // Top Right - Large white/cream vinyl (half visible)
          Positioned(
            top: -20,
            right: -120,
            child: _buildRotatingVinyl(
              _controller2,
              280,
              const Color(0xFFEFEDE3),
              imagePath: 'assets/vinyl2.png',
            ),
          ),
          // Middle Left - White vinyl
          Positioned(
            top: 330,
            left: 30,
            child: _buildRotatingVinyl(
              _controller3,
              165,
              Colors.white,
              imagePath: 'assets/vinyl3.png',
            ),
          ),
          // Middle Right - Black vinyl with white label
          Positioned(
            top: 390,
            right: 10,
            child: _buildRotatingVinyl(
              _controller4,
              200,
              Colors.grey.shade900,
              imagePath: 'assets/vinyl4.png',
            ),
          ),
          // Bottom - Beige/tan vinyl (partially visible)
          Positioned(
            bottom: -80,
            left: -20,
            child: _buildRotatingVinyl(
              _controller1,
              280,
              const Color(0xFFD4C5A0),
              imagePath: 'assets/vinyl5.png',
            ),
          ),

          // Auth form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Logo/Title
                    const Icon(
                      Icons.album,
                      size: 60,
                      color: Color(0xFFEFEDE3),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'MusicApp',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEFEDE3),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Auth form container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Toggle between login and register
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLogin = true),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isLogin
                                          ? const Color(0xFFEFEDE3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Войти',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isLogin
                                            ? const Color(0xFF171716)
                                            : const Color(0xFFEFEDE3),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLogin = false),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !isLogin
                                          ? const Color(0xFFEFEDE3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Регистрация',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: !isLogin
                                            ? const Color(0xFF171716)
                                            : const Color(0xFFEFEDE3),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Name field (only for registration)
                          if (!isLogin) ...[
                            _buildTextField(
                              controller: _nameController,
                              hint: 'Имя',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Email field
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Пароль',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 24),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleAuth,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEFEDE3),
                                foregroundColor: const Color(0xFF171716),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                isLogin ? 'Войти' : 'Зарегистрироваться',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color:
                                      const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'или',
                                  style: TextStyle(
                                    color: const Color(0xFFEFEDE3)
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color:
                                      const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Google sign in button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _handleGoogleAuth,
                              icon: const Icon(Icons.g_mobiledata, size: 28),
                              label: const Text('Войти через Google'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFEFEDE3),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(
                                  color:
                                      const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Color(0xFFEFEDE3)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEFEDE3),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildRotatingVinyl(
    AnimationController controller,
    double size,
    Color color, {
    String? imagePath,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: imagePath != null
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderVinyl(size, color);
                      },
                    )
                  : _buildPlaceholderVinyl(size, color),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderVinyl(double size, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Grooves
          for (int i = 0; i < 5; i++)
            Container(
              width: size * (0.9 - i * 0.15),
              height: size * (0.9 - i * 0.15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
            ),
          // Center hole
          Container(
            width: size * 0.15,
            height: size * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF171716),
              border: Border.all(
                color: color.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

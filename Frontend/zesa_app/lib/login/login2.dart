import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class SunSwapAuthScreen2 extends StatefulWidget {
  const SunSwapAuthScreen2({Key? key}) : super(key: key);

  @override
  State<SunSwapAuthScreen2> createState() => _SunSwapAuthScreen2State();
}

class _SunSwapAuthScreen2State extends State<SunSwapAuthScreen2>
    with TickerProviderStateMixin {
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late AnimationController _buttonController;
  late Animation<double> _logoRotation;
  late Animation<double> _logoGlow;
  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  // Enhanced color palette
  static const Color _primaryBg = Color(0xFF2c3e50);
  static const Color _cardBg = Color(0xFF34495e);
  static const Color _accentOrange = Color(0xFFf39c12);
  static const Color _accentYellow = Color(0xFFffc107);
  static const Color _textPrimary = Color(0xFFecf0f1);
  static const Color _textSecondary = Color(0xFFbdc3c7);
  static const Color _surfaceLight = Color(0xFF404d5b);

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    
    _logoController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _logoRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.linear),
    );

    _logoGlow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _buttonController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      // Clear form when switching modes
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Button press animation
      _buttonController.forward().then((_) {
        _buttonController.reverse();
      });
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        _showSuccessMessage(_isLogin ? 'Welcome back!' : 'Account created successfully!');
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    
    // Simulate Google sign-in
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      _showSuccessMessage('Google Sign-In successful!');
    }
  }

  void _handleForgotPassword() {
    _showInfoMessage('Password reset link will be sent to your email.');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: _accentOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: _surfaceLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _logoGlow]),
      builder: (context, child) {
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _accentYellow.withOpacity(_logoGlow.value),
                _accentOrange.withOpacity(_logoGlow.value * 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _accentOrange.withOpacity(_logoGlow.value * 0.4),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Transform.rotate(
            angle: _logoRotation.value,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: CustomPaint(
                painter: SunSwapLogoPainter(_logoGlow.value),
                size: const Size(90, 90),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        validator: validator,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          color: _textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(
            color: _textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, color: _textSecondary, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: _textSecondary,
                    size: 20,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
          filled: true,
          fillColor: _surfaceLight.withOpacity(0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _surfaceLight.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _accentOrange, width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2.5),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback? onPressed) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (_buttonController.value * 0.03),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: _isLoading 
                  ? LinearGradient(
                      colors: [_textSecondary, _textSecondary.withOpacity(0.8)],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_accentYellow, _accentOrange],
                    ),
              boxShadow: [
                BoxShadow(
                  color: (_isLoading ? _textSecondary : _accentOrange).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _surfaceLight.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        icon: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.g_mobiledata_rounded,
            color: Colors.black87,
            size: 20,
          ),
        ),
        label: Text(
          'Continue with Google',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthToggle() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _surfaceLight.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _isLogin ? null : _toggleAuthMode,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _isLogin ? _accentOrange.withOpacity(0.9) : Colors.transparent,
                ),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: _isLogin ? FontWeight.w600 : FontWeight.w400,
                    color: _isLogin ? Colors.white : _textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: !_isLogin ? null : _toggleAuthMode,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: !_isLogin ? _accentOrange.withOpacity(0.9) : Colors.transparent,
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: !_isLogin ? FontWeight.w600 : FontWeight.w400,
                    color: !_isLogin ? Colors.white : _textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isLogin) ...[
            _buildInputField(
              label: 'Full Name',
              controller: _nameController,
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
          ],
          _buildInputField(
            label: 'Email Address',
            controller: _emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email address';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          _buildInputField(
            label: 'Password',
            controller: _passwordController,
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            toggleVisibility: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              if (!_isLogin && !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                return 'Password must include uppercase, lowercase, and numbers';
              }
              return null;
            },
          ),
          if (!_isLogin) ...[
            _buildInputField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              icon: Icons.lock_outline_rounded,
              isPassword: true,
              isPasswordVisible: _isConfirmPasswordVisible,
              toggleVisibility: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 8),
          _buildPrimaryButton(
            _isLogin ? 'Sign In' : 'Create Account',
            _handleSubmit,
          ),
          const SizedBox(height: 16),
          if (_isLogin) ...[
            Center(
              child: TextButton(
                onPressed: _isLoading ? null : _handleForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    color: _accentOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: _textSecondary.withOpacity(0.3),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: _textSecondary.withOpacity(0.3),
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGoogleButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBg,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: EnergyGridPainter(_backgroundController.value),
                size: Size.infinite,
              );
            },
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape = constraints.maxWidth > constraints.maxHeight;
                final cardWidth = isLandscape 
                    ? math.min(constraints.maxWidth * 0.5, 480.0)
                    : math.min(constraints.maxWidth * 0.9, 400.0);
                
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: cardWidth,
                        minHeight: constraints.maxHeight * (isLandscape ? 0.6 : 0.8),
                      ),
                      child: Card(
                        color: _cardBg,
                        elevation: 24,
                        shadowColor: Colors.black.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildAnimatedLogo(),
                              const SizedBox(height: 24),
                              Text(
                                'SunSwap',
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: _textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Neighbors Powering Neighbourhoods',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: _textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              _buildAuthToggle(),
                              const SizedBox(height: 32),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.0, 0.1),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      )),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  key: ValueKey(_isLogin),
                                  child: _buildAuthForm(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SunSwapLogoPainter extends CustomPainter {
  final double glowIntensity;
  
  SunSwapLogoPainter(this.glowIntensity);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white;

    // Draw interlocking arcs forming a sun symbol
    final path1 = Path();
    path1.addArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      -math.pi / 4,
      math.pi,
    );

    final path2 = Path();
    path2.addArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      math.pi * 3 / 4,
      math.pi,
    );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);

    // Draw energy flow indicator (play button style arrow)
    final arrowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(glowIntensity);

    final arrowPath = Path();
    final arrowSize = radius * 0.3;
    arrowPath.moveTo(center.dx - arrowSize * 0.3, center.dy - arrowSize * 0.4);
    arrowPath.lineTo(center.dx + arrowSize * 0.5, center.dy);
    arrowPath.lineTo(center.dx - arrowSize * 0.3, center.dy + arrowSize * 0.4);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(SunSwapLogoPainter oldDelegate) {
    return oldDelegate.glowIntensity != glowIntensity;
  }
}

class EnergyGridPainter extends CustomPainter {
  final double animationValue;

  EnergyGridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Create subtle energy grid lines
    for (int i = 0; i < 4; i++) {
      final path = Path();
      final offsetY = size.height * 0.2 * i + (animationValue * 100) % size.height;
      
      for (double x = -100; x < size.width + 100; x += 80) {
        final y = offsetY + 30 * math.sin((x * 0.01) + (animationValue * 2 * math.pi));
        if (x == -100) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      final gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          const Color(0xFFf39c12).withOpacity(0.1 * (1 - i * 0.2)),
          const Color(0xFFffc107).withOpacity(0.15 * (1 - i * 0.2)),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      );
      
      paint.shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
      
      canvas.drawPath(path, paint);
    }

    // Add floating energy nodes
    final nodePaint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < 8; i++) {
      final angle = (animationValue * 2 * math.pi) + (i * math.pi / 4);
      final radius = 150 + 50 * math.sin(animationValue * math.pi + i);
      final x = size.width * 0.5 + radius * math.cos(angle);
      final y = size.height * 0.5 + radius * math.sin(angle);
      
      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        final nodeRadius = 6 + 3 * math.sin(animationValue * 4 * math.pi + i);
        
        nodePaint.color = const Color(0xFFf39c12).withOpacity(0.15);
        canvas.drawCircle(Offset(x, y), nodeRadius, nodePaint);
        
        nodePaint.color = const Color(0xFFffc107).withOpacity(0.25);
        canvas.drawCircle(Offset(x, y), nodeRadius * 0.6, nodePaint);
      }
    }
  }

  @override
  bool shouldRepaint(EnergyGridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SunSwapAuthScreen extends StatefulWidget {
  const SunSwapAuthScreen({Key? key}) : super(key: key);

  @override
  State<SunSwapAuthScreen> createState() => _SunSwapAuthScreenState();
}

class _SunSwapAuthScreenState extends State<SunSwapAuthScreen> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    final Color primaryBg = const Color(0xFF2c3e50);
    final Color accent = const Color(0xFFf39c12);
    final Color textColor = Colors.grey[200]!;

    return Scaffold(
      backgroundColor: primaryBg,
      body: Stack(
        children: [
          // Subtle animated background
          Positioned.fill(
            child: AnimatedBackground(
              
            ),
          ),

          // Centered content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: primaryBg.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      SvgPicture.string(
                        _sunSwapLogo,
                        width: 64,
                        height: 64,
                        color: accent,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "SunSwap",
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Animated form switcher
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: showLogin
                            ? _buildLoginForm(accent, textColor)
                            : _buildSignupForm(accent, textColor),
                      ),

                      const SizedBox(height: 16),

                      // Toggle between login and signup
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showLogin = !showLogin;
                          });
                        },
                        child: Text(
                          showLogin
                              ? "Don’t have an account? Sign Up"
                              : "Already have an account? Login",
                          style: GoogleFonts.inter(color: accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(Color accent, Color textColor) {
    return Column(
      key: const ValueKey("loginForm"),
      children: [
        _buildTextField(Icons.email, "Email", false, textColor),
        const SizedBox(height: 16),
        _buildTextField(Icons.lock, "Password", true, textColor),
        const SizedBox(height: 12),

        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     onPressed: () {},
        //     child: Text("Forgot Password?",
        //         style: GoogleFonts.inter(color: accent)),
        //   ),
        // ),
        // const SizedBox(height: 12),

        _buildPrimaryButton("Login", accent),
        const SizedBox(height: 16),

        _buildGoogleButton(),
      ],
    );
  }

  Widget _buildSignupForm(Color accent, Color textColor) {
    return Column(
      key: const ValueKey("signupForm"),
      children: [
        _buildTextField(Icons.person, "Full Name", false, textColor),
        const SizedBox(height: 16),
        _buildTextField(Icons.email, "Email", false, textColor),
        const SizedBox(height: 16),
        _buildTextField(Icons.lock, "Password", true, textColor),
        const SizedBox(height: 16),
        _buildTextField(Icons.lock_outline, "Confirm Password", true, textColor),
        const SizedBox(height: 16),

        _buildPrimaryButton("Sign Up", accent),
        const SizedBox(height: 16),

        _buildGoogleButton(),
      ],
    );
  }

  Widget _buildTextField(
      IconData icon, String label, bool isPassword, Color textColor) {
    return TextFormField(
      obscureText: isPassword,
      style: GoogleFonts.inter(color: textColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: textColor.withOpacity(0.8)),
        labelText: label,
        labelStyle: GoogleFonts.inter(color: textColor.withOpacity(0.8)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.amber.shade400),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, Color accent) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade400),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        icon: Image.network(
          "https://developers.google.com/identity/images/g-logo.png",
          height: 18,
        ),
        onPressed: () {},
        label: Text(
          "Continue with Google",
          style: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Minimal, abstract animated background
class AnimatedBackground extends StatefulWidget {
  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _BackgroundPainter(_controller.value),
        );
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double progress;
  _BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 6; i++) {
      final radius = (size.width / 3) +
          40 * (progress + i / 6); // slight shift over time
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Simple SVG logo for SunSwap (circle + play-arrow)
const String _sunSwapLogo = '''
<svg viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="48" stroke="currentColor" stroke-width="6" fill="none"/>
  <polygon points="40,30 70,50 40,70" fill="currentColor"/>
</svg>
''';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThemedLogoutButton extends StatefulWidget {
  final VoidCallback onLogout;
  final double? width;

  const ThemedLogoutButton({
    Key? key,
    required this.onLogout,
    this.width,
  }) : super(key: key);

  @override
  State<ThemedLogoutButton> createState() => _ThemedLogoutButtonState();
}

class _ThemedLogoutButtonState extends State<ThemedLogoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                  Color(0xFF0f3460),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFff0055).withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFff0055).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFff0055).withOpacity(0.2),
                        const Color(0xFFff0055).withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Color(0xFFff0055),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Logout?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildDialogButton(
                        label: 'Cancel',
                        onTap: () => Navigator.pop(context),
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDialogButton(
                        label: 'Logout',
                        onTap: () {
                          Navigator.pop(context);
                          widget.onLogout();
                        },
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [Color(0xFFff0055), Color(0xFFff6b35)],
                  )
                : null,
            color: isPrimary ? null : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _showLogoutDialog(context);
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: widget.width ?? double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFff0055),
                    Color(0xFFff6b35),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFff0055).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFff0055).withOpacity(
                      0.3 + 0.2 * _pulseController.value,
                    ),
                    blurRadius: 20 + 10 * _pulseController.value,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated background effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CustomPaint(
                        painter: LogoutWavePainter(_pulseController.value),
                      ),
                    ),
                  ),
                  
                  // Content
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for animated wave effect
class LogoutWavePainter extends CustomPainter {
  final double animation;

  LogoutWavePainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw flowing waves
    for (int i = 0; i < 2; i++) {
      final offset = (animation + i * 0.5) % 1.0;
      final opacity = (1 - (offset - 0.5).abs() * 2).clamp(0.0, 1.0);
      
      paint.color = Colors.white.withOpacity(0.1 * opacity);
      
      final path = Path();
      path.moveTo(0, size.height * 0.5);
      
      for (double x = 0; x <= size.width; x += 10) {
        final y = size.height * 0.5 + 
                  math.sin((x / size.width + offset) * math.pi * 4) * 15;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(LogoutWavePainter oldDelegate) => true;
}

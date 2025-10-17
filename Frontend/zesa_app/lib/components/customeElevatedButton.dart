import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedElevatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final int? notificationCount; // Optional badge count
  final bool hasUnread; // Show pulsing indicator
  final String title;
  final IconData icon;

  const AnimatedElevatedButton({
    Key? key,
    required this.onPressed,
    this.notificationCount,
    this.hasUnread = false, 
    required this.title, 
    required this.icon,
  }) : super(key: key);

  @override
  State<AnimatedElevatedButton> createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton>
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00d9ff),
                    Color(0xFF0099cc),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF00d9ff).withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00d9ff).withOpacity(
                      widget.hasUnread
                          ? 0.4 + 0.3 * _pulseController.value
                          : 0.3,
                    ),
                    blurRadius: widget.hasUnread
                        ? 20 + 15 * _pulseController.value
                        : 20,
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
                clipBehavior: Clip.none,
                children: [
                  // Animated background effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CustomPaint(
                        painter: NotificationWavePainter(_pulseController.value),
                      ),
                    ),
                  ),

                  // Content
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text( widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  // Notification badge
                  if (widget.notificationCount != null && widget.notificationCount! > 0)
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFff0055), Color(0xFFff6b35)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF1a1a2e),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFff0055).withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.notificationCount! > 99
                              ? '99+'
                              : '${widget.notificationCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                  // Unread indicator dot
                  if (widget.hasUnread && (widget.notificationCount == null || widget.notificationCount == 0))
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFff0055), Color(0xFFff6b35)],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1a1a2e),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFff0055).withOpacity(
                                0.5 + 0.3 * _pulseController.value,
                              ),
                              blurRadius: 8 * _pulseController.value,
                              spreadRadius: 2 * _pulseController.value,
                            ),
                          ],
                        ),
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
class NotificationWavePainter extends CustomPainter {
  final double animation;

  NotificationWavePainter(this.animation);

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
      path.moveTo(0, size.height * 0.6);
      
      for (double x = 0; x <= size.width; x += 8) {
        final y = size.height * 0.6 + 
                  math.sin((x / size.width + offset) * math.pi * 5) * 12;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(NotificationWavePainter oldDelegate) => true;
}
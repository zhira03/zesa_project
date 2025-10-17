import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedThemedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const AnimatedThemedAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<AnimatedThemedAppBar> createState() => _AnimatedThemedAppBarState();
}

class _AnimatedThemedAppBarState extends State<AnimatedThemedAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
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
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF1a1a2e),
                  const Color(0xFF0f3460),
                  _controller.value * 0.3,
                )!,
                const Color(0xFF16213e),
                Color.lerp(
                  const Color(0xFF0f3460),
                  const Color(0xFF1a1a2e),
                  _controller.value * 0.3,
                )!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00d9ff).withOpacity(0.1 + 0.1 * _controller.value),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 70,
            title: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF00d9ff),
                    const Color(0xFF00ff88),
                    _controller.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF00ff88),
                    const Color(0xFF00d9ff),
                    _controller.value,
                  )!,
                ],
              ).createShader(bounds),
              child: Text(
                widget.title,
                style: GoogleFonts.zenDots(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            actions: widget.actions,
          ),
        );
      },
    );
  }
}
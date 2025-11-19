import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:WattTrade/components/themes.dart';

class ThemeModeSlider extends StatefulWidget {
  final bool isDarkMode;
  const ThemeModeSlider({super.key, required this.isDarkMode});

  @override
  State<ThemeModeSlider> createState() => _ThemeModeSliderState();
}

class _ThemeModeSliderState extends State<ThemeModeSlider> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
  }

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleTheme,
      child: Container(
        width: 180,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Stack(
          children: [
            // Sliding background indicator
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: _isDark ? 0 : 90,
              top: 0,
              bottom: 0,
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  color: _isDark ? Colors.black : Colors.yellow,
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
            // Dark mode section
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 90,
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: _isDark ? 1.0 : 0.75,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _isDark ? Colors.white : Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.nightlight_round,
                          size: 20,
                          color: _isDark ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 4),
                        const Text('Dark'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Light mode section
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 90,
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: _isDark ? 0.75 : 1.0,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _isDark ? Colors.black : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          size: 20,
                          color: _isDark ? Colors.black : Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Text('Light'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
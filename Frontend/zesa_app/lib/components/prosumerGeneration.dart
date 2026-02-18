import 'package:flutter/material.dart';
import 'dart:math' as math;

class GenerationStats extends StatefulWidget {
  final int panelCount;
  final double panelSize;
  final double inverterCapacity;
  final double batteryCapacity;
  final double generatedkWh;
  final double exportingToGrid;
  final double efficiency;

  const GenerationStats({
    Key? key,
    required this.panelCount,
    required this.panelSize,
    required this.inverterCapacity,
    required this.batteryCapacity,
    required this.generatedkWh,
    required this.exportingToGrid, 
    required this.efficiency,
  }) : super(key: key);

  @override
  State<GenerationStats> createState() => _GenerationStatsState();
}

class _GenerationStatsState extends State<GenerationStats>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late AnimationController _pulseController;

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

  double _panelPower(int count, double size) {
    final  double powerOut =  (count * size) / 1000;
    return powerOut;
  }

  @override
  Widget build(BuildContext context) {
    final totalCapacity = _panelPower(widget.panelCount, widget.panelSize);
    final efficiency = widget.efficiency;

    return Container(
      width: 230,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
            const Color(0xFF0f3460),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00d9ff).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Animated background effect
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: EnergyFlowPainter(_pulseController.value),
                  );
                },
              ),
            ),
            
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient overlay
                Stack(
                  children: [
                    // Background image with overlay
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/prosumer/dayLightGen.jpg',
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue[900]!,
                                      Colors.blue[700]!,
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.solar_power, 
                                    size: 60, 
                                    color: Colors.white54,
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                  const Color(0xFF16213e).withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Favorite button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? const Color(0xFFff0055) : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // Main energy display
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LIVE OUTPUT',
                            style: TextStyle(
                              color: const Color(0xFF00d9ff),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.generatedkWh.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  'kWh',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Efficiency indicator
                    Positioned(
                      bottom: 12,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF00d9ff).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00d9ff).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.bolt,
                                    color: Color(0xFF00d9ff),
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${efficiency.toStringAsFixed(0)}% Efficient',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00ff88),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00ff88).withOpacity(
                                          0.6 * _pulseController.value,
                                        ),
                                        blurRadius: 8 * _pulseController.value,
                                        spreadRadius: 2 * _pulseController.value,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Stats section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Export to grid
                      _buildStatRow(
                        icon: Icons.public,
                        label: 'Ready to Export to Grid',
                        value: '${widget.exportingToGrid.toStringAsFixed(2)} kWh',
                        color: const Color(0xFF00ff88),
                        showPulse: widget.exportingToGrid > 0,
                      ),
                      const SizedBox(height: 12),
                      
                      // current System specs
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow('Panel Output', '${totalCapacity.toStringAsFixed(2)} kW'),
                            const SizedBox(height: 8),
                            _buildSpecRow('Inverter', '${widget.inverterCapacity} kVA'),
                            const SizedBox(height: 8),
                            _buildSpecRow('Battery', '${widget.batteryCapacity} Ah'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool showPulse = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (showPulse)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.6 * _pulseController.value),
                      blurRadius: 6 * _pulseController.value,
                      spreadRadius: 2 * _pulseController.value,
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Custom painter for animated energy flow effect
class EnergyFlowPainter extends CustomPainter {
  final double animation;

  EnergyFlowPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      final offset = (animation + i * 0.33) % 1.0;
      final opacity = (1 - (offset - 0.5).abs() * 2).clamp(0.0, 1.0);
      
      paint.color = const Color(0xFF00d9ff).withOpacity(0.1 * opacity);
      
      final path = Path();
      path.moveTo(0, size.height * (0.3 + offset * 0.4));
      
      for (double x = 0; x <= size.width; x += 20) {
        final y = size.height * (0.3 + offset * 0.4) + 
                  math.sin((x / size.width + offset) * math.pi * 4) * 10;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(EnergyFlowPainter oldDelegate) => true;
}
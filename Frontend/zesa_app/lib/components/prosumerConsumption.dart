import 'package:flutter/material.dart';
import 'dart:math' as math;

class UsageStats extends StatefulWidget {
  final double currentConsumption; // kWh currently being used
  final double batteryPercentage; // 0-100
  final double batteryCapacity; // Ah
  final double inverterOutput; // kW
  final double gridImport; // kWh imported from grid
  final double solarUsage; // kWh used from solar
  final double peakConsumption; // kWh peak for the day
  final String estimatedTimeRemaining; // Battery time remaining
  final double costSaved; // Money saved today
  final double carbonOffset; // kg CO2 saved

  const UsageStats({
    Key? key,
    required this.currentConsumption,
    required this.batteryPercentage,
    required this.batteryCapacity,
    required this.inverterOutput,
    this.gridImport = 0.0,
    this.solarUsage = 0.0,
    this.peakConsumption = 0.0,
    this.estimatedTimeRemaining = '--',
    this.costSaved = 0.0,
    this.carbonOffset = 0.0,
  }) : super(key: key);

  @override
  State<UsageStats> createState() => _UsageStatsState();
}

class _UsageStatsState extends State<UsageStats>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _batteryDrainController;
  late AnimationController _sparkController;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _batteryDrainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _batteryDrainController.dispose();
    _sparkController.dispose();
    super.dispose();
  }

  Color _getBatteryColor() {
    if (widget.batteryPercentage > 60) return const Color(0xFF00ff88);
    if (widget.batteryPercentage > 30) return const Color(0xFFffa500);
    return const Color(0xFFff0055);
  }

  IconData _getBatteryIcon() {
    if (widget.batteryPercentage > 90) return Icons.battery_full;
    if (widget.batteryPercentage > 60) return Icons.battery_5_bar;
    if (widget.batteryPercentage > 40) return Icons.battery_4_bar;
    if (widget.batteryPercentage > 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  String _getEnergySource() {
    if (widget.solarUsage > widget.gridImport) return 'Solar Power';
    if (widget.gridImport > 0) return 'Grid + Solar';
    return 'Battery';
  }

  @override
  Widget build(BuildContext context) {
    final batteryColor = _getBatteryColor();
    final energySource = _getEnergySource();

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
            color: const Color(0xFFff6b35).withOpacity(0.3),
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
                animation: _batteryDrainController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ConsumptionFlowPainter(
                      _batteryDrainController.value,
                      batteryColor,
                    ),
                  );
                },
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CONSUMPTION',
                            style: TextStyle(
                              color: const Color(0xFFff6b35),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showDetails = !_showDetails;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _showDetails ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white70,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _showDetails ? 'HIDE' : 'SHOW',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Current consumption display
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.currentConsumption.toStringAsFixed(2),
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
                              'kW',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          AnimatedBuilder(
                            animation: _sparkController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: (math.sin(_sparkController.value * math.pi * 2) + 1) / 2,
                                child: Icon(
                                  Icons.bolt,
                                  color: const Color(0xFFff6b35),
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Energy source indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFff6b35).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00ff88),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00ff88).withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Source: $energySource',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Battery Status Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          batteryColor.withOpacity(0.15),
                          batteryColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: batteryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Icon(
                                      _getBatteryIcon(),
                                      color: batteryColor,
                                      size: 24,
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Battery Status',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${widget.batteryCapacity.toStringAsFixed(0)} Ah',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '${widget.batteryPercentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: batteryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Battery progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Container(
                                    height: 8,
                                    width: (230 - 60) * (widget.batteryPercentage / 100),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          batteryColor,
                                          batteryColor.withOpacity(0.6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: batteryColor.withOpacity(0.5 * _pulseController.value),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Time remaining
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white.withOpacity(0.5),
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Est. ${widget.estimatedTimeRemaining} remaining',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stats section
                if (_showDetails) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Inverter output
                        _buildStatRow(
                          icon: Icons.power,
                          label: 'Inverter Output',
                          value: '${widget.inverterOutput.toStringAsFixed(2)} kW',
                          color: const Color(0xFFff6b35),
                        ),
                        const SizedBox(height: 10),
                        
                        // Grid import
                        _buildStatRow(
                          icon: Icons.cloud_download,
                          label: 'Grid Import',
                          value: '${widget.gridImport.toStringAsFixed(2)} kWh',
                          color: const Color(0xFF9d4edd),
                          showWarning: widget.gridImport > 0,
                        ),
                        const SizedBox(height: 10),
                        
                        // Solar usage
                        _buildStatRow(
                          icon: Icons.wb_sunny,
                          label: 'Solar Usage',
                          value: '${widget.solarUsage.toStringAsFixed(2)} kWh',
                          color: const Color(0xFFffd60a),
                        ),
                        const SizedBox(height: 10),
                        
                        // Peak consumption
                        _buildStatRow(
                          icon: Icons.trending_up,
                          label: 'Peak Today',
                          value: '${widget.peakConsumption.toStringAsFixed(2)} kW',
                          color: const Color(0xFF06ffa5),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Savings info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF00ff88).withOpacity(0.1),
                                const Color(0xFF00d9ff).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF00ff88).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.savings,
                                        color: const Color(0xFF00ff88),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Saved Today',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\$${widget.costSaved.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF00ff88),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.eco,
                                        color: const Color(0xFF00d9ff),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'CO₂ Offset',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${widget.carbonOffset.toStringAsFixed(1)} kg',
                                    style: const TextStyle(
                                      color: Color(0xFF00d9ff),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
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
    bool showWarning = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 16),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (showWarning)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFffa500).withOpacity(0.5 + 0.5 * _pulseController.value),
                size: 16,
              );
            },
          ),
      ],
    );
  }
}

// Custom painter for consumption flow effect
class ConsumptionFlowPainter extends CustomPainter {
  final double animation;
  final Color batteryColor;

  ConsumptionFlowPainter(this.animation, this.batteryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw flowing lines representing energy consumption
    for (int i = 0; i < 4; i++) {
      final offset = (animation + i * 0.25) % 1.0;
      final opacity = (1 - (offset - 0.5).abs() * 2).clamp(0.0, 1.0);
      
      paint.color = batteryColor.withOpacity(0.08 * opacity);
      
      final path = Path();
      final startY = size.height * offset;
      
      path.moveTo(size.width, startY);
      
      for (double x = size.width; x >= 0; x -= 15) {
        final y = startY + math.sin((x / size.width + offset) * math.pi * 6) * 8;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(ConsumptionFlowPainter oldDelegate) => true;
}
import 'package:flutter/material.dart';

class EnergyChart extends StatefulWidget {
  final double energyGenerated;
  final List<double> hourlyData; // 24 values for each hour
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final String title;
  final IconData icon;

  const EnergyChart({
    Key? key,
    required this.energyGenerated,
    required this.hourlyData,
    this.selectedPeriod = 'Day',
    required this.onPeriodChanged, 
    required this.title, 
    required this.icon,
  }) : super(key: key);

  @override
  State<EnergyChart> createState() => _EnergyChartState();
}

class _EnergyChartState extends State<EnergyChart> {
  final List<String> periods = ['Hour', 'Day', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(
                widget.icon,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Energy value
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.energyGenerated.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w300,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'kWh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Period buttons
          Row(
            children: periods.map((period) {
              final isSelected = period == widget.selectedPeriod;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => widget.onPeriodChanged(period),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF3a3a3a) : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Chart
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: Size(270, 180),
              painter: BarChartPainter(
                data: widget.hourlyData,
                maxValue: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final double maxValue;

  BarChartPainter({
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / data.length;
    final barSpacing = barWidth * 0.3;
    final actualBarWidth = barWidth - barSpacing;
    
    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeDashArray = [4, 4];
    
    // Draw 4 horizontal lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height - (size.height * i / 4);
      final path = Path();
      path.moveTo(0, y);
      path.lineTo(size.width, y);
      canvas.drawPath(path, gridPaint);
      
      // Draw labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(maxValue * i / 4).toInt()} kWh',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(size.width + 8, y - textPainter.height / 2),
      );
    }
    
    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxValue) * size.height;
      final x = i * barWidth + barSpacing / 2;
      final y = size.height - barHeight;
      
      // Create gradient based on bar height
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _getGradientColors(data[i] / maxValue),
      );
      
      final rect = Rect.fromLTWH(x, y, actualBarWidth, barHeight);
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;
      
      final rrect = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(2),
      );
      
      canvas.drawRRect(rrect, paint);
    }
    
    // Draw time labels
    final timeLabels = ['09:00', '12:00', '03:00', '06:00'];
    final timePositions = [0, data.length ~/ 3, data.length * 2 ~/ 3, data.length - 1];
    
    for (int i = 0; i < timeLabels.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: timeLabels[i],
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      final x = timePositions[i] * barWidth + actualBarWidth / 2 - textPainter.width / 2;
      textPainter.paint(
        canvas,
        Offset(x, size.height + 8),
      );
    }
  }
  
  List<Color> _getGradientColors(double ratio) {
    if (ratio > 0.75) {
      return [
        const Color(0xFFff6b6b),
        const Color(0xFFff8e53),
      ];
    } else if (ratio > 0.5) {
      return [
        const Color(0xFFffd93d),
        const Color(0xFFffb830),
      ];
    } else {
      return [
        const Color(0xFFffd93d),
        const Color(0xFFc7e96f),
      ];
    }
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    return true;
  }
}

// Extension for dashed lines
extension DashedPath on Paint {
  set strokeDashArray(List<double> dashArray) {
  }
}
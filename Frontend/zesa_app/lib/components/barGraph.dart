import 'package:flutter/material.dart';

class EnergyChart extends StatefulWidget {
  final double energyGenerated;
  final List<double> hourlyData; // 24 values for each hour
  final List<double> dailyData; // 24 values for each day
  final List<double> monthlyData; // 24 values for each month
  final List<double> yearlyData; // 24 values for each year
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  const EnergyChart({
    Key? key,
    required this.energyGenerated,
    required this.hourlyData,
    this.selectedPeriod = 'Hour',
    required this.onPeriodChanged, 
    required this.title, 
    required this.icon, 
    required this.gradientColors, 
    required this.dailyData, 
    required this.monthlyData, 
    required this.yearlyData,
  }) : super(key: key);

  @override
  State<EnergyChart> createState() => _EnergyChartState();
}

class _EnergyChartState extends State<EnergyChart> {
  final List<String> periods = ['Hour', 'Day', 'Month', 'Year'];

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
                padding: const EdgeInsets.only(right:6),
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
                data: widget.selectedPeriod == 'Hour'
                    ? widget.hourlyData
                    : widget.selectedPeriod == 'Day'
                        ? widget.dailyData
                            : widget.selectedPeriod == 'Month'
                                ? widget.monthlyData
                                : widget.yearlyData,
                maxValue: 20, 
                gradientColors: widget.gradientColors, 
                selectedPeriod: widget.selectedPeriod,
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
  final List<Color> gradientColors;
  final String selectedPeriod;

  BarChartPainter({
    required this.selectedPeriod,
    required this.gradientColors, 
    required this.data,
    required this.maxValue,
  });

  List<String> _getTimeLabels() {
    switch (selectedPeriod) {
      case 'Hour':
        return ['00:00', '06:00', '12:00', '18:00'];
      
      case 'Day':
        return ['Sun','Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      
      case 'Month':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      
      case 'Year':
        final currentYear = DateTime.now().year;
        return [
          '${currentYear - 2}',
          '${currentYear - 1}',
          '$currentYear',
          '${currentYear + 1}',
          '${currentYear + 2}',
        ];
      
      default:
        return ['00:00', '06:00', '12:00', '18:00'];
    }
  }

  List<int> _getLabelPositions(int dataLength, int labelCount) {
    if (labelCount == 0) return [];
    if (labelCount == 1) return [dataLength ~/ 2];
    
    return List.generate(labelCount, (i) {
      return (i * (dataLength - 1) / (labelCount - 1)).round();
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final timeLabels = _getTimeLabels();
    final labelCount = timeLabels.length;
    
    // Use label count to determine bar distribution
    final barCount = labelCount;
    final barWidth = (size.width / barCount);
    final actualBarWidth = barWidth * 0.6;
    
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
    
    // Draw bars - use the actual data length but distribute across full canvas
    final effectiveMaxValue = data.reduce((a, b) => a > b ? a : b) < maxValue
        ? maxValue
        : data.reduce((a, b) => a > b ? a : b);
    final topPadding = 1.0;
    final bottomPadding = 2.0;

    for (int i = 0; i < data.length && i < barCount; i++) {
      final barHeight = (data[i] / effectiveMaxValue) * (size.height - topPadding - bottomPadding);
      final x = i * barWidth + barWidth / 2 - actualBarWidth / 2;
      final y = size.height - barHeight - bottomPadding;

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _getGradientColors(data[i] / effectiveMaxValue),
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
    
    // Draw time labels - now aligned with bars
    debugPrint("Time labels: $timeLabels, dataLength: ${data.length}");

    double lastX = -double.infinity;
    const minLabelSpacing = 40.0; // Minimum pixels between labels

    for (int i = 0; i < labelCount; i++) {
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

      // Position labels at the center of each bar
      final x = i * barWidth + barWidth / 2 - textPainter.width / 2;
      
      // Only draw label if there's enough space from the previous one
      if (x - lastX >= minLabelSpacing || i == 0) {
        textPainter.paint(canvas, Offset(x, size.height + 8));
        lastX = x + textPainter.width;
      }
    }
  }
  
  List<Color> _getGradientColors(double ratio) {
  // Use the gradientColors passed to the widget
    if (gradientColors.length >= 4) {
      if (ratio > 0.75) {
        return [
          gradientColors[0],
          gradientColors[1],
        ];
      } else if (ratio > 0.5) {
        return [
          gradientColors[2],
          gradientColors[3],
        ];
      }
    }
    
    // Fallback to default colors
    return [
      gradientColors[3],
      Colors.white,
    ];
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
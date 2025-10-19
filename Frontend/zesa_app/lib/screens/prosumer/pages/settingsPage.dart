import 'package:WattTrade/components/barGraph.dart';
import 'package:WattTrade/components/pieChart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String selectedPeriod = 'Day';
  final _controller = PageController();
  
  final List<double> hourlyData = [
    0.5, 1.2, 2.5, 4.8, 7.5, 6.2, 7.5, 16.8, 18.5, 10.2, 12.8, 14.0,
    14.5, 15.8, 14.2, 14.5, 11.8, 8.5, 5.2, 2.8, 1.5, 0.8, 0.3, 0.1,
  ];

  // Daily data - 24 hours
  final List<double> dailyData = [
    0.5, //sunday 1st day
    1.2, // monday
    2.5, //tuesday
    4.8, //wednesday
    7.5, //thursday
    6.2, //friday
    7.5, //saturday
  ];

  // Monthly data - 30/31 days
  final List<double> monthlyData = [
    45.2, 48.5, 52.3, 49.8, 55.6, 58.2, 60.5, 62.8, 59.3, 61.5,
    63.2, 65.8
  ];

  // Yearly data - 12 months
  final List<double> yearlyData = [
    400, // 2 years ago
    500, // last year
    325, // currently
    845, // next year (projection)
    0 // 2 years from now
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports Page"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Last Updated: 3s ago"),
            SizedBox(
              // height: 300,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProgressStatsWidget(
                    overallPercentage: 65, 
                    categories: {
                      "Produced": 80,
                      "Consumed": 50,
                      "Excess": 70,
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Stack(
                children: [
                  SizedBox(
                    height: 400,
                    child: PageView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      children: [
                        EnergyChart(
                          title: 'Solar Power Generated',
                          icon: Icons.sunny,
                          energyGenerated: 18.37,
                          hourlyData: hourlyData,
                          dailyData: dailyData, 
                          monthlyData: monthlyData, 
                          yearlyData: yearlyData,
                          selectedPeriod: selectedPeriod,
                          onPeriodChanged: (period) {
                            setState(() {
                              selectedPeriod = period;
                            });
                          }, 
                          gradientColors: [  
                            Colors.green.shade700, 
                            Colors.green.shade600, 
                            Colors.green.shade400, 
                            Colors.green.shade200,
                          ],  
                        ), 
                        EnergyChart(
                          title: 'Solar Power Consumed',
                          icon: Icons.games_rounded,
                          energyGenerated: 18.37,
                          hourlyData: hourlyData,
                          dailyData: dailyData, 
                          monthlyData: monthlyData, 
                          yearlyData: yearlyData,
                          selectedPeriod: selectedPeriod,
                          onPeriodChanged: (period) {
                            setState(() {
                              selectedPeriod = period;
                            });
                          },  
                          gradientColors: [  
                            Colors.red.shade700, 
                            Colors.red.shade600, 
                            Colors.red.shade400, 
                            Colors.red.shade200,
                          ],
                        ), 
                        EnergyChart(
                          title: 'Solar Power sold',
                          icon: Icons.sell,
                          energyGenerated: 18.37,
                          hourlyData: hourlyData,
                          dailyData: dailyData, 
                          monthlyData: monthlyData, 
                          yearlyData: yearlyData,
                          selectedPeriod: selectedPeriod,
                          onPeriodChanged: (period) {
                            setState(() {
                              selectedPeriod = period;
                            });
                          },  
                          gradientColors: [  
                            Colors.blue.shade700, 
                            Colors.blue.shade600, 
                            Colors.blue.shade400, 
                            Colors.blue.shade200,
                          ], 
                        ),    
                      ]
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SmoothPageIndicator(
                      controller: _controller, 
                      count: 3,
                      effect: JumpingDotEffect(),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
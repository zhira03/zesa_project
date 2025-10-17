import 'package:WattTrade/components/barGraph.dart';
import 'package:WattTrade/components/pieChart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String selectedPeriod = 'Day';
  
  final List<double> hourlyData = [
    0.5, 1.2, 2.5, 4.8, 7.5, 10.2, 13.5, 16.8, 18.5, 19.2, 19.8, 20.0,
    19.5, 18.8, 17.2, 14.5, 11.8, 8.5, 5.2, 2.8, 1.5, 0.8, 0.3, 0.1,
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
            EnergyChart(
              title: 'Solar Power Generated',
              icon: Icons.sunny,
              energyGenerated: 18.37,
              hourlyData: hourlyData,
              selectedPeriod: selectedPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  selectedPeriod = period;
                });
              },  
            ), 
            const SizedBox(height: 10),
            EnergyChart(
              title: 'Solar Power Consumed',
              icon: Icons.games_rounded,
              energyGenerated: 18.37,
              hourlyData: hourlyData,
              selectedPeriod: selectedPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  selectedPeriod = period;
                });
              },  
            ), 
            const SizedBox(height: 10),
            EnergyChart(
              title: 'Solar Power sold',
              icon: Icons.sell,
              energyGenerated: 18.37,
              hourlyData: hourlyData,
              selectedPeriod: selectedPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  selectedPeriod = period;
                });
              },  
            ), 
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
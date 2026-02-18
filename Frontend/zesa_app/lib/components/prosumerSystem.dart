import 'package:WattTrade/components/batteryHelper.dart';
import 'package:WattTrade/components/inverterHelper.dart';
import 'package:WattTrade/components/panelHelper.dart';
import 'package:WattTrade/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SystemStats extends StatefulWidget {
  const SystemStats({super.key});

  @override
  State<SystemStats> createState() => _SystemStatsState();
}

class _SystemStatsState extends State<SystemStats> with TickerProviderStateMixin{
  final pageView = PageController();
  String solarType = 'Monocrystalline';
  String funFact = '';
  int panelCount = 2;
  double panelSize = 100;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 400,
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
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [

              // solar panels section
              SizedBox(
                height: 400,
                child: PageView(
                  controller: pageView,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: SizedBox(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.3,
                                child: Image.asset(
                                  Provider.of<ThemeProvider>(context).isDarkMode
                                    ? 'assets/prosumer/solarPanels1.jpg'
                                    : 'assets/prosumer/solarPanels1.jpg',
                                  height: 320,
                                  fit: BoxFit.fitWidth,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.solar_power,
                                        size: 60,
                                        color: Colors.white54,
                                      )
                                    );
                                  },
                                ),
                              ),
                            ),
                            SolarPanelsScreen()
                          ],
                        )
                      ),
                    ),

                    // inverter section
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.3,
                                child: Image.asset(
                                  Provider.of<ThemeProvider>(context).isDarkMode
                                    ? 'assets/prosumer/inverter1.jpg'
                                    : 'assets/prosumer/inverter1.jpg',
                                  height: 320,
                                  fit: BoxFit.fitWidth,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.solar_power,
                                        size: 60,
                                        color: Colors.white54,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            InverterSectionScreen()
                          ],
                        )
                      ),
                    ),

                    //batteries section
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.3,
                                child: Image.asset(
                                  Provider.of<ThemeProvider>(context).isDarkMode
                                    ? 'assets/prosumer/battery1.jpg'
                                    : 'assets/prosumer/battery1.jpg',
                                  height: 320,
                                  fit: BoxFit.fitWidth,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.solar_power,
                                        size: 60,
                                        color: Colors.white54,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: BatteryInfoScreen(),
                            )
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, 0.95),
                child: SmoothPageIndicator(
                  controller: pageView, 
                  count: 3,
                  effect: JumpingDotEffect(),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
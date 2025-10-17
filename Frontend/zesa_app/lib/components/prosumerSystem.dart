import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SystemStats extends StatefulWidget {
  const SystemStats({super.key});

  @override
  State<SystemStats> createState() => _SystemStatsState();
}

class _SystemStatsState extends State<SystemStats> with TickerProviderStateMixin{

  final pageView = PageController();


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
              SizedBox(
                height: 400,
                child: PageView(
                  controller: pageView,
                  children: [
                    Container(
                      color: Colors.red,
                      height: 80,
                      width: 80,
                      child: Center(
                        child: Column(
                          children: [
                            Text("Panels Info")
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.green,
                      height: 80,
                      width: 80,
                      child: Center(
                        child: Column(
                          children: [
                            Text("Inverter Info")
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      height: 80,
                      width: 80,
                      child: Center(
                        child: Column(
                          children: [
                            Text("Battery Info")
                          ],
                        ),
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
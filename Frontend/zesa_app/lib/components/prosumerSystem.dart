import 'package:flutter/material.dart';

class SystemStats extends StatefulWidget {
  const SystemStats({super.key});

  @override
  State<SystemStats> createState() => _SystemStatsState();
}

class _SystemStatsState extends State<SystemStats> with TickerProviderStateMixin{


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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/prosumer/dayLightGen.jpg',
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 190,
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
                          height: 190,
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
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("System Rating", 
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("6.5kVA",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    )
                  ),
                ]
              ),
            ],
          ),
        )
      ),
    );
  }
}
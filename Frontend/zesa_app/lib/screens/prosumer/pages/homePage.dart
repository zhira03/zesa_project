import 'package:WattTrade/components/customeElevatedButton.dart';
import 'package:WattTrade/components/prosumerConsumption.dart';
import 'package:WattTrade/components/prosumerGeneration.dart';
import 'package:WattTrade/components/prosumerHistory.dart';
import 'package:WattTrade/components/prosumerSystem.dart';
import 'package:WattTrade/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // primary: false,
        backgroundColor: Colors.greenAccent,
        elevation: 5,
        title: Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Greeting",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hey Taku",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton.filled(
            onPressed: (){}, 
            icon: Icon(Icons.settings),
            color: Colors.white70,
          ),
          const SizedBox(width: 2),
          IconButton(
            onPressed: (){
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            }, 
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                ? Icons.flash_on
                : Icons.electric_bolt
            ), 
            color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Colors.black
              : Colors.white,
            highlightColor: Colors.transparent,
            iconSize: 38,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      Provider.of<ThemeProvider>(context).isDarkMode
                        ? 'assets/prosumer/darkMode.jpg'
                        : 'assets/prosumer/dayLightGen2.jpg',
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
                  Column(
                    children: [
                      SizedBox(
                        height: 50, 
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            children: [
                              AnimatedElevatedButton(
                                onPressed: (){}, 
                                title: "Earnings", 
                                icon: Icons.monetization_on,
                              ),
                              SizedBox(width: 12),
                              AnimatedElevatedButton(
                                onPressed: (){}, 
                                title: "Settings",
                                icon: Icons.settings,
                              ),
                              SizedBox(width: 12),
                              AnimatedElevatedButton(
                                onPressed: () {},
                                title: "Notifications",
                                icon: Icons.notifications,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.wb_sunny,
                                color: Colors.yellow,
                                size: 40,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Clear',
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context).isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rawalpindi, Pakistan',
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context).isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '22°C',
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context).isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '09 Dec, 2023',
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context).isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Stats"),
                  SizedBox(
                    height: 350,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        GenerationStats(
                          generatedkWh: 100, 
                          panelCount: 5, 
                          panelSize: 585, 
                          batteryCapacity: 48,
                          inverterCapacity: 6000, 
                          exportingToGrid: 500,
                        ),
                        SizedBox(width: 10,),
                        UsageStats(
                          currentConsumption: 23, 
                          batteryPercentage: 85, 
                          batteryCapacity: 48, 
                          inverterOutput: 300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text("System Rating"),
            SystemStats(),
            const SizedBox(height: 30),
            TransactionHistory(),
            //show solar system info if its a prosumer
            SizedBox(
              height: 200,
            )
          ],
        ),
      )
    );
  }
}
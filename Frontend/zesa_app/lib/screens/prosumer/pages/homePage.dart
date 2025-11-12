import 'package:WattTrade/components/customeElevatedButton.dart';
import 'package:WattTrade/components/prosumerConsumption.dart';
import 'package:WattTrade/components/prosumerGeneration.dart';
import 'package:WattTrade/components/prosumerHistory.dart';
import 'package:WattTrade/components/prosumerSystem.dart';
import 'package:WattTrade/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _location = "Bulawayo, Zimbabwe"; //default location
  double _temperature = 22.0; //default temperature
  String _weatherSummary = "Clear"; //default weather summary

  @override
  void initState(){
    super.initState();
    _getDate();
  }

  Future<void> _getWeatherInfo() async { // im going to use the weeather model later
    try {
      final dio = Dio();
      final response = await dio.get('http://127.0.0.1:8000/weather/info/');

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _location = data['location'] ?? "Bulawayo, Zimbabwe";
          _temperature = (data['temperature'] as num).toDouble();
        });
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  String _getDate(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM yyyy').format(now);
    return formattedDate;
  }

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
                                    _weatherSummary,
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context).isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _location,
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
                                    _getDate(),
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context).isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
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
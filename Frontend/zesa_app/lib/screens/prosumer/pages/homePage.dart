import 'package:WattTrade/components/prosumerGeneration.dart';
import 'package:WattTrade/components/prosumerHistory.dart';
import 'package:flutter/material.dart';

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
        title: Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 8),
            Column(
              children: [
                Text("Greeting"),
                Text("Greeting with Name",
                  style: TextStyle(
                    fontSize: 10
                  ),),
              ],
            ),
          ],
        ),
        actions: [
          IconButton.filled(
            onPressed: (){}, 
            icon: Icon(Icons.settings),
            color: Colors.white70,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 2)
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/prosumer/dayLightGen2.jpg',
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
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.attach_money),
                                  label: Text("Price"),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.trending_up),
                                  label: Text("Earnings"),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.account_circle),
                                  label: Text("Account"),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.settings),
                                  label: Text("Settings"),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.notifications),
                                  label: Text("Notifications"),
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
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Clear',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Rawalpindi, Pakistan',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '22°C',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '09 Dec, 2023',
                                      style: TextStyle(
                                        color: Colors.white70,
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
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Stats"),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        GenerationStats(
                          generatedkWh: 100, 
                          panelCount: 5, 
                          panelSize: 585, 
                          batteryCapacity: 48, 
                          batterySOC: 80, 
                          inverterCapacity: 6000
                        ),
                        SizedBox(width: 10,),
                        GenerationStats(
                          generatedkWh: 200, 
                          panelCount: 5, 
                          panelSize: 585, 
                          batteryCapacity: 48, 
                          batterySOC: 80, 
                          inverterCapacity: 6000
                        ),
                        SizedBox(width: 10,),
                        GenerationStats(
                          generatedkWh: 500, 
                          panelCount: 5, 
                          panelSize: 585, 
                          batteryCapacity: 48, 
                          batterySOC: 80, 
                          inverterCapacity: 6000
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
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
      body: Column(
        children: [
          SizedBox(
            height: 50, 
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: TransactionHistory()
          )
        ],
      )
    );
  }
}
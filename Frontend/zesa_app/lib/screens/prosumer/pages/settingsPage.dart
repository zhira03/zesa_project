import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                // Text("Greeting with Name",
                //   style: TextStyle(
                //     fontSize: 10
                //   ),
                // ),
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
      body: Center(
        child: Text('Welcome to the Settings Page!'),
      ),
    );
  }
}
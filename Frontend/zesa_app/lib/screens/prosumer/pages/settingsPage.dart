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
      body: CustomScrollView(
        slivers: [
          // --- AppBar that disappears on scroll ---
          SliverAppBar(
            expandedHeight: 200,
            pinned: true, // stays visible in collapsed state
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Generation Stats'),
              background: Image.asset(
                'assets/prosumer/dayLightGen.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- Scrollable content below ---
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Setting Option ${index + 1}'),
                subtitle: const Text('Tap to configure'),
                leading: const Icon(Icons.tune),
              ),
              childCount: 30, // enough items to test scrolling
            ),
          ),
        ],
      ),
    );
  }
}

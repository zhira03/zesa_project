import 'package:WattTrade/screens/prosumer/pages/homePage.dart';
import 'package:WattTrade/screens/prosumer/pages/settingsPage.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  final List <Widget> _pages = [
    HomePage(),
    SettingsPage()
  ];

  void navigationBarIndex(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: navigationBarIndex,
                  selectedItemColor: Colors.green,
                  unselectedItemColor: Colors.grey, 
                  backgroundColor: Colors.transparent, 
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
                    BottomNavigationBarItem(icon: Icon(Icons.account_box), label: "Account"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:WattTrade/components/themes.dart';
import 'package:WattTrade/screens/prosumer/pages/accountPage.dart';
import 'package:WattTrade/screens/prosumer/pages/homePage.dart';
import 'package:WattTrade/screens/prosumer/pages/home2.dart';
import 'package:WattTrade/screens/prosumer/pages/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  final List <Widget> _pages = [
    HomePage(),
    SettingsPage(),
    AccountPage(),
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
              margin: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black,
                //     blurRadius: 10,
                //     offset: const Offset(0, 5),
                //   ),
                // ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: navigationBarIndex,
                  selectedItemColor: Colors.lightBlue,
                  unselectedItemColor: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.black
                    : Colors.white60, 
                  backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.white60
                    : Colors.black,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: "Report"),
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
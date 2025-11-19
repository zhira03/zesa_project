import 'package:WattTrade/components/actionTile.dart';
import 'package:WattTrade/components/animatedAppBar.dart';
import 'package:WattTrade/components/animatedLogout.dart';
import 'package:WattTrade/components/modeSlider.dart';
import 'package:WattTrade/components/themes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  bool? _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AnimatedThemedAppBar(
        title:"Profile"
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
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
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('assets/sunShare.jpg'),
                      ),
                      const SizedBox(height: 10),
                      Text("Takudzwa Zhira"),
                      Text("user_email@email.com"),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: (){}, 
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10))
                          ))
                        ),
                        child: Text("Prosumer"),
                      ),
                      Text("Joined in Feb 2025")
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Settings",
                      style: GoogleFonts.zenDots(
                        fontSize: 24,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 15),
                    QuickActionTile(
                      icon: FluentIcons.person_info_20_regular,
                      text: "Personal Details",
                      routePath: '/',
                    ),
                    const SizedBox(height: 10),
                    QuickActionTile(
                      icon: FluentIcons.weather_sunny_32_filled,
                      text: "Solar System Info",
                      routePath: '/',
                    ),
                    const SizedBox(height: 10),
                    QuickActionTile(
                      icon: Icons.messenger,
                      text: "Messages",
                      routePath: '/',
                    ),
                    const SizedBox(height: 10),
                    QuickActionTile(
                      icon: Icons.notifications,
                      text: "Notifications",
                      routePath: '/',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Appearance",
                        style: GoogleFonts.zenDots(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ThemeModeSlider(isDarkMode: _isDarkMode!),
                      const SizedBox(height: 20),
                      Text("Location Info",
                        style: GoogleFonts.zenDots(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      QuickActionTile(
                        icon: FluentIcons.map_16_filled, 
                        text: "Update Location", 
                        routePath: '/'
                      ),
                      const SizedBox(height: 20),
                      Text("App Info",
                        style: GoogleFonts.zenDots(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      QuickActionTile(
                        icon: FluentIcons.info_shield_20_filled, 
                        text: "About Us", 
                        routePath: ""
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.25, vertical: 10),
                        child: ThemedLogoutButton(
                          onLogout: (){
                            
                          },
                        )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
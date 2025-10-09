import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WattTrade/components/animations.dart';
import 'package:WattTrade/components/themes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( 
      builder: (context, themeProvider, child){
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: SplashScreen(),
        );
      }
    );
  }
}

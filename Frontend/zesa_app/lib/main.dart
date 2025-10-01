import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zesa_app/components/themes.dart';
import 'package:zesa_app/login/login.dart';
import 'package:zesa_app/login/login2.dart';
import 'package:zesa_app/login/login3.dart';

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
          home: LoginScreen(),
        );
      }
    );
  }
}

//author : Afiq Hanif (S62993)

import 'package:flutter/material.dart';
import 'package:touristhelper_app/screens/home_screen.dart';
import 'package:touristhelper_app/screens/welcome_screen.dart';
import 'package:touristhelper_app/widgets/person.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tourist Helper App',
      home: WelcomeScreen(),
      theme: ThemeData(
        useMaterial3: false
      ),
    );
  }
}

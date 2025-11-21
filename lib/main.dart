import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const CityWeatherApp());
}

class CityWeatherApp extends StatelessWidget {
  const CityWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}

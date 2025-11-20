import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const CityWeatherApp());
}

class CityWeatherApp extends StatelessWidget {
  const CityWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CityWeather",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

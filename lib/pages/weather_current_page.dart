import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';
import 'search_page.dart';

class WeatherCurrentPage extends StatefulWidget {
  const WeatherCurrentPage({super.key});

  @override
  State<WeatherCurrentPage> createState() => _WeatherCurrentPageState();
}

class _WeatherCurrentPageState extends State<WeatherCurrentPage> {
  Weather? weather;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      // 📍 Obtenir la position GPS
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 🌤 Obtenir la météo
      Weather? w =
          await WeatherService.getWeather(pos.latitude, pos.longitude);

      setState(() {
        weather = w;
      });
    } catch (e) {
      setState(() => error = "Erreur : $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // 🔹 Carte stylée inspirée iOS
  Widget cardItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌁 IMAGE D’ARRIÈRE-PLAN
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/weather_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔵 FILTRE BLEUTÉ
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : error != null
                      ? Center(
                          child: Text(
                            error!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),

                            // 📍 Position
                            const Text(
                              "Ma position",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 🌡 Température principale
                            Text(
                              "${weather!.temperature2m.toStringAsFixed(1)}°",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Vent ${weather!.windSpeed10m} km/h",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),

                            const SizedBox(height: 40),

                            // 🧊 Cartes météo
                            Column(
                              children: [
                                cardItem(
                                  icon: Icons.air,
                                  label: "Vent",
                                  value:
                                      "${weather!.windSpeed10m} ${weather!.windSpeedUnit}",
                                ),
                                const SizedBox(height: 16),
                                cardItem(
                                  icon: Icons.water_drop,
                                  label: "Humidité",
                                  value: "58%", // valeur fixe
                                ),
                                const SizedBox(height: 16),
                                cardItem(
                                  icon: Icons.device_thermostat,
                                  label: "Ressenti",
                                  value:
                                      "${weather!.temperature2m.toStringAsFixed(1)}°C",
                                ),
                              ],
                            ),

                            const Spacer(),

                            // 🔍 Bouton recherche
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.7),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SearchPage()),
                                );
                              },
                              child: const Text(
                                "Rechercher une ville",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

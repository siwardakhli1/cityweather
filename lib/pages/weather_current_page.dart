import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  Weather? weather;
  String? error;
  bool loading = false;

  // ================== PERMISSION GPS ==================
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifier si le GPS est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        error = "Veuillez activer votre GPS.";
      });
      return false;
    }

    // Vérifier permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        setState(() {
          error = "Permission GPS refusée.";
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        error = "Permission GPS refusée définitivement.\n"
                "Allez dans les paramètres de votre téléphone.";
      });
      return false;
    }

    return true;
  }

  // ================== RÉCUPÉRER LA MÉTÉO ==================
  Future<void> getGPSWeather() async {
    setState(() {
      loading = true;
      error = null;
    });

    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      setState(() => loading = false);
      return;
    }

    try {
      // Position GPS
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Appel API
      final result = await WeatherService.getCurrentWeather(
        pos.latitude,
        pos.longitude,
      );

      if (result == null) {
        setState(() {
          error = "Impossible de récupérer la météo.";
        });
      } else {
        setState(() {
          weather = result;
        });
      }
    } catch (e) {
      setState(() {
        error = "Erreur : $e";
      });
    }

    setState(() => loading = false);
  }

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Météo actuelle"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // BOUTON
            Center(
              child: ElevatedButton(
                onPressed: getGPSWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 30),
                ),
                child: const Text("Obtenir ma météo"),
              ),
            ),

            const SizedBox(height: 30),

            // LOADING
            if (loading)
              const CircularProgressIndicator(),

            // ERREUR
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),

            // METEO
            if (weather != null && !loading)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "${weather!.temperature2m}${weather!.temperatureUnit}",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Vent : ${weather!.windSpeed10m} ${weather!.windSpeedUnit}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Heure de mesure : ${weather!.time}",
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

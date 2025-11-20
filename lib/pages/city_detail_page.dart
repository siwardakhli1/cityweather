import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class CityDetailPage extends StatefulWidget {
  final City city;

  const CityDetailPage({super.key, required this.city});

  @override
  State<CityDetailPage> createState() => _CityDetailPageState();
}

class _CityDetailPageState extends State<CityDetailPage> {
  late Future<Weather?> futureWeather;

  @override
  void initState() {
    super.initState();

    // Charger la météo de la ville
    futureWeather = WeatherService.getCityWeather(
      widget.city.latitude,
      widget.city.longitude,
    );
  }

  // --------- WIDGET INFO ----------
  Widget buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.blue)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }

  // --------- OUVRIR GOOGLE MAPS ----------
  Future<void> openMaps() async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${widget.city.latitude},${widget.city.longitude}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Impossible d'ouvrir Google Maps."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final city = widget.city;

    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------ TITRE ------
            Text(
              city.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ------ INFOS GÉNÉRALES ------
            buildInfo("Pays", city.country),
            buildInfo("Code pays", city.countryCode),
            buildInfo("Latitude", city.latitude.toString()),
            buildInfo("Longitude", city.longitude.toString()),
            buildInfo("Altitude", city.elevation?.toString() ?? "Non renseignée"),
            buildInfo("Fuseau horaire", city.timezone),
            buildInfo("Population", city.population?.toString() ?? "Non renseignée"),
            buildInfo("Type de lieu", city.featureCode ?? "Non renseigné"),

            // ------ ADMINISTRATIONS ------
            if (city.admin1Name != null)
              buildInfo("Région", city.admin1Name!),
            if (city.admin2Name != null)
              buildInfo("Département / État", city.admin2Name!),
            if (city.admin3Name != null)
              buildInfo("Ville / Commune", city.admin3Name!),
            if (city.admin4Name != null)
              buildInfo("District / Zone", city.admin4Name!),

            // ------ CODES POSTAUX ------
            if (city.postcodes != null && city.postcodes!.isNotEmpty)
              buildInfo("Codes postaux", city.postcodes!.join(", ")),

            const SizedBox(height: 25),

            // =========================================================
            //                    🟦 MÉTÉO DE LA VILLE
            // =========================================================
            const Text(
              "Météo actuelle",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            FutureBuilder<Weather?>(
              future: futureWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text(
                    "Météo indisponible",
                    style: TextStyle(color: Colors.red),
                  );
                }

                final weather = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Température : ${weather.temperature2m}${weather.temperatureUnit}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Vent : ${weather.windSpeed10m} ${weather.windSpeedUnit}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Mesuré à : ${weather.time}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // =========================================================
            //                    🗺️ BOUTON GOOGLE MAPS
            // =========================================================
            ElevatedButton.icon(
              onPressed: openMaps,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              icon: const Icon(Icons.map),
              label: const Text("Voir dans Google Maps"),
            ),
          ],
        ),
      ),
    );
  }
}

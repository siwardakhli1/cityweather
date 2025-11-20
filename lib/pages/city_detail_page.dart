import 'package:flutter/material.dart';
import '../models/city.dart';

class CityDetailPage extends StatelessWidget {
  final City city;

  const CityDetailPage({super.key, required this.city});

  Widget buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            Text(
              city.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Informations détaillées
            buildInfo("Pays", city.country),
            buildInfo("Code pays", city.countryCode),
            buildInfo("Latitude", city.latitude.toString()),
            buildInfo("Longitude", city.longitude.toString()),
            buildInfo("Altitude", city.elevation?.toString() ?? "Non renseignée"),
            buildInfo("Fuseau horaire", city.timezone),
            buildInfo("Population", city.population?.toString() ?? "Non renseignée"),
            buildInfo("Type de lieu", city.featureCode ?? "Non renseigné"),

            // Administrations (AVEC LES NOUVEAUX NOMS)
            if (city.admin1Name != null)
              buildInfo("Région", city.admin1Name!),
            if (city.admin2Name != null)
              buildInfo("Département / État", city.admin2Name!),
            if (city.admin3Name != null)
              buildInfo("Ville / Commune", city.admin3Name!),
            if (city.admin4Name != null)
              buildInfo("District / Zone", city.admin4Name!),

            // Postcodes
            if (city.postcodes != null && city.postcodes!.isNotEmpty)
              buildInfo("Codes postaux", city.postcodes!.join(", ")),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/city.dart';
import '../services/api_service.dart';
import 'city_detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";
  Future<List<City>>? futureCities;

  void runSearch(String value) async {
    query = value.trim();
    print("⌨️ Saisi : $query");

    if (query.isEmpty) {
      setState(() {
        futureCities = null;
      });
      return;
    }

    print("🔍 Lancement auto search...");
    final results = await ApiService.searchCity(query);
    print("📦 Résultats : ${results.length}");

    setState(() {
      futureCities = Future.value(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recherche de ville"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: runSearch,
              decoration: const InputDecoration(
                labelText: "Nom de la ville",
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: futureCities == null
                  ? const Center(child: Text("Recherchez une ville"))
                  : FutureBuilder<List<City>>(
                      future: futureCities,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(child: Text("Erreur API"));
                        }

                        final cities = snapshot.data ?? [];

                        if (cities.isEmpty) {
                          return const Center(child: Text("Aucune ville trouvée"));
                        }

                        return ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                            final city = cities[index];
                            return ListTile(
                              title: Text(city.name),
                              subtitle: Text(
                                  "lat: ${city.latitude}, lon: ${city.longitude}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CityDetailPage(city: city),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

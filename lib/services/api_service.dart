import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class ApiService {
  static Future<List<City>> searchCity(String name) async {
    final url = Uri.parse(
      "https://geocoding-api.open-meteo.com/v1/search?name=$name&count=5&language=fr",
    );

    final response = await http.get(url);

    print('🔁 Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('❌ Non-200 response body: ${response.body}');
      throw Exception("Erreur API: ${response.statusCode}");
    }

    Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body);
    } catch (e) {
      print('❌ JSON parse error: $e');
      print('❌ Response body (truncated): ${response.body.substring(0, response.body.length > 1000 ? 1000 : response.body.length)}');
      rethrow;
    }

    print('📄 JSON keys: ${json.keys.toList()}');

    if (!json.containsKey("results")) {
      print('🔎 No "results" key in JSON');
      return [];
    }

    List results = json["results"];

    print('🔎 Found ${results.length} results');

    return results.map((item) => City.fromJson(item)).toList();
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {

  // -------------------------------------------------------------
  // 🔵 MÉTÉO D'UNE COORDONNÉE (lat/lon)
  // Récupère la météo actuelle (température + vent)
  // -------------------------------------------------------------
  static Future<Weather?> getWeather(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?"
      "latitude=$lat&longitude=$lon&"
      "current=temperature_2m,wind_speed_10m",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return Weather.fromJson(json);
  }

  // -------------------------------------------------------------
  // 🟦 MÉTÉO DE LA POSITION GPS / ACTUELLE
  // Utilisé dans CurrentWeatherPage
  // -------------------------------------------------------------
  static Future<Weather?> getCurrentWeather(double lat, double lon) {
    return getWeather(lat, lon);
  }

  // -------------------------------------------------------------
  // 🟩 MÉTÉO DE LA VILLE RECHERCHÉE
  // Utilisé dans CityDetailPage
  // -------------------------------------------------------------
  static Future<Weather?> getCityWeather(double lat, double lon) {
    return getWeather(lat, lon);
  }
}

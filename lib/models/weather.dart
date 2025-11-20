class Weather {
  // Informations générales de localisation
  final double latitude;
  final double longitude;
  final double elevation;
  final String timezone;
  final String timezoneAbbreviation;

  // Données METEO ACTUELLES
  final String time;
  final double temperature2m;
  final double windSpeed10m;

  // Unités renvoyées par l’API
  final String temperatureUnit;
  final String windSpeedUnit;

  Weather({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.time,
    required this.temperature2m,
    required this.windSpeed10m,
    required this.temperatureUnit,
    required this.windSpeedUnit,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      elevation: (json["elevation"] ?? 0).toDouble(),
      timezone: json["timezone"] ?? "Inconnu",
      timezoneAbbreviation: json["timezone_abbreviation"] ?? "",

      // METEO ACTUELLE
      time: json["current"]?["time"] ?? "",
      temperature2m:
          (json["current"]?["temperature_2m"] ?? 0).toDouble(),
      windSpeed10m:
          (json["current"]?["wind_speed_10m"] ?? 0).toDouble(),

      // UNITÉS
      temperatureUnit: json["current_units"]?["temperature_2m"] ?? "°C",
      windSpeedUnit: json["current_units"]?["wind_speed_10m"] ?? "km/h",
    );
  }
}

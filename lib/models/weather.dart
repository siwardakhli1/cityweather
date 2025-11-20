class Weather {
  final double temperature;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json["temperature_2m"].toDouble(),
      windSpeed: json["wind_speed_10m"].toDouble(),
    );
  }
}

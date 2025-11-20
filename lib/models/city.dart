class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double? elevation;
  final String? featureCode;
  final String countryCode;
  final int? admin1Id;
  final int? admin2Id;
  final int? admin3Id;
  final int? admin4Id;
  final String timezone;
  final int? population;
  final List<String>? postcodes;
  final String country;
  final String? admin1Name;
  final String? admin2Name;
  final String? admin3Name;
  final String? admin4Name;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    required this.timezone,
    required this.country,
    this.elevation,
    this.featureCode,
    this.admin1Id,
    this.admin2Id,
    this.admin3Id,
    this.admin4Id,
    this.population,
    this.postcodes,
    this.admin1Name,
    this.admin2Name,
    this.admin3Name,
    this.admin4Name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"],
      name: json["name"],
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      elevation: json["elevation"] != null ? json["elevation"].toDouble() : null,
      featureCode: json["feature_code"],
      countryCode: json["country_code"],
      admin1Id: json["admin1_id"],
      admin2Id: json["admin2_id"],
      admin3Id: json["admin3_id"],
      admin4Id: json["admin4_id"],
      timezone: json["timezone"],
      population: json["population"],
      postcodes: json["postcodes"] != null
          ? List<String>.from(json["postcodes"])
          : null,
      country: json["country"],
      
      /// ❗ IMPORTANT : renomme les noms admin pour éviter les conflits
      admin1Name: json["admin1"],
      admin2Name: json["admin2"],
      admin3Name: json["admin3"],
      admin4Name: json["admin4"],
    );
  }
}

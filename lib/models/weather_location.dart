class WeatherLocation {
  const WeatherLocation({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.administrativeArea,
  });

  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String? administrativeArea;

  String get displayName => [
    name,
    if (administrativeArea?.isNotEmpty ?? false) administrativeArea!,
    country,
  ].where((part) => part.isNotEmpty).join(', ');

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      name: json['name'] as String? ?? 'Unknown location',
      country: json['country'] as String? ?? '',
      administrativeArea: json['admin1'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

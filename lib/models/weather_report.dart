import 'weather_location.dart';

class WeatherReport {
  const WeatherReport({
    required this.location,
    required this.current,
    required this.forecast,
  });

  final WeatherLocation location;
  final CurrentWeather current;
  final List<DailyForecast> forecast;

  factory WeatherReport.fromJson({
    required WeatherLocation location,
    required Map<String, dynamic> json,
  }) {
    return WeatherReport(
      location: location,
      current: CurrentWeather.fromJson(
        json['current'] as Map<String, dynamic>? ?? const {},
      ),
      forecast: DailyForecast.listFromJson(
        json['daily'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class CurrentWeather {
  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
  });

  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final bool isDay;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: _asDouble(json['temperature_2m']),
      feelsLike: _asDouble(json['apparent_temperature']),
      humidity: _asInt(json['relative_humidity_2m']),
      windSpeed: _asDouble(json['wind_speed_10m']),
      precipitation: _asDouble(json['precipitation']),
      weatherCode: _asInt(json['weather_code']),
      isDay: _asInt(json['is_day'], fallback: 1) == 1,
    );
  }
}

class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.precipitationChance,
    required this.weatherCode,
  });

  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final int precipitationChance;
  final int weatherCode;

  static List<DailyForecast> listFromJson(Map<String, dynamic> json) {
    final dates = _asList(json['time']);
    final maximums = _asList(json['temperature_2m_max']);
    final minimums = _asList(json['temperature_2m_min']);
    final rainChances = _asList(json['precipitation_probability_max']);
    final codes = _asList(json['weather_code']);
    final lengths = [
      dates.length,
      maximums.length,
      minimums.length,
      rainChances.length,
      codes.length,
    ];
    final length = lengths.reduce((a, b) => a < b ? a : b);

    return List.generate(
      length,
      (index) => DailyForecast(
        date: DateTime.parse(dates[index].toString()),
        maxTemperature: _asDouble(maximums[index]),
        minTemperature: _asDouble(minimums[index]),
        precipitationChance: _asInt(rainChances[index]),
        weatherCode: _asInt(codes[index]),
      ),
      growable: false,
    );
  }
}

List<dynamic> _asList(dynamic value) =>
    value is List<dynamic> ? value : const <dynamic>[];

double _asDouble(dynamic value, {double fallback = 0}) =>
    value is num ? value.toDouble() : fallback;

int _asInt(dynamic value, {int fallback = 0}) =>
    value is num ? value.toInt() : fallback;

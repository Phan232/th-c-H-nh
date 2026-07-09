import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_location.dart';
import '../models/weather_report.dart';

abstract interface class WeatherRepository {
  Future<WeatherReport> fetchWeatherForCity(String city);
}

class WeatherService implements WeatherRepository {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _timeout = Duration(seconds: 15);

  @override
  Future<WeatherReport> fetchWeatherForCity(String city) async {
    final query = city.trim();
    if (query.length < 2) {
      throw const WeatherException('Please enter at least 2 characters.');
    }

    final location = await _findLocation(query);
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'precipitation,weather_code,wind_speed_10m,is_day',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '5',
    });

    final json = await _getJson(uri);
    return WeatherReport.fromJson(location: location, json: json);
  }

  Future<WeatherLocation> _findLocation(String query) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
      'count': '1',
      'language': 'en',
      'format': 'json',
    });
    final json = await _getJson(uri);
    final results = json['results'];
    if (results is! List || results.isEmpty) {
      throw WeatherException('No city found for "$query". Try another name.');
    }
    return WeatherLocation.fromJson(results.first as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw WeatherException(
          'Weather service returned error ${response.statusCode}.',
        );
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const WeatherException('Unexpected weather response.');
      }
      if (decoded['error'] == true) {
        throw WeatherException(
          decoded['reason'] as String? ?? 'The request was rejected.',
        );
      }
      return decoded;
    } on WeatherException {
      rethrow;
    } on FormatException {
      throw const WeatherException('Weather data could not be read.');
    } catch (_) {
      throw const WeatherException(
        'Could not connect. Check your internet and try again.',
      );
    }
  }
}

class WeatherException implements Exception {
  const WeatherException(this.message);

  final String message;

  @override
  String toString() => message;
}

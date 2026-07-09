// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab8b/main.dart';
import 'package:lab8b/models/weather_location.dart';
import 'package:lab8b/models/weather_report.dart';
import 'package:lab8b/services/weather_service.dart';

void main() {
  testWidgets('displays weather returned by the repository', (tester) async {
    await tester.pumpWidget(const MyApp(weatherRepository: _FakeRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Weather Companion'), findsOneWidget);
    expect(find.text('Ho Chi Minh City, Vietnam'), findsOneWidget);
    expect(find.text('32°'), findsOneWidget);
    expect(find.text('5-day outlook'), findsOneWidget);
    expect(find.text('Your day, decoded'), findsOneWidget);
  });

  testWidgets('search passes the city to the repository', (tester) async {
    final repository = _RecordingRepository();
    await tester.pumpWidget(MyApp(weatherRepository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Da Nang');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(repository.queries, ['Ho Chi Minh City', 'Da Nang']);
  });
}

class _FakeRepository implements WeatherRepository {
  const _FakeRepository();

  @override
  Future<WeatherReport> fetchWeatherForCity(String city) async => _report;
}

class _RecordingRepository implements WeatherRepository {
  final queries = <String>[];

  @override
  Future<WeatherReport> fetchWeatherForCity(String city) async {
    queries.add(city);
    return _report;
  }
}

final _report = WeatherReport(
  location: const WeatherLocation(
    name: 'Ho Chi Minh City',
    country: 'Vietnam',
    latitude: 10.82,
    longitude: 106.63,
  ),
  current: const CurrentWeather(
    temperature: 32,
    feelsLike: 36,
    humidity: 72,
    windSpeed: 12,
    precipitation: 0,
    weatherCode: 1,
    isDay: true,
  ),
  forecast: [
    DailyForecast(
      date: DateTime.now(),
      maxTemperature: 34,
      minTemperature: 27,
      precipitationChance: 30,
      weatherCode: 2,
    ),
  ],
);

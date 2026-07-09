import 'package:flutter/material.dart';

import '../models/weather_report.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.repository});

  final WeatherRepository repository;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _controller = TextEditingController(text: 'Ho Chi Minh City');
  late Future<WeatherReport> _future;
  String _city = 'Ho Chi Minh City';

  @override
  void initState() {
    super.initState();
    _future = widget.repository.fetchWeatherForCity(_city);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final city = _controller.text.trim();
    if (city.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least 2 characters.')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _city = city;
      _future = widget.repository.fetchWeatherForCity(city);
    });
  }

  void _retry() {
    setState(() => _future = widget.repository.fetchWeatherForCity(_city));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1F3A), Color(0xFF124B68), Color(0xFF0B6E75)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(controller: _controller, onSearch: _search),
              Expanded(
                child: FutureBuilder<WeatherReport>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const _LoadingView();
                    }
                    if (snapshot.hasError) {
                      return _ErrorView(
                        message: snapshot.error.toString(),
                        onRetry: _retry,
                      );
                    }
                    final report = snapshot.data;
                    if (report == null) {
                      return _ErrorView(
                        message: 'No weather data was returned.',
                        onRetry: _retry,
                      );
                    }
                    return _WeatherContent(report: report);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller, required this.onSearch});

  final TextEditingController controller;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_sunny_rounded, color: Color(0xFFFFD166), size: 30),
              SizedBox(width: 10),
              Text(
                'Weather Companion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Plan your day with a little less guesswork.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            onSubmitted: (_) => onSearch(),
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: Color(0xFF102A43)),
            decoration: InputDecoration(
              hintText: 'Search a city',
              prefixIcon: const Icon(Icons.location_on_outlined),
              suffixIcon: IconButton(
                tooltip: 'Search',
                onPressed: onSearch,
                icon: const Icon(Icons.search_rounded),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.report});

  final WeatherReport report;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        _CurrentCard(report: report),
        const SizedBox(height: 16),
        _AdviceCard(current: report.current),
        const SizedBox(height: 22),
        const Text(
          '5-day outlook',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        if (report.forecast.isEmpty)
          const _EmptyForecast()
        else
          ...report.forecast.map(
            (day) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _ForecastTile(day: day),
            ),
          ),
        const SizedBox(height: 6),
        Text(
          'Weather data by Open-Meteo',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _CurrentCard extends StatelessWidget {
  const _CurrentCard({required this.report});

  final WeatherReport report;

  @override
  Widget build(BuildContext context) {
    final current = report.current;
    final condition = WeatherPresentation.fromCode(current.weatherCode);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.location.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(condition.icon, color: condition.color, size: 70),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${current.temperature.round()}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 58,
                      height: 0.95,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    condition.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _Metric(
                icon: Icons.thermostat_rounded,
                label: 'Feels like',
                value: '${current.feelsLike.round()}°',
              ),
              _Metric(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: '${current.humidity}%',
              ),
              _Metric(
                icon: Icons.air_rounded,
                label: 'Wind',
                value: '${current.windSpeed.round()} km/h',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB8F2E6), size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  const _AdviceCard({required this.current});

  final CurrentWeather current;

  @override
  Widget build(BuildContext context) {
    final advice = DayAdvice.forWeather(current);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: advice.color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.65),
            foregroundColor: const Color(0xFF17324D),
            child: Icon(advice.icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your day, decoded',
                  style: TextStyle(
                    color: Color(0xFF17324D),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  advice.message,
                  style: const TextStyle(
                    color: Color(0xFF24445F),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastTile extends StatelessWidget {
  const _ForecastTile({required this.day});

  final DailyForecast day;

  @override
  Widget build(BuildContext context) {
    final condition = WeatherPresentation.fromCode(day.weatherCode);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            child: Text(
              _dayLabel(day.date),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(condition.icon, color: condition.color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              condition.label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
            ),
          ),
          const Icon(
            Icons.water_drop_rounded,
            color: Color(0xFF8ECAE6),
            size: 14,
          ),
          Text(
            '${day.precipitationChance}%',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(width: 10),
          Text(
            '${day.maxTemperature.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${day.minTemperature.round()}°',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFFFFD166)),
          SizedBox(height: 16),
          Text('Reading the skies...', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFFFD166),
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Forecast unavailable',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyForecast extends StatelessWidget {
  const _EmptyForecast();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'No daily forecast is available for this location.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}

class WeatherPresentation {
  const WeatherPresentation(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  factory WeatherPresentation.fromCode(int code) {
    if (code == 0) {
      return const WeatherPresentation(
        'Clear sky',
        Icons.wb_sunny_rounded,
        Color(0xFFFFD166),
      );
    }
    if (code <= 3) {
      return const WeatherPresentation(
        'Partly cloudy',
        Icons.cloud_queue_rounded,
        Color(0xFFD8EAF2),
      );
    }
    if (code == 45 || code == 48) {
      return const WeatherPresentation('Foggy', Icons.foggy, Color(0xFFCED4DA));
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return const WeatherPresentation(
        'Rainy',
        Icons.water_drop_rounded,
        Color(0xFF8ECAE6),
      );
    }
    if (code >= 71 && code <= 77) {
      return const WeatherPresentation(
        'Snowy',
        Icons.ac_unit_rounded,
        Color(0xFFEAF8FF),
      );
    }
    if (code >= 95) {
      return const WeatherPresentation(
        'Thunderstorm',
        Icons.thunderstorm_rounded,
        Color(0xFFFFC857),
      );
    }
    return const WeatherPresentation(
      'Cloudy',
      Icons.cloud_rounded,
      Color(0xFFD8EAF2),
    );
  }
}

class DayAdvice {
  const DayAdvice(this.message, this.icon, this.color);

  final String message;
  final IconData icon;
  final Color color;

  factory DayAdvice.forWeather(CurrentWeather weather) {
    final rainyCode =
        (weather.weatherCode >= 51 && weather.weatherCode <= 67) ||
        (weather.weatherCode >= 80 && weather.weatherCode <= 99);
    if (rainyCode || weather.precipitation > 0) {
      return const DayAdvice(
        'Take an umbrella and choose a covered route. The sky may have plans.',
        Icons.umbrella_rounded,
        Color(0xFFBDE0FE),
      );
    }
    if (weather.feelsLike >= 35) {
      return const DayAdvice(
        'It feels very hot. Skip intense exercise, hydrate, and seek shade.',
        Icons.local_drink_rounded,
        Color(0xFFFFD6A5),
      );
    }
    if (weather.windSpeed >= 35) {
      return const DayAdvice(
        'Strong wind outside. Secure loose items and take care on two wheels.',
        Icons.air_rounded,
        Color(0xFFCDEAE5),
      );
    }
    if (weather.feelsLike < 16) {
      return const DayAdvice(
        'A cool day ahead - bring a light jacket before heading out.',
        Icons.checkroom_rounded,
        Color(0xFFDDE7F2),
      );
    }
    return const DayAdvice(
      'No umbrella needed. It looks like a pleasant time for a walk.',
      Icons.directions_walk_rounded,
      Color(0xFFCDECCF),
    );
  }
}

String _dayLabel(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'Today';
  }
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[date.weekday - 1];
}

# Lab 8B - Weather Companion

Weather Companion helps users plan their day. Search for a city to see current
temperature, apparent temperature, humidity, wind, weather condition, a
five-day forecast, and practical advice such as whether to bring an umbrella or
avoid intense outdoor exercise.

## Requirements covered

- Real REST calls to Open-Meteo Geocoding and Forecast APIs
- `http`, `Future`, `async`/`await`, and `FutureBuilder`
- Dedicated model classes and a service layer
- Loading, error, retry, empty, and success states
- City search, forecast cards, and purpose-driven recommendations
- Widget tests for successful display and city search

Open-Meteo requires no API key for this educational project.

## Run

```sh
flutter pub get
flutter run
```

For submission screenshots, capture the loading indicator, the error/retry
screen with the network disabled, and a successful city result.

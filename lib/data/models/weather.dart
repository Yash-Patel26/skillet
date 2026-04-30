class Weather {
  final double tempC;
  final double precipMm;
  final int weatherCode;
  final DateTime fetchedAt;

  const Weather({
    required this.tempC,
    required this.precipMm,
    required this.weatherCode,
    required this.fetchedAt,
  });

  String get description {
    if (weatherCode == 0) return 'Clear sky';
    if (weatherCode <= 3) return 'Partly cloudy';
    if (weatherCode <= 48) return 'Foggy';
    if (weatherCode <= 67) return 'Rainy';
    if (weatherCode <= 77) return 'Snowy';
    if (weatherCode <= 82) return 'Showers';
    if (weatherCode <= 99) return 'Thunderstorm';
    return 'Mixed';
  }
}

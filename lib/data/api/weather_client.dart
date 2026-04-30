import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/weather.dart';

class WeatherClient {
  final Dio _dio;
  WeatherClient([Dio? dio])
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConstants.openMeteoBaseUrl,
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ));

  Future<Weather> currentAt({required double lat, required double lon}) async {
    try {
      final r = await _dio.get('/forecast', queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'current': 'temperature_2m,precipitation,weather_code',
        'timezone': 'auto',
      });
      final cur = (r.data as Map<String, dynamic>)['current'] as Map<String, dynamic>;
      return Weather(
        tempC: (cur['temperature_2m'] as num).toDouble(),
        precipMm: ((cur['precipitation'] ?? 0) as num).toDouble(),
        weatherCode: (cur['weather_code'] as num).toInt(),
        fetchedAt: DateTime.now(),
      );
    } on DioException {
      throw const NetworkFailure('Could not fetch weather.');
    }
  }
}

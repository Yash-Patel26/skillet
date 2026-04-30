import 'package:geolocator/geolocator.dart';

import '../../core/errors/failures.dart';
import '../api/weather_client.dart';
import '../local/prefs_store.dart';
import '../models/weather.dart';

class WeatherRepository {
  final WeatherClient _client;
  final PrefsStore _prefs;
  WeatherRepository(this._client, this._prefs);

  Future<Weather> currentForUser() async {
    try {
      final pos = await _resolvePosition();
      await _prefs.setLastLocation(pos.latitude, pos.longitude);
      return _client.currentAt(lat: pos.latitude, lon: pos.longitude);
    } on PermissionFailure {
      final last = _prefs.lastLocation;
      if (last.lat != null && last.lon != null) {
        return _client.currentAt(lat: last.lat!, lon: last.lon!);
      }
      rethrow;
    }
  }

  Future<Position> _resolvePosition() async {
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) throw const PermissionFailure('Turn on location services.');

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      throw const PermissionFailure('Location permission denied.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }
}

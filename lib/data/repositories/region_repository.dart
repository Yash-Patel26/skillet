import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/region_helper.dart';
import '../local/prefs_store.dart';

class RegionInfo {
  final String? country;
  final String? isoCode;
  final String? mealDbArea;
  final double? lat;
  final double? lon;
  const RegionInfo({
    this.country,
    this.isoCode,
    this.mealDbArea,
    this.lat,
    this.lon,
  });
}

class RegionRepository {
  final PrefsStore _prefs;
  RegionRepository(this._prefs);

  Future<RegionInfo> currentRegion() async {
    final pos = await _resolvePosition();
    await _prefs.setLastLocation(pos.latitude, pos.longitude);

    try {
      final placemarks = await gc.placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isEmpty) {
        return RegionInfo(lat: pos.latitude, lon: pos.longitude);
      }
      final p = placemarks.first;
      return RegionInfo(
        country: p.country,
        isoCode: p.isoCountryCode,
        mealDbArea: RegionHelper.areaForCountry(p.isoCountryCode),
        lat: pos.latitude,
        lon: pos.longitude,
      );
    } catch (_) {
      return RegionInfo(lat: pos.latitude, lon: pos.longitude);
    }
  }

  Future<Position> _resolvePosition() async {
    try {
      final on = await Geolocator.isLocationServiceEnabled();
      if (!on) throw const PermissionFailure('Turn on location services.');

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
    } on PermissionFailure {
      final last = _prefs.lastLocation;
      if (last.lat != null && last.lon != null) {
        return Position(
          latitude: last.lat!,
          longitude: last.lon!,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
      rethrow;
    }
  }
}

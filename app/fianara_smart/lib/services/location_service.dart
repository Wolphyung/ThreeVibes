import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

class LocationService {
  static const double defaultLatitude = -21.4333;
  static const double defaultLongitude = 47.0858;
  static const String defaultAddress = 'Fianarantsoa, Madagascar';

  Future<bool> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LocationModel?> getCurrentLocation() async {
    try {
      final hasPermission = await _checkPermissions();

      if (hasPermission) {
        // Utiliser la vraie localisation GPS
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final address = await getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );

        return LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        );
      }

      // Fallback à la localisation simulée
      return LocationModel(
        latitude: defaultLatitude,
        longitude: defaultLongitude,
        address: defaultAddress,
      );
    } catch (e) {
      debugPrint('Erreur de localisation: $e');
      return LocationModel(
        latitude: defaultLatitude,
        longitude: defaultLongitude,
        address: defaultAddress,
      );
    }
  }

  Future<LocationModel?> getCurrentLocationModel() async {
    return await getCurrentLocation();
  }

  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        return [
          place.street,
          place.subLocality,
          place.locality,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
    } catch (e) {
      debugPrint('Erreur géocodage: $e');
    }
    return defaultAddress;
  }

  Future<double> calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) async {
    const double earthRadius = 6371000.0;

    double lat1Rad = lat1 * pi / 180.0;
    double lat2Rad = lat2 * pi / 180.0;
    double deltaLat = (lat2 - lat1) * pi / 180.0;
    double deltaLng = (lng2 - lng1) * pi / 180.0;

    double a = sin(deltaLat / 2.0) * sin(deltaLat / 2.0) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLng / 2.0) * sin(deltaLng / 2.0);
    double c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a));

    return earthRadius * c;
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

class LocationService {
  Future<bool> checkPermission() async {
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

  Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Future<LocationModel?> getCurrentLocationModel() async {
    final position = await getCurrentLocation();
    if (position == null) return null;

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
      return '$lat, $lng';
    }
    return '$lat, $lng';
  }

  Future<double> calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) async {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }
}

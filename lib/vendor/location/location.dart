import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeoLocation {
  Future<Map<String, double>> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, proceed with getting location
      return await getLocationCoordinate();
    } else {
      throw Exception('Location permission denied');
    }
  }

  Future<Map<String, double>> getLocationCoordinate() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }
}

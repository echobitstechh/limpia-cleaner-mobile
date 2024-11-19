import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteInfo {
  final String distanceText;
  final String durationText;
  final int distanceValue; // in meters
  final int durationValue; // in seconds
  final LatLng startLocation;
  final LatLng endLocation;
  final String polylinePoints;

  RouteInfo({
    required this.distanceText,
    required this.durationText,
    required this.distanceValue,
    required this.durationValue,
    required this.startLocation,
    required this.endLocation,
    required this.polylinePoints,
  });

  @override
  String toString() {
    return 'RouteInfo(distanceText: $distanceText, durationText: $durationText, distanceValue: $distanceValue, durationValue: $durationValue, startLocation: $startLocation, endLocation: $endLocation, polylinePoints: $polylinePoints)';
  }
}

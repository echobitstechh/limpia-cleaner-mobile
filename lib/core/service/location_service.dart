import 'dart:convert';

import 'package:location/location.dart' as locationLib;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/utils/config.dart';
import '../../core/utils/network_util.dart';

class LocationService {
  final locationLib.Location _location = locationLib.Location();
  locationLib.LocationData? _currentLocation;

  Future<locationLib.LocationData?> getCurrentLocation() async {
    bool _serviceEnabled;
    locationLib.PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == locationLib.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != locationLib.PermissionStatus.granted) {
        return null;
      }
    }

    _currentLocation = await _location.getLocation();
    return _currentLocation;
  }

  CameraPosition initialCameraPosition() {
    if (_currentLocation != null) {
      return CameraPosition(
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 16.0,
      );
    } else {
      // Default to a preset location if current location is not available
      return CameraPosition(target: LatLng(34.0469, -118.2437), zoom: 14.0);
    }
  }

  Future<String?> getAddress(double latitude, double longitude) async {
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${AppConfig
        .mapsApiKey}';
    final response = await NetworkUtil.fetchUrl(Uri.parse(url));
    if (response != null) {
      final data = jsonDecode(response);
      if (data['status'] == 'OK') {
        print('object od address ${data['results'][0]}');
        final address = data['results'][0]['formatted_address'];
        print('object address is: $address');
        return address;
        // placeAutoComplete(
        //     address); // Use the fetched address as the default query
        // print('object address is: ${_autocompleteResults.first.mainText}');
      }
    }
    return null;
  }

  Future<String?> getCountryFromLocation(double latitude, double longitude) async {
    String apiKey = AppConfig.mapsApiKey;
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    try {
      final response = await NetworkUtil.fetchUrl(Uri.parse(url));
      if (response != null) {
        var data = jsonDecode(response);
        if (data['results'].isNotEmpty) {
          // Iterate through the address components to find the country
          var addressComponents = data['results'][0]['address_components'];
          for (var component in addressComponents) {
            if (component['types'].contains('country')) {
              return component['long_name'];  // or 'short_name' for the ISO country code
            }
          }
        }
      } else {
        print('Failed to fetch country: ${response}');
      }
    } catch (e) {
      print('Error fetching country: $e');
    }
    return null;
  }
}

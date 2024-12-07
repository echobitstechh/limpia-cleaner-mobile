import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart' as locationLib;

import '../data/models/place_prediction.dart';
import '../data/models/route_info.dart';
import 'config.dart';
import 'network_util.dart';

class MapsUtils {


  Future<RouteInfo?> calculateDistance(
      double pickupLat, double pickupLng, double destLat, double destLng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$pickupLat,$pickupLng&destination=$destLat,$destLng&key=${AppConfig.mapsApiKey}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        // print('response for route is: $data');
        final route = data['routes'][0];
        final leg = route['legs'][0];

        final polyline = route['overview_polyline']['points'];
        final startLocation = LatLng(leg['start_location']['lat'], leg['start_location']['lng']);
        final endLocation = LatLng(leg['end_location']['lat'], leg['end_location']['lng']);

        return RouteInfo(
          distanceText: leg['distance']['text'],
          durationText: leg['duration']['text'],
          distanceValue: leg['distance']['value'], // in meters
          durationValue: leg['duration']['value'], // in seconds
          startLocation: startLocation,
          endLocation: endLocation,
          polylinePoints: polyline,
        );
      } else {
        print('Error fetching directions: ${data['status']}');
      }
    } else {
      print('Failed to fetch directions: ${response.statusCode}');
    }
    return null;
  }


  final _geocoding = GoogleMapsGeocoding(apiKey: AppConfig.mapsApiKey);

  Future<String?> getCountryFromLatLng(double latitude, double longitude) async {
    try {
      final response = await _geocoding.searchByLocation(Location(lat: latitude, lng: longitude));
      if (response.status == "OK" && response.results.isNotEmpty) {
        for (var result in response.results) {
          for (var component in result.addressComponents) {
            if (component.types.contains('country')) {
              return component.longName;
            }
          }
        }
      } else {
        print('Error in reverse geocoding: ${response.errorMessage}');
      }
    } catch (e) {
      print('Exception during reverse geocoding: $e');
    }
    return null;
  }

  Future<PlacePrediction?> getPlaceDetails(PlacePrediction prediction) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&fields=geometry,address_components&key=${AppConfig.mapsApiKey}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final result = data['result'];
        final geometry = result['geometry'];
        final addressComponents = result['address_components'];

        // Initialize variables to hold address components
        String? streetNumber;
        String? route;
        String? city;
        String? state;
        String? country;
        String? postalCode;

        // Parse address components
        for (var component in addressComponents) {
          final types = component['types'] as List<dynamic>;
          if (types.contains('street_number')) {
            streetNumber = component['long_name'];
          } else if (types.contains('route')) {
            route = component['long_name'];
          } else if (types.contains('locality')) {
            city = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['short_name'];
          } else if (types.contains('country')) {
            country = component['long_name'];
          } else if (types.contains('postal_code')) {
            postalCode = component['long_name'];
          }
        }

        // Combine street number and route to form the street address
        final street = [streetNumber, route].where((e) => e != null).join(' ');

        return PlacePrediction(
          description: prediction.description,
          placeId: prediction.placeId,
          mainText: prediction.mainText,
          secondaryText: prediction.secondaryText,
          latitude: geometry['location']['lat'],
          longitude: geometry['location']['lng'],
          streetNumber: streetNumber,
          route: route,
          city: city,
          state: state,
          country: country,
          postalCode: postalCode,
        );
      }
    }
    return null;
  }

  Future<dynamic> getAddressFromLatLng(double latitude, double longitude) async {
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
      }
    }
  }

  Future<PlacePrediction?> getCurrentLocationAsPlacePrediction(locationLib.LocationData currentLocation) async {
    try {

      var places = GoogleMapsPlaces(apiKey: AppConfig.mapsApiKey);

      var response = await places.searchNearbyWithRadius(
        Location(
          lat: currentLocation.latitude!,
          lng: currentLocation.longitude!,
        ),
        500,
      );

      if (response.status == "OK" && response.results.isNotEmpty) {
        var result = response.results.first;
        return PlacePrediction(
          description: result.name,
          placeId: result.placeId,
          mainText: result.name,
          secondaryText: result.vicinity!,
          latitude: result.geometry?.location.lat as num,
          longitude: result.geometry?.location.lng as num,
        );
      }
    } catch (e) {
      print("Failed to get current location as place prediction: $e");
    }
    return null;
  }

  Future<List<PlacePrediction>?> placeAutoComplete(String query, locationLib.LocationData? locationData) async {

    String location = '${locationData?.latitude},${locationData?.longitude}';
    const int radius = 50000;

    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input": query,
        "key": AppConfig.mapsApiKey,
        "location": location,
        "radius": radius.toString(),
      },
    );
    String? response = await NetworkUtil.fetchUrl(uri);
    if (response != null) {
      var data = jsonDecode(response);
      if (data['status'] == 'OK') {
        List<dynamic> results = data['predictions'];
        print('>>>>>>>>>>>>>>>>>>>>>>> result of prediction is: ${results.map((result) => PlacePrediction.fromJson(result)).toList()}');
          return results.map((result) => PlacePrediction.fromJson(result)).toList();
      } else {
        print('Error fetching places: ${data['status']}');
      }
    }else{
      print('>>>>>>>>>>>>>> network call failed');
    }
    return null;
  }


  List<LatLng> convertToLatLng(String polylineString) {
    List<LatLng> points = [];
    List<int> codes = polylineString.codeUnits;
    int index = 0;
    int len = polylineString.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = codes[index++] - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = codes[index++] - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

}


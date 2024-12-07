class PlacePrediction {
  final String description;
  final String placeId;
  final String mainText;
  final String secondaryText;
  final num longitude;
  final num latitude;

  // Address components
  final String? streetNumber;
  final String? route;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  PlacePrediction({
    required this.description,
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.latitude,
    required this.longitude,
    this.streetNumber,
    this.route,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    // Check for structured formatting
    final structuredFormatting = json['structured_formatting'] as Map<String, dynamic>?;

    // Safe extraction of fields
    final String mainText = structuredFormatting?['main_text'] ?? '';
    final String secondaryText = structuredFormatting?['secondary_text'] ?? '';

    // Check if the 'geometry' object is present in the JSON
    final Map<String, dynamic>? geometry = json['geometry'];

    // Check if the 'location' object is present in the 'geometry' object
    final Map<String, dynamic>? location = geometry?['location'];

    // Log the location object and its data
    print('Location object: $json');

    // Extract the latitude and longitude if they are present
    final double? latitude = location?['lat'];
    final double? longitude = location?['lng'];

    // Initialize variables to hold address components
    String? streetNumber;
    String? route;
    String? city;
    String? state;
    String? country;
    String? postalCode;

    // Parse address components
    if (json.containsKey('address_components')) {
      final addressComponents = json['address_components'] as List<dynamic>;
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
    }

    return PlacePrediction(
      placeId: json['place_id'] ?? '', // Provide a default empty string if null
      description: json['description'] ?? '', // Provide a default empty string if null
      mainText: mainText,
      secondaryText: secondaryText,
      latitude: latitude ?? 0, // Use a default value if latitude is null
      longitude: longitude ?? 0, // Use a default value if longitude is null
      streetNumber: streetNumber,
      route: route,
      city: city,
      state: state,
      country: country,
      postalCode: postalCode,
    );
  }
}

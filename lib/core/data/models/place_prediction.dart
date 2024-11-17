class PlacePrediction {
  final String description;
  final String placeId;
  final String mainText;
  final String secondaryText;
  final num longitude;
  final num latitude;

  PlacePrediction({
    required this.description,
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.latitude,
    required this.longitude,
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
    print('Location object: ${json}');

    // Extract the latitude and longitude if they are present
    final double? latitude = location?['lat'];
    final double? longitude = location?['lng'];

    return PlacePrediction(
      placeId: json['place_id'] ?? '', // Provide a default empty string if null
      description: json['description'] ?? '', // Provide a default empty string if null
      mainText: mainText,
      secondaryText: secondaryText,
      latitude: latitude ?? 0, // Use a default value if latitude is null
      longitude: longitude ?? 0, // Use a default value if longitude is null
    );
  }
}

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class OpenStreetMapService {
  // Replace with your actual Google Maps API key
  static const String _apiKey = 'AIzaSyB3FCl-qAq4R2m93nZ2uUmQfsZmMTsAHlA';

  Future<LatLng?> searchPlace(String placeName) async {
    if (placeName.isEmpty) {
      return null;
    }

    // URL encode the place name, especially important for Arabic characters
    final encodedPlaceName = Uri.encodeComponent('$placeName, Yemen');

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?'
      'address=$encodedPlaceName&key=$_apiKey&language=ar&region=ye',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(
            location['lat'],
            location['lng'],
          );
        } else {
          print('Google Maps API error: ${data['status']}');
          return null;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error searching place: $e');
      return null;
    }
  }
}

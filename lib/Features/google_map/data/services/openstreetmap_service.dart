import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class OpenStreetMapService {
  Future<LatLng?> searchPlace(String placeName) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?'
      'q=$placeName&format=json&polygon=1&addressdetails=1',
    );

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'YourAppName/1.0 (your@email.com)',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return LatLng(
            double.parse(data[0]['lat']),
            double.parse(data[0]['lon']),
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

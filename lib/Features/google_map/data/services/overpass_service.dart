import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/hotel.dart';
import '../models/place.dart';

class OverpassService {
  Future<List<Hotel>> getNearbyHotels(LatLng location, double radiusKm) async {
    try {
      final radius = (radiusKm * 1000).toInt();
      final query = '''
        [out:json];
        (
          node["tourism"="hotel"](around:$radius,${location.latitude},${location.longitude});
          way["tourism"="hotel"](around:$radius,${location.latitude},${location.longitude});
          relation["tourism"="hotel"](around:$radius,${location.latitude},${location.longitude});
          node["tourism"="guest_house"](around:$radius,${location.latitude},${location.longitude});
          node["tourism"="hostel"](around:$radius,${location.latitude},${location.longitude});
          node["amenity"="hotel"](around:$radius,${location.latitude},${location.longitude});
        );
        out body;
        >;
        out skel qt;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        headers: {'Content-Type': 'text/plain'},
        body: query,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return _parseArabicHotels(data, location);
      }
      throw Exception('API request failed with status ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load hotels: $e');
    }
  }

  List<Hotel> _parseArabicHotels(Map<String, dynamic> data, LatLng center) {
    final elements = data['elements'] as List;

    return elements.where((element) {
      final tags = element['tags'] as Map<String, dynamic>? ?? {};
      return _hasValidLocation(element) && _hasName(tags);
    }).map((element) {
      final tags = element['tags'] as Map<String, dynamic>;
      final latLng = _extractLatLng(element, center);

      return Hotel.fromPlace(Place(
        id: element['id'].toString(),
        name: _getBestArabicName(tags),
        address: _buildArabicAddress(tags),
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      ));
    }).toList();
  }

  String _getBestArabicName(Map<String, dynamic> tags) {
    // Priority order: Arabic name > default name > any other name
    return tags['name:ar'] ??
        tags['name'] ??
        tags['name:en'] ??
        tags['alt_name'] ??
        'فندق';
  }

  String _buildArabicAddress(Map<String, dynamic> tags) {
    final street = tags['addr:street:ar'] ?? tags['addr:street'] ?? '';
    final city = tags['addr:city:ar'] ?? tags['addr:city'] ?? '';
    final country = tags['addr:country:ar'] ?? tags['addr:country'] ?? '';

    return [street, city, country].where((part) => part.isNotEmpty).join('، ');
  }

  bool _hasValidLocation(dynamic element) {
    return (element['lat'] != null && element['lon'] != null) ||
        (element['center'] != null);
  }

  bool _hasName(Map<String, dynamic> tags) {
    return tags.containsKey('name') || tags.containsKey('name:ar');
  }

  LatLng _extractLatLng(dynamic element, LatLng fallback) {
    if (element['lat'] != null && element['lon'] != null) {
      return LatLng(element['lat'], element['lon']);
    }
    if (element['center'] != null) {
      return LatLng(element['center']['lat'], element['center']['lon']);
    }
    return fallback;
  }
}

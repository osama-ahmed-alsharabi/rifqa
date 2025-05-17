import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/hotel.dart';
import '../models/place.dart';

class PlacesService {
  static const String _placesApiKey = 'AIzaSyB3FCl-qAq4R2m93nZ2uUmQfsZmMTsAHlA';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  Future<Place?> searchPlaceByName(String placeName) async {
    try {
      final encodedName = Uri.encodeComponent(placeName);
      final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?'
          'address=$encodedName&'
          'key=$_placesApiKey');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          return Place(
            id: 'geo_${result['place_id']}',
            name: result['formatted_address'],
            address: result['formatted_address'],
            latitude: result['geometry']['location']['lat'],
            longitude: result['geometry']['location']['lng'],
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Geocoding error: $e');
      return null;
    }
  }

  Future<LatLng?> searchPlace(String placeName) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?'
      'query=$placeName&'
      'key=$_placesApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
    return null;
  }

  Future<List<Hotel>> getNearbyHotels(LatLng location) async {
    try {
      final overpassQuery = '''
        [out:json];
        (
          node["tourism"="hotel"](around:1500,${location.latitude},${location.longitude});
          way["tourism"="hotel"](around:1500,${location.latitude},${location.longitude});
          relation["tourism"="hotel"](around:1500,${location.latitude},${location.longitude});
          node["tourism"="guest_house"](around:1500,${location.latitude},${location.longitude});
          node["tourism"="hostel"](around:1500,${location.latitude},${location.longitude});
          node["amenity"="hotel"](around:1500,${location.latitude},${location.longitude});
        );
        out body;
        >;
        out skel qt;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        headers: {'Content-Type': 'text/plain'},
        body: overpassQuery,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final elements = data['elements'] as List;

        return elements.where((element) {
          return element['tags'] != null &&
              (element['tags']['name'] != null ||
                  element['tags']['name:ar'] != null) &&
              (element['lat'] != null) &&
              (element['lon'] != null);
        }).map((element) {
          final tags = element['tags'];
          return Hotel.fromPlace(Place(
            id: element['id'].toString(),
            name: _getBestName(tags),
            address: _buildArabicAddress(tags),
            latitude: element['lat'],
            longitude: element['lon'],
          ));
        }).toList();
      } else {
        throw Exception('Failed to load nearby hotels: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load nearby hotels: $e');
    }
  }

  String _getBestName(Map<String, dynamic> tags) {
    return tags['name:ar'] ?? tags['name'] ?? 'فندق بدون اسم';
  }

  String _buildArabicAddress(Map<String, dynamic> tags) {
    final arabicParts = [
      tags['addr:street:ar'],
      tags['addr:housenumber'],
      tags['addr:city:ar'],
      tags['addr:country:ar'],
    ].where((part) => part != null).join('، ');

    if (arabicParts.isNotEmpty) return arabicParts;

    final englishParts = [
      tags['addr:street'],
      tags['addr:housenumber'],
      tags['addr:city'],
      tags['addr:country'],
    ].where((part) => part != null).join(', ');

    return englishParts.isNotEmpty ? englishParts : 'العنوان غير متوفر';
  }
}

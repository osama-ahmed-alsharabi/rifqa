import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rifqa/Features/google_map/data/models/hotel.dart';
import 'package:http/http.dart' as http;

class MapsService {
  static const String _directionsApiKey =
      'AIzaSyB3FCl-qAq4R2m93nZ2uUmQfsZmMTsAHlA';

  Future<Polyline> getRoutePolyline(LatLng origin, LatLng destination) async {
    final url =
        Uri.parse('https://maps.googleapis.com/maps/api/directions/json?'
            'origin=${origin.latitude},${origin.longitude}&'
            'destination=${destination.latitude},${destination.longitude}&'
            'key=$_directionsApiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isEmpty) {
        throw Exception('No route found');
      }

      final points = data['routes'][0]['overview_polyline']['points'];
      return Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: _convertToLatLngList(points),
      );
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _convertToLatLngList(String encodedPolyline) {
    final List<LatLng> points = [];
    int index = 0, len = encodedPolyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  Set<Marker> createMarkers({
    required Position? userPosition,
    required LatLng userLatLng,
    required List<Hotel> hotels,
  }) {
    final markers = <Marker>{};

    debugPrint('User location: $userLatLng');

    markers.add(Marker(
      markerId: const MarkerId('user_location'),
      position: userLatLng,
      infoWindow: const InfoWindow(title: 'Your Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));

    for (var hotel in hotels) {
      debugPrint('Adding hotel: ${hotel.name} at ${hotel.location}');
      markers.add(Marker(
        markerId: MarkerId(hotel.id),
        position: hotel.location,
        infoWindow: InfoWindow(
          title: hotel.name,
          snippet: hotel.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }

    return markers;
  }

  Polyline createPolyline({
    required LatLng origin,
    required LatLng destination,
  }) {
    return Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: [origin, destination],
    );
  }
}

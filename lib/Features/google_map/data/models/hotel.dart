import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rifqa/Features/google_map/data/models/place.dart';

class Hotel {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final double? distance;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    this.distance,
  });

  factory Hotel.fromPlace(Place place) {
    return Hotel(
      id: place.id,
      name: place.name,
      address: place.address,
      location: LatLng(place.latitude, place.longitude),
    );
  }
  static double calculateDistance(LatLng p1, LatLng p2) {
    const earthRadius = 6371e3; // meters
    final lat1 = p1.latitude * pi / 180;
    final lat2 = p2.latitude * pi / 180;
    final dLat = (p2.latitude - p1.latitude) * pi / 180;
    final dLon = (p2.longitude - p1.longitude) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}

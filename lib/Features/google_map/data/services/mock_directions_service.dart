import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MockDirectionsService {
  Polyline getRoutePolyline(LatLng origin, LatLng destination) {
    return Polyline(
      polylineId: const PolylineId('mock_route'),
      color: Colors.green,
      width: 5,
      points: [origin, destination],
    );
  }
}

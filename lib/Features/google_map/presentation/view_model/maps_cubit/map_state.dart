import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rifqa/Features/google_map/data/models/hotel.dart';

abstract class HotelState {
  const HotelState();
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final LatLng userLatLng;
  final List<Hotel> hotels;
  final Hotel? selectedHotel;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final bool isLoadingRoute;
  final String? errorMessage;

  HotelLoaded(
      {required this.userLatLng,
      required this.hotels,
      required this.selectedHotel,
      required this.markers,
      required this.polylines,
      required this.isLoadingRoute,
      required this.errorMessage});

  HotelLoaded copyWith({
    LatLng? userLatLng,
    List<Hotel>? hotels,
    Hotel? selectedHotel,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    bool? isLoadingRoute,
    String? errorMessage,
  }) {
    return HotelLoaded(
        errorMessage: errorMessage ?? this.errorMessage,
        hotels: hotels ?? this.hotels,
        isLoadingRoute: isLoadingRoute ?? this.isLoadingRoute,
        markers: markers ?? this.markers,
        polylines: polylines ?? this.polylines,
        selectedHotel: selectedHotel,
        userLatLng: userLatLng ?? this.userLatLng);
  }
}

class HotelError extends HotelState {
  final String message;

  const HotelError(this.message);
}

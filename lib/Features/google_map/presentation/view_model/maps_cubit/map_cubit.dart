import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rifqa/Features/google_map/data/models/hotel.dart';
import 'package:rifqa/Features/google_map/data/services/directions_service.dart';
import 'package:rifqa/Features/google_map/data/services/openstreetmap_service.dart';
import 'package:rifqa/Features/google_map/data/services/overpass_service.dart';
import 'package:rifqa/Features/google_map/data/services/places_service.dart';
import 'package:rifqa/Features/google_map/presentation/view_model/maps_cubit/map_state.dart';
import 'package:rifqa/cores/services/location_helper.dart';

class HotelCubit extends Cubit<HotelState> {
  final LocationService locationService;
  final MapsService mapsService;
  final PlacesService placesService;
  final OverpassService overpassService;
  final OpenStreetMapService openStreetMapService;

  HotelCubit({
    required this.locationService,
    required this.mapsService,
    required this.placesService,
    required this.overpassService,
    required this.openStreetMapService,
  }) : super(HotelInitial());

  Future<void> loadData({String? withPlace}) async {
    if (withPlace != null) {
      await loadPlaceData(withPlace);
    } else {
      await loadInitialData();
    }
  }

  Future<void> loadArabicHotels(LatLng location) async {
    emit(HotelLoading());

    try {
      final hotels = await overpassService.getNearbyHotels(location, 1.5);

      final enhancedHotels = hotels.map((h) {
        return Hotel(
          id: h.id,
          name: h.name,
          address: h.address,
          location: h.location,
          distance: _calculateDistance(location, h.location),
        );
      }).toList()
        ..sort((a, b) => a.distance!.compareTo(b.distance!));

      if (enhancedHotels.isEmpty) {
        throw Exception('لا توجد فنادق قريبة');
      }

      emit(HotelLoaded(
        userLatLng: location,
        hotels: enhancedHotels,
        selectedHotel: null,
        markers: _createArabicMarkers(location, enhancedHotels),
        polylines: {},
        isLoadingRoute: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(HotelError('فشل تحميل الفنادق: ${e.toString()}'));
    }
  }

  Set<Marker> _createArabicMarkers(LatLng center, List<Hotel> hotels) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('search_center'),
        position: center,
        infoWindow: const InfoWindow(title: 'موقع البحث'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };

    markers.addAll(hotels.map((hotel) => Marker(
          markerId: MarkerId('hotel_${hotel.id}'),
          position: hotel.location,
          infoWindow: InfoWindow(
            title: hotel.name,
            snippet: _buildMarkerSnippet(hotel),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        )));

    return markers;
  }

  String _buildMarkerSnippet(Hotel hotel) {
    final parts = [hotel.address];
    if (hotel.distance != null) {
      parts.add('المسافة: ${(hotel.distance! / 1000).toStringAsFixed(1)} كم');
    }
    return parts.join('\n');
  }

  Future<void> loadInitialData() async {
    try {
      emit(HotelLoading());

      final position =
          await locationService.getCurrentLocation().catchError((e) {
        throw Exception('Failed to get current location: $e');
      });

      final userLocation = LatLng(position.latitude, position.longitude);

      final hotels =
          await placesService.getNearbyHotels(userLocation).catchError((e) {
        throw Exception('Failed to fetch nearby hotels: $e');
      });

      if (hotels.isEmpty) {
        throw Exception('No hotels found in your area');
      }

      final markers = _createMarkers(userLocation, hotels);
      if (markers.isEmpty) {
        throw Exception('Failed to create map markers');
      }

      emit(HotelLoaded(
        userLatLng: userLocation,
        hotels: hotels,
        selectedHotel: null,
        markers: markers,
        polylines: {},
        isLoadingRoute: false,
        errorMessage: null,
      ));
    } catch (e) {
      debugPrint('Error in loadInitialData: $e');
      emit(HotelError(
          e is String ? e : 'Failed to load nearby hotels. Please try again.'));
    }
  }

  Set<Marker> _createMarkers(LatLng userLocation, List<Hotel> hotels) {
    try {
      final markers = <Marker>{
        Marker(
          markerId: const MarkerId('user_location'),
          position: userLocation,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };

      markers.addAll(hotels.map((hotel) {
        return Marker(
          markerId: MarkerId('hotel_${hotel.id}'),
          position: hotel.location,
          infoWindow: InfoWindow(
            title: hotel.name ?? 'Hotel',
            snippet: hotel.address ?? 'No address available',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      }));

      return markers;
    } catch (e) {
      debugPrint('Error creating markers: $e');
      return {};
    }
  }

  Future<void> loadPlaceData(String placeName) async {
    try {
      emit(HotelLoading());
      final placeLocation = await openStreetMapService.searchPlace(placeName);
      if (placeLocation == null) throw Exception('Place not found');

      final hotels = await overpassService.getNearbyHotels(placeLocation, 1.0);
      if (hotels.isEmpty) throw Exception('No hotels found nearby');

      final enhancedHotels = _enhanceHotelsWithDistance(placeLocation, hotels);
      final markers = _createMarkers2(placeLocation, enhancedHotels);

      emit(HotelLoaded(
        userLatLng: placeLocation,
        hotels: enhancedHotels,
        selectedHotel: null,
        markers: markers,
        polylines: {},
        isLoadingRoute: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }

  List<Hotel> _enhanceHotelsWithDistance(LatLng center, List<Hotel> hotels) {
    return hotels
        .map((h) => Hotel(
              id: h.id,
              name: h.name,
              address: h.address,
              location: h.location,
              distance: _calculateDistance(center, h.location),
            ))
        .toList()
      ..sort((a, b) => a.distance!.compareTo(b.distance!));
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    return Geolocator.distanceBetween(
      p1.latitude,
      p1.longitude,
      p2.latitude,
      p2.longitude,
    );
  }

  Set<Marker> _createMarkers2(LatLng center, List<Hotel> hotels) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('center'),
        position: center,
        infoWindow: const InfoWindow(title: 'موقع البحث'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };

    markers.addAll(hotels.map((hotel) => Marker(
          markerId: MarkerId('hotel_${hotel.id}'),
          position: hotel.location,
          infoWindow: InfoWindow(
            title: hotel.name,
            snippet: hotel.address.isNotEmpty
                ? '${hotel.address}\nبعد: ${(hotel.distance! / 1000).toStringAsFixed(1)} كم'
                : 'بعد: ${(hotel.distance! / 1000).toStringAsFixed(1)} كم',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        )));

    return markers;
  }

  void selectHotel(Hotel hotel) async {
    if (state is! HotelLoaded) return;
    final currentState = state as HotelLoaded;

    try {
      emit(currentState.copyWith(isLoadingRoute: true));
      final polyline = await mapsService.getRoutePolyline(
        currentState.userLatLng,
        hotel.location,
      );

      emit(currentState.copyWith(
        selectedHotel: hotel,
        polylines: {polyline},
        isLoadingRoute: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        errorMessage: 'Failed to show route: ${e.toString()}',
        isLoadingRoute: false,
      ));
    }
  }

  void clearSelection() {
    if (state is! HotelLoaded) return;
    emit((state as HotelLoaded).copyWith(
      selectedHotel: null,
      polylines: {},
    ));
  }
}

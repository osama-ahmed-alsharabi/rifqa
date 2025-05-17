import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rifqa/Features/google_map/data/models/hotel.dart';

class LocalHotelData {
  static List<Hotel> getNearbyHotels(LatLng location) {
    return [
      Hotel(
        id: '1',
        name: 'فندق المدينة',
        address: 'شارع الملك فهد، الرياض',
        location: LatLng(location.latitude + 0.01, location.longitude + 0.01),
      ),
      Hotel(
        id: '2',
        name: 'فندق الرياض',
        address: 'حي العليا، الرياض',
        location: LatLng(location.latitude - 0.01, location.longitude + 0.02),
      ),
      Hotel(
        id: '3',
        name: 'فندق النخيل',
        address: 'حي السفارات، الرياض',
        location: LatLng(location.latitude + 0.02, location.longitude - 0.01),
      ),
    ];
  }
}

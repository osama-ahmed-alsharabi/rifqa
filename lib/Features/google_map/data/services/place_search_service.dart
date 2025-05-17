import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rifqa/Features/google_map/data/models/place.dart';

class PlaceSearchService {
  static const String _placesApiKey = 'AIzaSyB3FCl-qAq4R2m93nZ2uUmQfsZmMTsAHlA';

  Future<Place?> searchPlaceByName(String placeName) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?'
        'input=$placeName&'
        'inputtype=textquery&'
        'fields=formatted_address,name,geometry&'
        'key=$_placesApiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final place = data['candidates'][0];
        return Place(
          id: 'searched_place_${placeName.hashCode}',
          name: place['name'],
          address: place['formatted_address'],
          latitude: place['geometry']['location']['lat'],
          longitude: place['geometry']['location']['lng'],
        );
      }
    }
    return null;
  }
}

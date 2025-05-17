import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/google_map/data/services/directions_service.dart';
import 'package:rifqa/Features/google_map/data/services/openstreetmap_service.dart';
import 'package:rifqa/Features/google_map/data/services/overpass_service.dart';
import 'package:rifqa/Features/google_map/data/services/places_service.dart';
import 'package:rifqa/Features/google_map/presentation/view_model/maps_cubit/map_cubit.dart';
import 'package:rifqa/Features/google_map/presentation/views/hotel_map_screen.dart';
import 'package:rifqa/cores/services/location_helper.dart';

class MapHomeView extends StatelessWidget {
  final String? withPlace;
  const MapHomeView({super.key, this.withPlace});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => LocationService()),
        RepositoryProvider(create: (context) => MapsService()),
        RepositoryProvider(create: (context) => PlacesService()),
        RepositoryProvider(create: (context) => OpenStreetMapService()),
        RepositoryProvider(create: (context) => OverpassService()),
      ],
      child: BlocProvider(
        create: (context) => HotelCubit(
          locationService: context.read<LocationService>(),
          mapsService: context.read<MapsService>(),
          openStreetMapService: context.read<OpenStreetMapService>(),
          overpassService: context.read<OverpassService>(),
          placesService: context.read<PlacesService>(),
        )..loadData(withPlace: withPlace),
        child: Builder(builder: (context) {
          return HotelMapScreen(
            withPlace: withPlace,
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rifqa/Features/google_map/presentation/view_model/maps_cubit/map_cubit.dart';
import 'package:rifqa/Features/google_map/presentation/view_model/maps_cubit/map_state.dart';
import 'package:rifqa/Features/google_map/presentation/views/map_screen.dart';
import 'widgets/hotel_bottom_sheet.dart';

class HotelMapScreen extends StatefulWidget {
  final String? withPlace;
  const HotelMapScreen({super.key, this.withPlace});

  @override
  State<HotelMapScreen> createState() => _HotelMapScreenState();
}

class _HotelMapScreenState extends State<HotelMapScreen> {
  GoogleMapController? _mapController;
  @override
  void initState() {
    super.initState();
    if (widget.withPlace != null) {
      context.read<HotelCubit>().loadPlaceData(widget.withPlace!);
    } else {
      context.read<HotelCubit>().loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HotelCubit, HotelState>(
        builder: (context, state) {
          if (state is HotelLoading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text('جاري البحث عن الفنادق القريبة...'),
                ],
              ),
            );
          }

          if (state is HotelError) {
            return Center(child: Text(state.message));
          }

          if (state is HotelLoaded) {
            final viewModel = HotelViewModel(context);
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: state.userLatLng,
                    zoom: 14,
                  ),
                  markers: state.markers,
                  polylines: state.polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (state.markers.isNotEmpty) {
                      _fitMarkersToView(state.markers);
                    }
                  },
                ),
                if (widget.withPlace != null)
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 5),
                          ],
                        ),
                        child: Text(
                          'الفنادق القريبة من ${widget.withPlace}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state.isLoadingRoute)
                  const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 40,
                  left: 20,
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.menu),
                  ),
                ),
                HotelBottomSheet(viewModel: viewModel),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _fitMarkersToView(Set<Marker> markers) {
    if (_mapController == null || markers.isEmpty) return;

    final bounds =
        _boundsFromLatLngList(markers.map((m) => m.position).toList());

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100.0));
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }
}

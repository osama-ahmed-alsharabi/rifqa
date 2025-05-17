import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/google_map/data/models/hotel.dart';
import 'package:rifqa/Features/google_map/presentation/view_model/maps_cubit/map_cubit.dart';
import 'package:rifqa/Features/google_map/presentation/view_model/maps_cubit/map_state.dart';
import 'package:rifqa/Features/reservation/presentation/views/reservation_page.dart';

class HotelViewModel {
  final BuildContext context;

  HotelViewModel(this.context);

  List<Hotel> get hotels {
    final state = context.read<HotelCubit>().state;
    if (state is HotelLoaded) {
      return state.hotels;
    }
    return [];
  }

  Hotel? get selectedHotel {
    final state = context.read<HotelCubit>().state;
    if (state is HotelLoaded) {
      return state.selectedHotel;
    }
    return null;
  }

  void selectHotel(Hotel hotel) {
    log("Done Osaama");
    context.read<HotelCubit>().selectHotel(hotel);
  }

  void clearSelection() {
    context.read<HotelCubit>().clearSelection();
  }

  void navigateToReservationScreen() {
    if (selectedHotel == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReservationScreen(hotel: selectedHotel!),
      ),
    );
  }
}

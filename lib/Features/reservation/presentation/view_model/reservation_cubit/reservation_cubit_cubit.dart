import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/reservation/data/models/reservation_model.dart';
import 'package:rifqa/Features/reservation/data/repo/reservation_repository.dart';
import 'package:rifqa/Features/reservation/presentation/view_model/reservation_cubit/reservation_cubit_state.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final ReservationRepo reservationRepo;

  ReservationCubit(this.reservationRepo) : super(ReservationInitial());

  Future<void> createReservation({
    required String hotelId,
    required String hotelName,
    required String hotelAddress,
    required String reservationType,
    required int numberOfClients,
    required int durationDays,
  }) async {
    emit(ReservationLoading());
    try {
      final userId = await SharedPreferencesService.getUserId();
      if (userId == null) {
        emit(ReservationError('User not logged in'));
        return;
      }

      final reservation = ReservationModel(
        id: '',
        userId: userId,
        hotelId: hotelId,
        hotelName: hotelName,
        hotelAddress: hotelAddress,
        reservationType: reservationType,
        numberOfClients: numberOfClients,
        durationDays: durationDays,
        reservationDate: DateTime.now(),
      );

      await reservationRepo.createReservation(reservation);
      emit(ReservationSuccess());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  Future<void> addRatingAndComment(
      String reservationId, int rating, String comment) async {
    emit(ReservationLoading());
    try {
      await reservationRepo.addRatingAndComment(reservationId, rating, comment);
      emit(ReservationStatusUpdated());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  Future<void> getUserReservations() async {
    emit(ReservationsLoading());
    try {
      final userId = await SharedPreferencesService.getUserId();
      if (userId == null) {
        emit(ReservationsError('User not logged in'));
        return;
      }

      final reservations = await reservationRepo.getUserReservations(userId);
      emit(ReservationsLoaded(reservations));
    } catch (e) {
      emit(ReservationsError(e.toString()));
    }
  }

  Future<void> getAllReservations() async {
    emit(ReservationsLoading());
    try {
      final reservations = await reservationRepo.getAllReservations();
      emit(ReservationsLoaded(reservations));
    } catch (e) {
      log(e.toString());
      emit(ReservationsError(e.toString()));
    }
  }

  Future<void> updateReservationStatus(String id, String status) async {
    emit(ReservationLoading());
    try {
      await reservationRepo.updateReservationStatus(id, status);
      emit(ReservationStatusUpdated());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }
}

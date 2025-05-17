import 'package:rifqa/Features/reservation/data/models/reservation_model.dart';

abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {}

class ReservationStatusUpdated extends ReservationState {}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
}

class ReservationsLoading extends ReservationState {}

class ReservationsLoaded extends ReservationState {
  final List<ReservationModel> reservations;
  ReservationsLoaded(this.reservations);
}

class ReservationsError extends ReservationState {
  final String message;
  ReservationsError(this.message);
}

import 'package:rifqa/Features/reservation/data/models/reservation_model.dart';

abstract class ReservationRepo {
  Future<void> createReservation(ReservationModel reservation);
  Future<List<ReservationModel>> getUserReservations(String userId);
  Future<List<ReservationModel>> getAllReservations();
  Future<void> updateReservationStatus(String id, String status);
  Future<void> addRatingAndComment(
      String reservationId, int rating, String comment);
}

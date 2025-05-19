import 'package:rifqa/Features/reservation/data/models/reservation_model.dart';
import 'package:rifqa/Features/reservation/data/repo/reservation_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservationRepoImpl implements ReservationRepo {
  final SupabaseClient supabaseClient;

  ReservationRepoImpl(this.supabaseClient);

  @override
  Future<void> createReservation(ReservationModel reservation) async {
    await supabaseClient.from('reservations').insert({
      'user_id': reservation.userId,
      'hotel_id': reservation.hotelId,
      'hotel_name': reservation.hotelName,
      'hotel_address': reservation.hotelAddress,
      'reservation_type': reservation.reservationType,
      'number_of_clients': reservation.numberOfClients,
      'duration_days': reservation.durationDays,
      'status': reservation.status,
    });
  }

  @override
  Future<List<ReservationModel>> getUserReservations(String userId) async {
    final response = await supabaseClient
        .from('reservations')
        .select()
        .eq('user_id', userId)
        .order('reservation_date', ascending: false);

    return (response as List)
        .map((json) => ReservationModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<ReservationModel>> getAllReservations() async {
    final reservationsResponse = await supabaseClient
        .from('reservations')
        .select()
        .order('reservation_date', ascending: false);

    final reservations = <ReservationModel>[];

    for (final json in reservationsResponse as List) {
      final userResponse = await supabaseClient
          .from('users')
          .select('name, phone_number , nationality , secondary_phone_number')
          .eq('id', json['user_id'])
          .single();

      reservations.add(ReservationModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        hotelId: json['hotel_id'] as String,
        hotelName: json['hotel_name'] as String,
        hotelAddress: json['hotel_address'] as String,
        reservationType: json['reservation_type'] as String,
        numberOfClients: json['number_of_clients'] as int,
        durationDays: json['duration_days'] as int,
        reservationDate: DateTime.parse(json['reservation_date'] as String),
        status: json['status'] as String? ?? 'pending',
        userName: userResponse['name'] as String?,
        userPhone: userResponse['phone_number'] as String?,
        userNationality: userResponse["nationality"] as String?,
        userSecondPhone: userResponse['secondary_phone_number'] as String?,
      ));
    }

    return reservations;
  }

  @override
  Future<void> updateReservationStatus(String id, String status) async {
    await supabaseClient
        .from('reservations')
        .update({'status': status}).eq('id', id);
  }

  @override
  Future<void> addRatingAndComment(
      String reservationId, int rating, String comment) async {
    await supabaseClient.from('reservations').update({
      'rating': rating,
      'comment': comment,
    }).eq('id', reservationId);
  }
}

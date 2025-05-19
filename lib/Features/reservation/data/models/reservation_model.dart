class ReservationModel {
  final String id;
  final String userId;
  final String hotelId;
  final String hotelName;
  final String hotelAddress;
  final String reservationType;
  final int numberOfClients;
  final int durationDays;
  final DateTime reservationDate;
  final String status;
  final String? userName;
  final String? userPhone;
  final String? userSecondPhone;
  final String? userNationality;
  final int? rating;
  final String? comment;

  ReservationModel({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.hotelAddress,
    required this.reservationType,
    required this.numberOfClients,
    required this.durationDays,
    required this.reservationDate,
    this.status = 'pending',
    this.userName,
    this.userPhone,
    this.userSecondPhone,
    this.userNationality,
    this.rating,
    this.comment,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
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
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
    );
  }

  factory ReservationModel.fromJsonWithUserData(Map<String, dynamic> json) {
    final userData = json['users'] as Map<String, dynamic>?;
    return ReservationModel(
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
      userName: userData?['name'] as String?,
      userPhone: userData?['phone_number'] as String?,
      userSecondPhone: userData?["seconday_phone_number"] as String?,
      userNationality: userData?["nationality"] as String?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hotel_id': hotelId,
      'hotel_name': hotelName,
      'hotel_address': hotelAddress,
      'reservation_type': reservationType,
      'number_of_clients': numberOfClients,
      'duration_days': durationDays,
      'reservation_date': reservationDate.toIso8601String(),
      'status': status,
      if (userName != null) 'user_name': userName,
      if (userPhone != null) 'user_phone': userPhone,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
    };
  }
}

class Booking {
  String? bookingId;
  int? guestId;
  int? guesthouseId;
  int? roomId;
  DateTime? checkIn;
  DateTime? checkOut;
  int? roomsCount;
  int? guestsCount;
  double? amount;
  String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  DateTime? bookingDate;
  DateTime? createdAt;

  Booking({
    this.bookingId,
    this.guestId,
    this.guesthouseId,
    this.roomId,
    this.checkIn,
    this.checkOut,
    this.roomsCount,
    this.guestsCount,
    this.amount,
    this.status = 'pending',
    this.bookingDate,
    this.createdAt,
  });

  // FROM JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'] as String?,
      guestId: json['guest_id'] as int?,
      guesthouseId: json['guesthouse_id'] as int?,
      roomId: json['room_id'] as int?,
      checkIn: json['check_in'] != null
          ? DateTime.parse(json['check_in'] as String)
          : null,
      checkOut: json['check_out'] != null
          ? DateTime.parse(json['check_out'] as String)
          : null,
      roomsCount: json['rooms_count'] as int?,
      guestsCount: json['guests_count'] as int?,
      amount: (json['amount'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'pending',
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'guest_id': guestId,
      'guesthouse_id': guesthouseId,
      'room_id': roomId,
      'check_in': checkIn?.toIso8601String().split('T')[0],
      'check_out': checkOut?.toIso8601String().split('T')[0],
      'rooms_count': roomsCount,
      'guests_count': guestsCount,
      'amount': amount,
      'status': status,
      'booking_date': bookingDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

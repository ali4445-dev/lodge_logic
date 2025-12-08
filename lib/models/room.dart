class Room {
  int? roomId;
  int? guesthouseId;
  String? roomNumber;
  int? floor;
  int? capacity;
  double? price;
  String? description;
  List<String>? amenities;
  bool? isAvailable;
  String status; // 'available', 'occupied', 'maintenance'
  DateTime? createdAt;

  Room({
    this.roomId,
    this.guesthouseId,
    this.roomNumber,
    this.floor,
    this.capacity,
    this.price,
    this.description,
    this.amenities,
    this.isAvailable = true,
    this.status = 'available',
    this.createdAt,
  });

  // FROM JSON
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['room_id'] as int?,
      guesthouseId: json['guesthouse_id'] as int?,
      roomNumber: json['room_number'] as String?,
      floor: json['floor'] as int?,
      capacity: json['capacity'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>(),
      isAvailable: json['is_available'] as bool? ?? true,
      status: json['status'] as String? ?? 'available',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'guesthouse': guesthouseId,
      'room_number': roomNumber,
      'floor': floor,
      'capacity': capacity,
      'price': price,
      'description': description,
      'amenities': amenities,
      'is_available': isAvailable ?? true,
      'status': status,
    };
  }
}

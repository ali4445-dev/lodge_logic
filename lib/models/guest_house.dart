class GuestHouse {
  String? ghId;
  String? ownerId;
  String name;
  int rooms;
  String? createdAt;
  bool? hasKitchen;
  bool? hasBalcony;
  bool? hasWifi;
  bool? hasParking;

  GuestHouse({
    this.ghId,
    this.ownerId,
    required this.name,
    required this.rooms,
    this.createdAt,
    this.hasKitchen,
    this.hasBalcony,
    this.hasWifi,
    this.hasParking,
  });

  // Convert JSON (from Supabase) to GuestHouse object
  factory GuestHouse.fromJson(Map<String, dynamic> json) {
    return GuestHouse(
      ghId: json['gh_id'] as String,
      ownerId: json['owner_id'] as String?,
      name: json['name'] as String,
      rooms: json['rooms'] as int,
      createdAt: json['created_at'] ,
      hasKitchen: json['has_kitchen'] as bool?,
      hasBalcony: json['has_balcony'] as bool?,
      hasWifi: json['has_wifi'] as bool?,
      hasParking: json['has_parking'] as bool?,
    );
  }

  // Convert GuestHouse object to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'name': name,
      'rooms': rooms,

      'has_kitchen': hasKitchen,
      'has_balcony': hasBalcony,
      'has_wifi': hasWifi,
      'has_parking': hasParking,
    };
  }
}

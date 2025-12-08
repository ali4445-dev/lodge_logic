class GuestHouse {
  int? guesthouseId;
  int? ownerId;
  String name;
  String? address;
  String city;
  String country;
  int totalRooms;
  String? description;
  List<String>? amenities;
  List<String>? images;
  bool? isActive;
  DateTime? createdAt;

  GuestHouse({
    this.guesthouseId,
    this.ownerId,
    required this.name,
    this.address,
    required this.city,
    required this.country,
    required this.totalRooms,
    this.description,
    this.amenities,
    this.images,
    this.isActive = true,
    this.createdAt,
  });

  // Convert JSON (from Supabase) to GuestHouse object
  factory GuestHouse.fromJson(Map<String, dynamic> json) {
    return GuestHouse(
      guesthouseId: json['guesthouse_id'] as int?,
      ownerId: json['owner_id'] as int?,
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      totalRooms: json['total_rooms'] as int? ?? 0,
      description: json['description'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>(),
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // Convert GuestHouse object to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'name': name,
      'address': address,
      'city': city,
      'country': country,
      'total_rooms': totalRooms,
      'description': description,
      'amenities': amenities,
      'images': images,
      'is_active': isActive ?? true,
    };
  }
}


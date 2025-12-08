class Admin {
  int? adminId;
  int? userId;
  int? ownerId;
  String? name;
  String? email;
  DateTime? createdAt;
  bool? isActive;

  Admin({
    this.adminId,
    this.userId,
    this.ownerId,
    this.name,
    this.email,
    this.createdAt,
    this.isActive = true,
  });

  // FROM JSON
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json['admin_id'] as int?,
      userId: json['user_id'] as int?,
      ownerId: json['owner_id'] as int?,
      // name: json['name'] as String?,
      // email: json['email'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      // 'admin_id': adminId,
      'user_id': userId,
      'owner_id': ownerId,
      // 'name': name,
      // 'email': email,
      'created_at': createdAt?.toIso8601String(),
      'is_active': isActive ?? true,
    };
  }
}

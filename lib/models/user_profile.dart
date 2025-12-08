class UserProfile {
  final int? userId;
  final String name;
  final String email;
  final String? phone;
  final String? password;
  final String role; // 'owner', 'customer', 'admin'
  final bool? isApproved;
  final String? profileImage;
  final DateTime? lastLogin;
  final DateTime? dateJoined;
  final DateTime? createdAt;
  final bool? isDeleted;

  UserProfile({
    this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.password,
    required this.role,
    this.isApproved = false,
    this.profileImage,
    this.lastLogin,
    this.dateJoined,
    this.createdAt,
    this.isDeleted = false,
  });

  /// Create a UserProfile from JSON (Map)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String? ?? 'customer',
      isApproved: json['is_approved'] as bool? ?? false,
      profileImage: json['profile_image'] as String?,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      dateJoined: json['date_joined'] != null
          ? DateTime.parse(json['date_joined'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  /// Convert UserProfile to JSON (Map)
  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'is_approved': isApproved,
      'profile_image': profileImage,
      'last_login': lastLogin?.toIso8601String(),
      'date_joined': dateJoined?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'is_deleted': isDeleted,
    };
    // Only include user_id if it's not null (for updates)
    if (userId != null) {
      json['user_id'] = userId;
    }
    return json;
  }
}

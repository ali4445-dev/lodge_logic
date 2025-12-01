class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  /// Create a UserProfile from JSON (Map)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  /// Convert UserProfile to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}

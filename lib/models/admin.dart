class Admin {
  final String adminUid;     // Supabase Auth UID
  final String name;
  final String email;
  final String ghId;         // Guest House ID this admin manages
  final DateTime? createdAt; // Optional: can be null

  Admin({
    required this.adminUid,
    required this.name,
    required this.email,
    required this.ghId,
    this.createdAt,
  });

  // ------------------------------
  // FROM JSON
  // ------------------------------
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminUid: json['admin_uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      ghId: json['gh_id'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // ------------------------------
  // TO JSON
  // ------------------------------
  Map<String, dynamic> toJson() {
    return {
      'admin_uid': adminUid,
      'name': name,
      'email': email,
      'gh_id': ghId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

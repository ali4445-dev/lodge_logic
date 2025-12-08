import 'package:lodge_logic/models/user_profile.dart';
import 'package:lodge_logic/utils/password_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signUpUser({
  required String name,
  required String email,
  required String password,
  required String role,
}) async {
  final supabase = Supabase.instance.client;

  try {
    // 1. Create user in Supabase Auth
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        "role": role,
        "name": name,
      },
    );

    final user = response.user;

    if (user == null) {
      throw Exception("User not created");
    }
    
    // 2. Hash password
    final hashedPassword = PasswordUtils.hashPassword(password);
    
    // 3. Create user profile
    final userProfile = UserProfile(
      name: name,
      email: email,
      role: role,
      password: hashedPassword,
      isApproved: role == "Customer" ? true : false,
    );
    
    // 4. Insert profile in users table
    await supabase.from("users").insert(
      userProfile.toJson()
    );

    print("✅ User registered + Profile created successfully");
  } catch (e) {
    print("❌ Signup error: $e");
    rethrow;
  }
}

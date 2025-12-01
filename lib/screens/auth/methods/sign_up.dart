import 'package:lodge_logic/models/user_profile.dart';
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
        "role": role,   // metadata
        "name": name,
      },
    );

    final user = response.user;

    
    if (user == null) {
      throw Exception("User not created");
    }
   final userProfile = UserProfile(name: name,email: email,role: role,id: user.id);
    // 2. Insert profile in Profiles table
    await supabase.from("profiles").insert(
    userProfile.toJson()
    );

    print("User registered + Profile created successfully");
  } catch (e) {
    print("Signup error: $e");
  }
}

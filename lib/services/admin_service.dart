import 'package:lodge_logic/models/admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  static final supabase = Supabase.instance.client;

  // --------------------------------------------
  // ⭐ CREATE ADMIN (Insert into database)
  // --------------------------------------------
  static Future<bool> createAdmin(Admin admin) async {
    try {
      await supabase.from("guest_house_admins").insert(admin.toJson());
      return true;
    } catch (e) {
      print("❌ Error creating admin: $e");
      return false;
    }
  }

  // --------------------------------------------
  // ⭐ GET ADMINS FOR A SPECIFIC GUEST HOUSE
  // --------------------------------------------
  static Future<List<Admin>> getAdminsByGuestHouse(String ghId) async {
    try {
      final data = await supabase
          .from("guest_house_admins")
          .select()
          .eq("gh_id", ghId);

      return (data as List<dynamic>)
          .map((e) => Admin.fromJson(e))
          .toList();
    } catch (e) {
      print("❌ Error fetching admins: $e");
      return [];
    }
  }

  // --------------------------------------------
  // ⭐ GET ADMIN BY UID (single admin)
  // --------------------------------------------
  static Future<Admin?> getAdminByUid(String adminUid) async {
    try {
      final data = await supabase
          .from("guest_house_admins")
          .select()
          .eq("admin_uid", adminUid)
          .maybeSingle();

      if (data == null) return null;

      return Admin.fromJson(data);
    } catch (e) {
      print("❌ Error fetching admin by uid: $e");
      return null;
    }
  }
}

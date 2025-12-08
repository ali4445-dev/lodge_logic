import 'package:lodge_logic/models/admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  static final supabase = Supabase.instance.client;

  /// Create a new admin user
  static Future<bool> createAdmin(Admin admin) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      
      // Get the user_id from users table using email
      final userResult = await supabase
          .from('users')
          .select('user_id')
          .eq('email', currentUser.email!)
          .maybeSingle();
      
      if (userResult == null) {
        throw Exception('User not found in users table');
      }
      
      admin.userId = userResult['user_id'] as int;
      
      await supabase.from('admin').insert(admin.toJson()).select();
      print('✅ Admin created successfully!');
      return true;
    } catch (e) {
      print('❌ Error creating admin: $e');
      return false;
    }
  }

  /// Get all admins created by the current owner
  static Future<List<Admin>> getOwnerAdmins() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      
      // Get the user_id from users table using email
      final userResult = await supabase
          .from('users')
          .select('user_id')
          .eq('email', currentUser.email!)
          .maybeSingle();
      
      if (userResult == null) {
        throw Exception('User not found in users table');
      }
      
      final ownerId = userResult['user_id'] as int;
      
      final admins = await supabase
          .from('admins')
          .select()
          .eq('owner_id', ownerId)
          .eq('is_active', true);

      return (admins as List<dynamic>)
          .map((e) => Admin.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching owner admins: $e');
      return [];
    }
  }

  /// Get a specific admin by ID
  static Future<Admin?> getAdminById(int adminId) async {
    try {
      final admin = await supabase
          .from('admins')
          .select()
          .eq('admin_id', adminId)
          .maybeSingle();

      if (admin == null) return null;
      return Admin.fromJson(admin);
    } catch (e) {
      print('❌ Error fetching admin: $e');
      return null;
    }
  }

  /// Get admin by user ID
  static Future<Admin?> getAdminByUserId(int userId) async {
    try {
      final admin = await supabase
          .from('admins')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (admin == null) return null;
      return Admin.fromJson(admin);
    } catch (e) {
      print('❌ Error fetching admin by user ID: $e');
      return null;
    }
  }

  /// Get all admins for a specific owner
  static Future<List<Admin>> getAdminsByOwner(int ownerId) async {
    try {
      final admins = await supabase
          .from('admins')
          .select()
          .eq('owner_id', ownerId)
          .eq('is_active', true);

      return (admins as List<dynamic>)
          .map((e) => Admin.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching admins by owner: $e');
      return [];
    }
  }

  /// Update admin information
  static Future<bool> updateAdmin(Admin admin) async {
    try {
      if (admin.adminId == null) {
        throw Exception('Admin ID is required');
      }
      await supabase
          .from('admins')
          .update(admin.toJson())
          .eq('admin_id', admin.adminId!);

      print('✅ Admin updated successfully!');
      return true;
    } catch (e) {
      print('❌ Error updating admin: $e');
      return false;
    }
  }

  /// Deactivate an admin
  static Future<bool> deactivateAdmin(int adminId) async {
    try {
      await supabase
          .from('admins')
          .update({'is_active': false})
          .eq('admin_id', adminId);

      print('✅ Admin deactivated successfully!');
      return true;
    } catch (e) {
      print('❌ Error deactivating admin: $e');
      return false;
    }
  }

  /// Delete an admin
  static Future<bool> deleteAdmin(String adminId) async {
    try {
      await supabase.from('admins').delete().eq('admin_id', adminId);
      print('✅ Admin deleted successfully!');
      return true;
    } catch (e) {
      print('❌ Error deleting admin: $e');
      return false;
    }
  }
}

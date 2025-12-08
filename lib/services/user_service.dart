import 'package:lodge_logic/models/user_profile.dart';
import 'package:lodge_logic/utils/app_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static final SupabaseClient supabase = Supabase.instance.client;
  static Future signOut() async {
    await supabase.auth.signOut();
  }
  /// Create a new user
  static Future<bool> createUser(UserProfile user) async {
    try {
      await supabase.from('users').insert(user.toJson()).select();
      print('✅ User created successfully!');
      return true;
    } catch (e) {
      print('❌ Error creating user: $e');
      return false;
    }
  }

  /// Get user by ID
  static Future<UserProfile?> getUserById(int userId) async {
    try {
      final user = await supabase
          .from('users')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (user == null) return null;
      return UserProfile.fromJson(user);
    } catch (e) {
      print('❌ Error fetching user: $e');
      return null;
    }
  }

  /// Get user by email
  static Future<UserProfile?> getUserByEmail(String email) async {
    try {
      final user = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (user == null) return null;
      return UserProfile.fromJson(user);
    } catch (e) {
      print('❌ Error fetching user by email: $e');
      return null;
    }
  }

  /// Get current user profile
  static Future<UserProfile?> getCurrentUser() async {
    try {
      if (AppState.userEmail == null) return null;
      
      // Get user_id from users table using email
      final userResult = await supabase
          .from('users')
          .select('user_id')
          .eq('email', AppState.userEmail!)
          .maybeSingle();
      
      if (userResult == null) return null;
      final userId = userResult['user_id'] as int;
      
      return await getUserById(userId);
    } catch (e) {
      print('❌ Error fetching current user: $e');
      return null;
    }
  }

  /// Get all users of a specific role
  static Future<List<UserProfile>> getUsersByRole(String role) async {
    try {
      final users = await supabase
          .from('users')
          .select()
          .eq('role', role)
          .eq('is_deleted', false);

      return (users as List<dynamic>)
          .map((e) => UserProfile.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching users by role: $e');
      return [];
    }
  }

  /// Get all approved owners
  static Future<List<UserProfile>> getApprovedOwners() async {
    try {
      final users = await supabase
          .from('users')
          .select()
          .eq('role', 'owner')
          .eq('is_approved', true)
          .eq('is_deleted', false);

      return (users as List<dynamic>)
          .map((e) => UserProfile.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching approved owners: $e');
      return [];
    }
  }

  /// Update user profile
  static Future<bool> updateUser(UserProfile user) async {
    try {
      if (user.userId == null) {
        throw Exception('User ID is required');
      }
      await supabase
          .from('users')
          .update(user.toJson())
          .eq('user_id', user.userId!);

      print('✅ User updated successfully!');
      return true;
    } catch (e) {
      print('❌ Error updating user: $e');
      return false;
    }
  }

  /// Approve a user
  static Future<bool> approveUser(String userId) async {
    try {
      await supabase
          .from('users')
          .update({'is_approved': true})
          .eq('user_id', userId);

      print('✅ User approved successfully!');
      return true;
    } catch (e) {
      print('❌ Error approving user: $e');
      return false;
    }
  }

  /// Update last login
  static Future<bool> updateLastLogin(String userId) async {
    try {
      await supabase
          .from('users')
          .update({'last_login': DateTime.now().toIso8601String()})
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('❌ Error updating last login: $e');
      return false;
    }
  }

  /// Soft delete user
  static Future<bool> deleteUser(String userId) async {
    try {
      await supabase
          .from('users')
          .update({'is_deleted': true})
          .eq('user_id', userId);

      print('✅ User deleted successfully!');
      return true;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }

  /// Get pending admin approvals (for super admin)
  static Future<List<UserProfile>> getPendingAdmins() async {
    try {
      final users = await supabase
          .from('users')
          .select()
          .eq('role', 'admin')
          .eq('is_approved', false)
          .eq('is_deleted', false);

      return (users as List<dynamic>)
          .map((e) => UserProfile.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching pending admins: $e');
      return [];
    }
  }
}

import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/utils/app_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuestHouseService {
  static final SupabaseClient supabase = Supabase.instance.client;

  /// Create a new guest house
  static Future<bool> addGuestHouse(GuestHouse guestHouse) async {
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
      
      guestHouse.ownerId = userResult['user_id'] as int;
      
      final response = await supabase.from('guesthouse').insert(
        guestHouse.toJson(),
      ).select();

      print('✅ Guest house added successfully! $response');
      return true;
    } catch (e) {
      print('❌ Error adding guest house: $e');
      return false;
    }
  }

  /// Get all guest houses for the current owner
  static Future<List<GuestHouse>> getUserGuestHouses() async {
    try {
      // final currentUser = supabase.auth.currentUser;
      // if (currentUser == null) {
      //   throw Exception('No user logged in');
      // }
      
      // Get the user_id from users table using email
      final userResult = await supabase
          .from('users')
          .select('user_id')
          .eq('email', AppState.userEmail!)
          .maybeSingle();
      
      if (userResult == null) {
        throw Exception('User not found in users table');
      }
      
      final userId = userResult['user_id'] as int;
      
      final houses = await supabase
          .from('guesthouse')
          .select()
          .eq('owner_id', userId);
          // .eq('is_active', true);

      return (houses as List<dynamic>)
          .map((e) => GuestHouse.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching guest houses: $e');
      return [];
    }
  }

  /// Get a specific guest house by ID
  static Future<GuestHouse?> getGuestHouseById(int guesthouseId) async {
    try {
      final house = await supabase
          .from('guesthouse')
          .select()
          .eq('guesthouse_id', guesthouseId)
          .maybeSingle();

      if (house == null) return null;
      return GuestHouse.fromJson(house);
    } catch (e) {
      print('❌ Error fetching guest house: $e');
      return null;
    }
  }

  /// Get all active guest houses (for guests)
  static Future<List<GuestHouse>> getAllActiveGuestHouses() async {
    try {
      final houses = await supabase
          .from('guesthouse')
          .select();
          // .eq('is_active', true);

      return (houses as List<dynamic>)
          .map((e) => GuestHouse.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching active guest houses: $e');
      return [];
    }
  }

  /// Update a guest house
  static Future<bool> updateGuestHouse(GuestHouse guestHouse) async {
    try {
      if (guestHouse.guesthouseId == null) {
        throw Exception('Guest House ID is required');
      }
      await supabase
          .from('guesthouse')
          .update(guestHouse.toJson())
          .eq('guesthouse_id', guestHouse.guesthouseId!);

      print('✅ Guest house updated successfully!');
      return true;
    } catch (e) {
      print('❌ Error updating guest house: $e');
      return false;
    }
  }

  /// Deactivate a guest house
  static Future<bool> deactivateGuestHouse(int guesthouseId) async {
    try {
      await supabase
          .from('guesthouse')
          .update({'is_active': false})
          .eq('guesthouse_id', guesthouseId);

      print('✅ Guest house deactivated successfully!');
      return true;
    } catch (e) {
      print('❌ Error deactivating guest house: $e');
      return false;
    }
  }

  /// Delete a guest house
  static Future<bool> deleteGuestHouse(int guesthouseId) async {
    try {
      await supabase
          .from('guesthouse')
          .delete()
          .eq('guesthouse_id', guesthouseId);

      print('✅ Guest house deleted successfully!');
      return true;
    } catch (e) {
      print('❌ Error deleting guest house: $e');
      return false;
    }
  }
}

import 'package:lodge_logic/models/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomService {
  static final SupabaseClient supabase = Supabase.instance.client;

  /// Create a new room
  static Future<bool> createRoom(Room room) async {
    try {
      await supabase.from('room').insert(room.toJson()).select();
      print('✅ Room created successfully!');
      return true;
    } catch (e) {
      print('❌ Error creating room: $e');
      return false;
    }
  }

  /// Add a new room (alias for createRoom)
  static Future<bool> addRoom(Room room) async {
    return createRoom(room);
  }

  /// Get all rooms for a specific guest house
  static Future<List<Room>> getRoomsByGuestHouse(int guesthouseId) async {
    try {
      final rooms = await supabase
          .from('room')
          .select()
          .eq('guesthouse', guesthouseId);

      return (rooms as List<dynamic>)
          .map((e) => Room.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching rooms: $e');
      return [];
    }
  }

  /// Get a specific room by ID
  static Future<Room?> getRoomById(int roomId) async {
    try {
      final room = await supabase
          .from('room')
          .select()
          .eq('room_id', roomId)
          .maybeSingle();

      if (room == null) return null;
      return Room.fromJson(room);
    } catch (e) {
      print('❌ Error fetching room: $e');
      return null;
    }
  }

  /// Get available rooms for a guest house
  static Future<List<Room>> getAvailableRooms(int guesthouseId) async {
    try {
      final rooms = await supabase
          .from('room')
          .select()
          .eq('guesthouse', guesthouseId)
          .eq('is_available', true)
          .eq('status', 'available');

      return (rooms as List<dynamic>)
          .map((e) => Room.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching available rooms: $e');
      return [];
    }
  }

  /// Update a room
  static Future<bool> updateRoom(Room room) async {
    try {
      if (room.roomId == null) {
        throw Exception('Room ID is required');
      }
      await supabase
          .from('room')
          .update(room.toJson())
          .eq('room_id', room.roomId!);

      print('✅ Room updated successfully!');
      return true;
    } catch (e) {
      print('❌ Error updating room: $e');
      return false;
    }
  }

  /// Update room status
  static Future<bool> updateRoomStatus(
      int roomId, String status) async {
    try {
      await supabase
          .from('room')
          .update({'status': status})
          .eq('room_id', roomId);

      print('✅ Room status updated to $status!');
      return true;
    } catch (e) {
      print('❌ Error updating room status: $e');
      return false;
    }
  }

  /// Update room availability
  static Future<bool> updateRoomAvailability(
      int roomId, bool isAvailable) async {
    try {
      await supabase
          .from('room')
          .update({'is_available': isAvailable})
          .eq('room_id', roomId);

      print('✅ Room availability updated!');
      return true;
    } catch (e) {
      print('❌ Error updating room availability: $e');
      return false;
    }
  }

  /// Delete a room
  static Future<bool> deleteRoom(int roomId) async {
    try {
      await supabase.from('room').delete().eq('room_id', roomId);
      print('✅ Room deleted successfully!');;
      return true;
    } catch (e) {
      print('❌ Error deleting room: $e');
      return false;
    }
  }
}

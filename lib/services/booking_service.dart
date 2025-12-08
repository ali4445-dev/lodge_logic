import 'package:lodge_logic/models/booking.dart';
import 'package:lodge_logic/utils/app_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class BookingService {
  static final SupabaseClient supabase = Supabase.instance.client;

  /// Create a new booking
  static Future<bool> createBooking(Booking booking) async {
    try {
      
      
      // Get the user_id from users table using email
      final userResult = await supabase
          .from('users')
          .select('user_id')
          .eq('email', AppState.userEmail!)
          .maybeSingle();
      
      if (userResult == null) {
        throw Exception('User not found in users table');
      }
      
      booking.guestId = userResult['user_id'] as int;
      booking.bookingId = const Uuid().v4();
      booking.bookingDate = DateTime.now();
      
      await supabase.from('booking').insert(booking.toJson()).select();
      
      // Update room status
      await supabase.from('room').update({
        'status': 'occupied',
        'is_available': false
      }).eq('room_id', booking.roomId!);
      
      print('✅ Booking created successfully!');
      return true;
    } catch (e) {
      print('❌ Error creating booking: $e');
      return false;
    }
  }

  /// Get all bookings for the current guest
  static Future<List<Booking>> getGuestBookings() async {
    try {
      if (AppState.userEmail == null) {
        throw Exception('No user logged in');
      }
      
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
      
      final bookings = await supabase
          .from('booking')
          .select()
          .eq('guest_id', userId)
          .order('booking_date', ascending: false);

      return (bookings as List<dynamic>)
          .map((e) => Booking.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching guest bookings: $e');
      return [];
    }
  }

  /// Get all bookings for a specific guest house
  static Future<List<Booking>> getGuestHouseBookings(int guesthouseId) async {
    try {
      final bookings = await supabase
          .from('booking')
          .select()
          .eq('guesthouse_id', guesthouseId)
          .order('booking_date', ascending: false);

      return (bookings as List<dynamic>)
          .map((e) => Booking.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching guest house bookings: $e');
      return [];
    }
  }

  /// Get a specific booking by ID
  static Future<Booking?> getBookingById(int bookingId) async {
    try {
      final booking = await supabase
          .from('booking')
          .select()
          .eq('booking_id', bookingId)
          .maybeSingle();

      if (booking == null) return null;
      return Booking.fromJson(booking);
    } catch (e) {
      print('❌ Error fetching booking: $e');
      return null;
    }
  }

  /// Get bookings for a specific room
  static Future<List<Booking>> getRoomBookings(int roomId) async {
    try {
      final bookings = await supabase
          .from('booking')
          .select()
          .eq('room_id', roomId)
          .order('check_in', ascending: true);

      return (bookings as List<dynamic>)
          .map((e) => Booking.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching room bookings: $e');
      return [];
    }
  }

  /// Update booking status
  static Future<bool> updateBookingStatus(
      String bookingId, String status) async {
    try {
      await supabase
          .from('booking')
          .update({'status': status})
          .eq('booking_id', bookingId);

      print('✅ Booking status updated to $status!');
      return true;
    } catch (e) {
      print('❌ Error updating booking status: $e');
      return false;
    }
  }

  /// Cancel a booking
  static Future<bool> cancelBooking(String bookingId) async {
    try {
      await supabase
          .from('booking')
          .update({'status': 'cancelled'})
          .eq('booking_id', bookingId);

      print('✅ Booking cancelled successfully!');
      return true;
    } catch (e) {
      print('❌ Error cancelling booking: $e');
      return false;
    }
  }

  /// Get active bookings for a guest house (for checking occupancy)
  static Future<List<Booking>> getActiveBookings(int guesthouseId) async {
    try {
      final bookings = await supabase
          .from('booking')
          .select()
          .eq('guesthouse_id', guesthouseId)
          .inFilter('status', ['confirmed', 'pending']);

      return (bookings as List<dynamic>)
          .map((e) => Booking.fromJson(e))
          .toList();
    } catch (e) {
      print('❌ Error fetching active bookings: $e');
      return [];
    }
  }

  /// Delete a booking
  static Future<bool> deleteBooking(String bookingId) async {
    try {
      await supabase.from('booking').delete().eq('booking_id', bookingId);
      print('✅ Booking deleted successfully!');;
      return true;
    } catch (e) {
      print('❌ Error deleting booking: $e');
      return false;
    }
  }
}

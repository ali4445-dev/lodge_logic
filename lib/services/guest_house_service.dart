import 'package:lodge_logic/models/guest_house.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 // import your GuestHouse class

class GuestHouseService {
 static final SupabaseClient supabase = Supabase.instance.client;

  /// Adds a new guest house to the database
 static Future<bool> addGuestHouse(GuestHouse guestHouse) async {
  print(supabase.auth.currentUser!.id);
  guestHouse.ownerId = supabase.auth.currentUser!.id;
  print(guestHouse.ownerId);
  
    try {
      final response = await supabase.from('guest_houses').insert(
        guestHouse.toJson(),
      ).select();

      

      print('Guest house added successfully! $response');
      return true;
    } catch (e) {
      print('Exception adding guest house: $e');
      return false;
    }
  }

 static Future<List<GuestHouse>> getUserGuestHouses() async {
    List<GuestHouse> guest_houses = [];
  final houses = await supabase
      .from('guest_houses')
      .select()
      .eq('owner_id', supabase.auth.currentUser!.id);

  for (var house in houses) {
   guest_houses.add( GuestHouse.fromJson(house));
  }

  return guest_houses;
}
}

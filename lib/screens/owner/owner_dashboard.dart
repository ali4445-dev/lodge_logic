// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:lodge_logic/components/snackbar.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/screens/owner/add_admin.dart';
import 'package:lodge_logic/screens/owner/add_guest_house.dart';
import 'package:lodge_logic/services/guest_house_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OwnerDashboard extends StatefulWidget {
  AuthResponse authResponse;
   OwnerDashboard({super.key,required this.authResponse});

   
  

  @override
  State<OwnerDashboard> createState() => _OwnerDashBoardScreenState();
}

class _OwnerDashBoardScreenState extends State<OwnerDashboard> {
  
  @override
  initState(){
    super.initState();
    retrieveHouses();
    }
  
  List<GuestHouse> guest_houses = [];
  void retrieveHouses()async{
    
   final houses = await GuestHouseService.getUserGuestHouses();
   print(houses);
   setState(() {
     guest_houses = houses ;
   });
    }

  @override
  Widget build(BuildContext context) {  
   
   final user =widget. authResponse.user;
    final userName = user?.userMetadata!['name'] ?? 'Unknown';
   
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔵 Gradient Background (same theme as login)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
  //               IconButton(onPressed: ()async{
  //                 final houses = await GuestHouseService.getUserGuestHouses();
  //  print(houses);
  //  setState(() {
  //    guest_houses = houses ;
  //  });
  //               }, icon: Icon(Icons.refresh_outlined,color: Colors.green,)),

                // HEADER
                Center(
                  child:  Text(
                    "Welcome ${userName}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: const Text(
                    "Manage your guest houses & operations",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔘 ACTION BUTTONS
                Row(
                  children: [
                    Expanded(child: _actionButton(
                      icon: Icons.home_filled,
                      label: "Register Guest House",
                      onTap: () {
                        showCustomSnackbar(context: context, message: "Registering Guest House", type: SnackbarType.info);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddGuestHouseScreen()));
                      },
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _actionButton(
                      icon: Icons.pie_chart,
                      label: "Reports",
                      onTap: () {},
                    )),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(child: _actionButton(
                      icon: Icons.person_add_alt_1,
                      label: "Add Admin",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAdminScreen(),));
                      },
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _actionButton(
                      icon: Icons.account_balance_wallet,
                      label: "Payouts",
                      onTap: () {},
                    )),
                  ],
                ),

                const SizedBox(height: 15),

                // 🏨 OWNER GUEST HOUSE LIST (Mini Dashboard)
                Center(
                  child: const Text(
                    "Your Guest Houses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),



               
                Expanded(

                  child:  ListView.builder(itemBuilder: (context, index) => _guestHouseCard(
                        name: guest_houses[index].name,
                        location: "Islamabad",
                        rooms: guest_houses[index].rooms,
                        occupied: 16,
                      ),itemCount:guest_houses.length ,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ REUSABLE ACTION BUTTON
  Widget _actionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, size: 35, color: Colors.blue.shade800),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  // ⭐ Guest House Dashboard Mini Card
  Widget _guestHouseCard({
    required String name,
    required String location,
    required int rooms,
    required int occupied,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 5),
          Text(location,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              )),

          const SizedBox(height: 12),

          // Occupancy Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusChip("Rooms: $rooms", Icons.meeting_room),
              _statusChip("Occupied: $occupied", Icons.hotel),
              _statusChip("Vacant: ${rooms - occupied}", Icons.check_circle),
            ],
          ),

          const SizedBox(height: 15),

          // Manage Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text(
                "Open Dashboard",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _statusChip(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade800),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

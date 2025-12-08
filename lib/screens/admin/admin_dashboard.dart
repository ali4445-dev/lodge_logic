import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatelessWidget {
  final AuthResponse authResponse;
  
  const AdminDashboard({super.key,required this.authResponse});

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    final isMobile = mq.width < 768;

    final user = authResponse.user;
    final userName = user?.userMetadata!['name'] ?? 'Unknown';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // -------------------------------------------------
                // HEADER: Admin Name + Badge
                // -------------------------------------------------
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: isMobile
                        ? Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person, size: 35, color: Colors.blue),
                              ),
                              const SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Welcome, ${userName}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: const Text(
                                        "Guest House Admin",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person, size: 35, color: Colors.blue),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "Welcome, ${userName}",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: const Text(
                                        "Guest House Admin",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                // -------------------------------------------------
                // MINI STAT CARDS
                // -------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _statCard("12", "Rooms", Icons.meeting_room),
                        SizedBox(width: 20,),
                        _statCard("05", "Bookings", Icons.calendar_month),
                        SizedBox(width: 20,),
                        _statCard("08", "Guests", Icons.people_alt),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // -------------------------------------------------
                // MAIN GRID MENU
                // -------------------------------------------------
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: GridView.count(
                      crossAxisCount: isMobile ? 2 : 4,
                      childAspectRatio: isMobile ? 1.2 : 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        _menuTile(
                          title: "Manage Rooms",
                          icon: Icons.bed_outlined,
                          onTap: () {},
                          context: context
                        ),
                        _menuTile(
                          title: "Bookings",
                          icon: Icons.calendar_today,
                          onTap: () {},
                          context: context
                        ),
                        _menuTile(
                          title: "Check-In / Out",
                          icon: Icons.login_outlined,
                          onTap: () {},
                          context: context
                        ),
                        _menuTile(
                          title: "Cleaning",
                          icon: Icons.cleaning_services_outlined,
                          onTap: () {},
                          context: context
                        ),
                        _menuTile(
                          title: "Complaints",
                          icon: Icons.chat_bubble_outline,
                          onTap: () {},
                          context: context
                        ),
                        _menuTile(
                          title: "Reports",
                          icon: Icons.bar_chart_rounded,
                          onTap: () {},
                          context: context
                        ),
                        _menuTile(
                          title: "Profile",
                          icon: Icons.settings,
                          onTap: () {},
                          context: context
                        ),
                        _menuTile(
                          title: "Logout",
                          icon: Icons.logout,
                          onTap: () {},
                          context: context
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // WIDGETS
  // ======================================================

  Widget _statCard(String number, String label, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 78, 53).withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        
      ),
      child: Column(
        
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 32),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context
  }) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return InkWell(
      
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:  [
              Color.fromARGB(255, 92, 59, 183),
              Color(0xFF1976D2),
              Color.fromARGB(255, 29, 26, 250),
            ],),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isMobile ? 32 : 42, color: Colors.blue.shade900),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: isMobile ? 12 : 15,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}

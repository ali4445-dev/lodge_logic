import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


// Mock Data Structure
class GuestHouse {
  final int id;
  final String name;
  final String location;
  final double rating;
  final int totalRooms;
  final int availableRooms;
  final String status;
  final String image;
  final String phone;
  final String email;

  GuestHouse({
    required this.id, required this.name, required this.location,
    required this.rating, required this.totalRooms, required this.availableRooms,
    required this.status, required this.image, required this.phone, required this.email,
  });
}

class GuestHousesScreen extends StatefulWidget {
  const GuestHousesScreen({super.key});

  @override
  State<GuestHousesScreen> createState() => _GuestHousesScreenState();
}

class _GuestHousesScreenState extends State<GuestHousesScreen> {
  String _searchTerm = '';

  final List<GuestHouse> _guestHouses = [
    GuestHouse(
      id: 1, name: 'Sunny Side Guest House', location: '123 Beach Road, Miami', rating: 4.8,
      totalRooms: 25, availableRooms: 8, status: 'Active',
      image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      phone: '+1 234-567-8900', email: 'info@sunnyside.com',
    ),
    GuestHouse(
      id: 2, name: 'Ocean View Villa', location: '456 Coastal Drive, San Diego', rating: 4.9,
      totalRooms: 15, availableRooms: 3, status: 'Active',
      image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
      phone: '+1 987-654-3210', email: 'oceanview@villa.com',
    ),
    GuestHouse(
      id: 3, name: 'Mountain Retreat Lodge', location: '789 Summit Peak, Denver', rating: 4.5,
      totalRooms: 10, availableRooms: 0, status: 'Inactive',
      image: 'https://images.unsplash.com/photo-1570535974026-b8a7f14b3d81?w=400',
      phone: '+1 555-123-4567', email: 'retreat@lodge.com',
    ),
  ];

  List<GuestHouse> get _filteredGuestHouses => _guestHouses.where((house) {
    final searchLower = _searchTerm.toLowerCase();
    return house.name.toLowerCase().contains(searchLower) ||
        house.location.toLowerCase().contains(searchLower);
  }).toList();

  Widget _buildGuestHouseCard(GuestHouse house) {
    return GestureDetector(
      onTap: () {}, // Could navigate to detail view
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.network(
                house.image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: AppColors.gray200,
                  child: const Center(child: Icon(AppIcons.building, size: 50, color: AppColors.gray400)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    house.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.gray900),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(AppIcons.mapPin, size: 14, color: AppColors.gray500),
                      const SizedBox(width: 4),
                      Expanded(child: Text(house.location, style: const TextStyle(fontSize: 13, color: AppColors.gray600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatChip(
                        icon: AppIcons.star,
                        label: house.rating.toString(),
                        color: AppColors.yellow600,
                      ),
                      _buildStatChip(
                        icon: AppIcons.bedDouble,
                        label: '${house.totalRooms} Rooms',
                        color: AppColors.blue600,
                      ),
                      _buildStatChip(
                        icon: AppIcons.check,
                        label: '${house.availableRooms} Available',
                        color: AppColors.indigo600,
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: AppColors.gray100),
                  // Contact Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(AppIcons.phone, size: 14, color: AppColors.gray500),
                          const SizedBox(width: 4),
                          Text(house.phone, style: const TextStyle(fontSize: 13, color: AppColors.gray600)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(AppIcons.mail, size: 14, color: AppColors.gray500),
                          const SizedBox(width: 4),
                          // Truncate email on smaller screens if necessary
                          Text(house.email, style: const TextStyle(fontSize: 13, color: AppColors.gray600), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/add-guest-house'),
                          icon: const Icon(AppIcons.edit, size: 16, color: AppColors.indigo600),
                          label: const Text('Edit', style: TextStyle(color: AppColors.indigo600, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo100,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => print('Delete ${house.name}'),
                        icon: const Icon(AppIcons.trash, color: AppColors.red600),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.red100,
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(double screenWidth) {
    final isMobile = screenWidth < 600;
    return SingleChildScrollView(
      padding: kPagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Pages / Guest Houses', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Guest Houses', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('View, manage, and add new properties', style: TextStyle(fontSize: 14, color: AppColors.indigo100)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tools Bar (Search & Add Button)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (val) => setState(() => _searchTerm = val),
                  decoration: InputDecoration(
                    hintText: 'Search guest houses...',
                    prefixIcon: Icon(AppIcons.search, color: AppColors.gray400),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              if (!isMobile) const SizedBox(width: 16),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/add-guest-house'),
                  icon: const Icon(AppIcons.building, color: Colors.white),
                  label: const Text('Add Guest House', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigo600,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/add-guest-house'),
                icon: const Icon(AppIcons.building, color: Colors.white),
                label: const Text('Add Guest House', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indigo600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),

          // Guest House Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredGuestHouses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (screenWidth < 1100 ? 2 : 3),
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              childAspectRatio: isMobile ? 0.8 : 0.75, // Adjust for card height
            ),
            itemBuilder: (context, index) => _buildGuestHouseCard(_filteredGuestHouses[index]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < kMobileBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: isMobile
          ? AppBar(
              title: const Text('Guest Houses'),
              backgroundColor: AppColors.indigo600,
            )
          : null,
      drawer: isMobile ? const CustomSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          if (!isMobile) const CustomSidebar(),
          Expanded(
            child: Stack(
              children: [
                // Background Gradient
                Positioned(
                  top: 0, left: 0, right: 0, height: 256,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.indigo600, Color(0xFF6366F1), AppColors.primaryPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(child: _buildContent(screenWidth)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';
import 'package:lodge_logic/services/guest_house_service.dart';

class GuestHousesScreen extends StatefulWidget {
  const GuestHousesScreen({super.key});

  @override
  State<GuestHousesScreen> createState() => _GuestHousesScreenState();
}

class _GuestHousesScreenState extends State<GuestHousesScreen> {
  String _searchTerm = '';
  String? _selectedLocation;
  int? _selectedRoomCount;
  late Future<List<GuestHouse>> _guestHousesFuture;

  @override
  void initState() {
    super.initState();
    _guestHousesFuture = GuestHouseService.getUserGuestHouses();
  }

  List<GuestHouse> _filterGuestHouses(List<GuestHouse> houses) {
    var filtered = houses;

    if (_searchTerm.isNotEmpty) {
      final searchLower = _searchTerm.toLowerCase();
      filtered = filtered.where((house) {
        return house.name.toLowerCase().contains(searchLower) ||
            house.city.toLowerCase().contains(searchLower) ||
            house.country.toLowerCase().contains(searchLower) ||
            (house.address?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    if (_selectedLocation != null) {
      filtered = filtered.where((house) {
        return '${house.city}, ${house.country}' == _selectedLocation;
      }).toList();
    }

    if (_selectedRoomCount != null) {
      filtered = filtered.where((house) {
        return house.totalRooms == _selectedRoomCount;
      }).toList();
    }

    return filtered;
  }

  List<String> _getUniqueLocations(List<GuestHouse> houses) {
    return houses.map((h) => '${h.city}, ${h.country}').toSet().toList()..sort();
  }

  List<int> _getUniqueRoomCounts(List<GuestHouse> houses) {
    return houses.map((h) => h.totalRooms).toSet().toList()..sort();
  }

  Widget _buildGuestHouseCard(GuestHouse house) {
    final isPending = !(house.isActive ?? true);
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/add-guest-house',
          arguments: house,
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryTeal.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: _buildGuestHouseImage(house),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (house.isActive ?? true)
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      (house.isActive ?? true) ? 'Active' : 'Pending',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: PopupMenuButton<String>(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.more_vert, size: 18),
                    ),
                    onSelected: (value) {
                      if (value == 'activate') {
                        _activateGuestHouse(house);
                      } else if (value == 'deactivate') {
                        _deactivateGuestHouse(house);
                      } else if (value == 'delete') {
                        _deleteGuestHouse(house);
                      }
                    },
                    itemBuilder: (context) => [
                      if (isPending)
                        const PopupMenuItem(
                          value: 'activate',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 18, color: Color(0xFF10B981)),
                              SizedBox(width: 8),
                              Text('Activate'),
                            ],
                          ),
                        ),
                      if (!isPending)
                        const PopupMenuItem(
                          value: 'deactivate',
                          child: Row(
                            children: [
                              Icon(Icons.pause_circle, size: 18, color: Color(0xFFF59E0B)),
                              SizedBox(width: 8),
                              Text('Deactivate'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    house.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primaryTeal),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${house.city}, ${house.country}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (house.address != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.home_outlined, size: 16, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            house.address!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gray500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(
                          Icons.meeting_room_outlined,
                          '${house.totalRooms}',
                          'Rooms',
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColors.gray300,
                        ),
                        _buildInfoItem(
                          Icons.night_shelter_outlined,
                          'N/A',
                          'Per Night',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryTeal),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  void _activateGuestHouse(GuestHouse house) async {
    if (house.guesthouseId == null) return;
    
    final updatedHouse = GuestHouse(
      guesthouseId: house.guesthouseId,
      ownerId: house.ownerId,
      name: house.name,
      address: house.address,
      city: house.city,
      country: house.country,
      totalRooms: house.totalRooms,
      description: house.description,
      amenities: house.amenities,
      images: house.images,
      isActive: true,
    );
    
    final success = await GuestHouseService.updateGuestHouse(updatedHouse);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Guest house activated'), backgroundColor: Colors.green),
      );
      setState(() => _guestHousesFuture = GuestHouseService.getUserGuestHouses());
    }
  }

  void _deactivateGuestHouse(GuestHouse house) async {
    if (house.guesthouseId == null) return;
    
    final success = await GuestHouseService.deactivateGuestHouse(house.guesthouseId!);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Guest house deactivated'), backgroundColor: Colors.orange),
      );
      setState(() => _guestHousesFuture = GuestHouseService.getUserGuestHouses());
    }
  }

  void _deleteGuestHouse(GuestHouse house) async {
    if (house.guesthouseId == null) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Guest House'),
        content: Text('Are you sure you want to delete "${house.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      final success = await GuestHouseService.deleteGuestHouse(house.guesthouseId!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Guest house deleted'), backgroundColor: Colors.red),
        );
        setState(() => _guestHousesFuture = GuestHouseService.getUserGuestHouses());
      }
    }
  }

  Widget _buildGuestHouseImage(GuestHouse house) {
    if (house.images != null && house.images!.isNotEmpty) {
      return Image.network(
        house.images!.first,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: AppColors.gray200,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryTeal),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Image load error: $error');
          return _buildPlaceholderImage();
        },
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gray200,
            AppColors.gray300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.apartment, size: 60, color: AppColors.gray400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: isMobile
          ? AppBar(
              title: const Text('My Guest Houses'),
              backgroundColor: AppColors.primaryTeal,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add-guest-house');
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryTeal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      drawer: isMobile ? const CustomSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          if (!isMobile) const CustomSidebar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header with gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryTeal,
                          Color(0xFF0F766E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMobile)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // : CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Guest Houses',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Manage your properties',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/add-guest-house');
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Guest House'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryTeal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'My Guest Houses',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Manage your properties',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        FutureBuilder<List<GuestHouse>>(
                          future: _guestHousesFuture,
                          builder: (context, snapshot) {
                            final houses = snapshot.data ?? [];
                            final locations = _getUniqueLocations(houses);
                            final roomCounts = _getUniqueRoomCounts(houses);

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedLocation,
                                            hint: const Row(
                                              children: [
                                                Icon(Icons.location_on, size: 18, color: AppColors.gray400),
                                                SizedBox(width: 8),
                                                Text('Location'),
                                              ],
                                            ),
                                            isExpanded: true,
                                            items: [
                                              const DropdownMenuItem(
                                                value: null,
                                                child: Text('All Locations'),
                                              ),
                                              ...locations.map((loc) => DropdownMenuItem(
                                                value: loc,
                                                child: Text(loc),
                                              )),
                                            ],
                                            onChanged: (value) {
                                              setState(() => _selectedLocation = value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: _selectedRoomCount,
                                            hint: const Row(
                                              children: [
                                                Icon(Icons.meeting_room, size: 18, color: AppColors.gray400),
                                                SizedBox(width: 8),
                                                Text('Rooms'),
                                              ],
                                            ),
                                            isExpanded: true,
                                            items: [
                                              const DropdownMenuItem(
                                                value: null,
                                                child: Text('All Rooms'),
                                              ),
                                              ...roomCounts.map((count) => DropdownMenuItem(
                                                value: count,
                                                child: Text('$count Rooms'),
                                              )),
                                            ],
                                            onChanged: (value) {
                                              setState(() => _selectedRoomCount = value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() => _searchTerm = value);
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Search guest houses...',
                                      prefixIcon: Icon(Icons.search, color: AppColors.gray400),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Guest Houses List
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: FutureBuilder<List<GuestHouse>>(
                      future: _guestHousesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryTeal,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 64,
                                    color: Colors.red),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.gray700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.apartment_outlined,
                                    size: 64,
                                    color: AppColors.gray400),
                                const SizedBox(height: 16),
                                const Text(
                                  'No guest houses yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Create your first guest house to get started',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final filteredHouses =
                            _filterGuestHouses(snapshot.data!);

                        if (filteredHouses.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off,
                                    size: 64,
                                    color: AppColors.gray400),
                                const SizedBox(height: 16),
                                const Text(
                                  'No guest houses found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          alignment: WrapAlignment.start,
                          children: filteredHouses.map((house) {
                            return _buildGuestHouseCard(house);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class GuestHouse {
  final String guesthouseId;
  final String name;
  final String city;
  final String country;
  final String address;
  final String description;
  final int totalRooms;
  final List<String> amenities;
  final List<String> images;
  final double rating;

  GuestHouse({
    required this.guesthouseId,
    required this.name,
    required this.city,
    required this.country,
    required this.address,
    required this.description,
    required this.totalRooms,
    required this.amenities,
    required this.images,
    required this.rating,
  });
}

class AllGuestHousesPage extends StatefulWidget {
  const AllGuestHousesPage({Key? key}) : super(key: key);

  @override
  State<AllGuestHousesPage> createState() => _AllGuestHousesPageState();
}

class _AllGuestHousesPageState extends State<AllGuestHousesPage> {
  bool loading = true;
  List<GuestHouse> guestHouses = [];
  String searchTerm = '';
  String viewMode = 'grid'; // 'grid' or 'list'
  String sortBy = 'name'; // 'name', 'city', 'rooms'

  @override
  void initState() {
    super.initState();
    fetchAllGuestHouses();
  }

  Future<void> fetchAllGuestHouses() async {
    // Simulated API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      guestHouses = [
        GuestHouse(
          guesthouseId: '1',
          name: 'Paradise Inn',
          city: 'Bali',
          country: 'Indonesia',
          address: '123 Beach Street',
          description: 'A beautiful beachside guest house with stunning ocean views.',
          totalRooms: 8,
          amenities: ['WiFi', 'Pool', 'Restaurant', 'Gym'],
          images: ['https://via.placeholder.com/400x300?text=Paradise+Inn'],
          rating: 4.8,
        ),
        GuestHouse(
          guesthouseId: '2',
          name: 'Mountain Lodge',
          city: 'Interlaken',
          country: 'Switzerland',
          address: '456 Alpine Road',
          description: 'Cozy mountain lodge nestled in the Swiss Alps.',
          totalRooms: 12,
          amenities: ['Sauna', 'Fireplace', 'Hiking Tours', 'Restaurant'],
          images: ['https://via.placeholder.com/400x300?text=Mountain+Lodge'],
          rating: 4.6,
        ),
        GuestHouse(
          guesthouseId: '3',
          name: 'Ocean View Resort',
          city: 'Maldives',
          country: 'Maldives',
          address: '789 Island Way',
          description: 'Tropical paradise with water bungalows and coral reef access.',
          totalRooms: 15,
          amenities: ['Snorkeling', 'Spa', 'Water Sports', 'Beach Access'],
          images: ['https://via.placeholder.com/400x300?text=Ocean+View'],
          rating: 4.9,
        ),
      ];
      loading = false;
    });
  }

  List<GuestHouse> getFilteredAndSortedHouses() {
    var filtered = guestHouses.where((house) {
      return house.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          house.city.toLowerCase().contains(searchTerm.toLowerCase()) ||
          house.country.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();

    filtered.sort((a, b) {
      switch (sortBy) {
        case 'name':
          return a.name.compareTo(b.name);
        case 'city':
          return a.city.compareTo(b.city);
        case 'rooms':
          return b.totalRooms.compareTo(a.totalRooms);
        default:
          return 0;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredHouses = getFilteredAndSortedHouses();

    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F2937), Color(0xFF111827)],
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back),
                        label: Text('Back to Home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          foregroundColor: Colors.grey[300],
                        ),
                      ),
                      Text(
                        'LodgeLogic',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'All Guest Houses',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Discover exceptional accommodations tailored to your needs',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),

            // Filters and Search
            Container(
              color: Colors.white.withOpacity(0.7),
              padding: EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() => searchTerm = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by name, city, or country...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.indigo, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  DropdownButton<String>(
                    value: sortBy,
                    onChanged: (value) {
                      setState(() => sortBy = value ?? 'name');
                    },
                    items: [
                      DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                      DropdownMenuItem(value: 'city', child: Text('Sort by City')),
                      DropdownMenuItem(value: 'rooms', child: Text('Sort by Rooms')),
                    ],
                  ),
                  SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.grid_3x3, color: viewMode == 'grid' ? Colors.indigo : Colors.grey),
                          onPressed: () => setState(() => viewMode = 'grid'),
                        ),
                        IconButton(
                          icon: Icon(Icons.list, color: viewMode == 'list' ? Colors.indigo : Colors.grey),
                          onPressed: () => setState(() => viewMode = 'list'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Showing ${filteredHouses.length} guest houses',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  if (loading)
                    Center(child: CircularProgressIndicator())
                  else if (filteredHouses.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.home, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text('No guest houses found', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                          Text('Try adjusting your search criteria', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    )
                  else if (viewMode == 'grid')
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.75,
                      ),
                      shrinkWrap: true,
                      itemCount: filteredHouses.length,
                      itemBuilder: (context, index) {
                        return _buildGridCard(filteredHouses[index]);
                      },
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredHouses.length,
                      itemBuilder: (context, index) {
                        return _buildListCard(filteredHouses[index]);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(GuestHouse house) {
    return Container(
    
      decoration: BoxDecoration(
        
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      // overflow: Hidden.clipped,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            color: Colors.grey[300],
            child: Icon(Icons.image, color: Colors.grey[600], size: 48),
          
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${house.city}, ${house.country}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.home, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('${house.totalRooms} rooms', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('${house.rating}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(GuestHouse house) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 300,
            height: 180,
            color: Colors.grey[300],
            child: Icon(Icons.image, color: Colors.grey[600], size: 48),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    house.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 6),
                      Text('${house.address}, ${house.city}, ${house.country}', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    house.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home, size: 16, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('${house.totalRooms} rooms', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          SizedBox(width: 24),
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 6),
                          Text('${house.rating}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
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

// Remove Hidden import, use Clip instead
class Hidden {
  static const clipped = Clip.hardEdge;
}

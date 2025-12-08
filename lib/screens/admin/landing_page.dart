import 'package:flutter/material.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/screens/auth/sign_in_screen.dart';
import 'package:lodge_logic/screens/guest_house_rooms_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isMenuOpen = false;
  bool isScrolled = false;
  List<GuestHouse> _guestHouses = [];
  List<GuestHouse> _filteredGuestHouses = [];
  bool _loading = true;
  
  final _searchController = TextEditingController();
  String? _selectedCountry;
  String? _selectedCity;
  double? _maxPrice;
  List<String> _selectedAmenities = [];

  @override
  void initState() {
    super.initState();
    _loadGuestHouses();
  }

  Future<void> _loadGuestHouses() async {
    try {
      final houses = await Supabase.instance.client
          .from('guesthouse')
          .select()
          .eq('is_active', true);

      setState(() {
        _guestHouses = (houses as List).map((e) => GuestHouse.fromJson(e)).toList();
        _filteredGuestHouses = _guestHouses;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredGuestHouses = _guestHouses.where((house) {
        if (_searchController.text.isNotEmpty &&
            !house.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
          return false;
        }
        if (_selectedCountry != null && house.country != _selectedCountry) return false;
        if (_selectedCity != null && house.city != _selectedCity) return false;
        if (_selectedAmenities.isNotEmpty &&
            !_selectedAmenities.every((a) => house.amenities?.contains(a) ?? false)) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Navigation
            Container(
              color: isScrolled ? Colors.white : Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LodgeLogic',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: isScrolled ? Colors.indigo : Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: Text(MediaQuery.of(context).size.width > 600 ? 'For Administration' : 'Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 600 ? 16 : 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Hero Section
            Container(
              height: MediaQuery.of(context).size.width > 600 ? 600 : 500,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black54, Colors.black38],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(
                            '✨ Premium Guest House Platform',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Find Your Perfect',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600 ? 48 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                          ).createShader(bounds),
                          child: Text(
                            'Guest House',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600 ? 48 : 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Discover exceptional accommodations with instant booking, secure payments, and verified reviews from real guests.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                       
                        SizedBox(height: 48),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: MediaQuery.of(context).size.width > 600 ? 64 : 32,
                            runSpacing: 24,
                            children: [
                              _buildStat('10K+', 'Happy Guests'),
                              _buildStat('500+', 'Guest Houses'),
                              _buildStat('4.9★', 'Average Rating'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Features Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '🎆 Premium Features',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Why Choose LodgeLogic?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 600 ? 40 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Experience seamless booking with our comprehensive platform designed for modern travelers',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 900 ? 3 : constraints.maxWidth > 600 ? 2 : 1;
                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.2,
                        children: [
                          _buildFeatureCard('Smart Search', Icons.search, Colors.blue),
                          _buildFeatureCard('Instant Booking', Icons.lock_clock, Colors.green),
                          _buildFeatureCard('Secure Payments', Icons.shield, Colors.purple),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Guest Houses Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(height: 16),
                        Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => _applyFilters(),
                              decoration: InputDecoration(
                                hintText: 'Search guest houses...',
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.tune),
                                  onPressed: _showFilterDialog,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  Center(
                    child: Text(
                      'Available Guest Houses',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Discover our accommodations worldwide',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(height: 32),
                  _loading
                      ? Center(child: CircularProgressIndicator())
                      : _filteredGuestHouses.isEmpty
                          ? Center(child: Text('No guest houses found'))
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = constraints.maxWidth > 1200
                                    ? 4
                                    : constraints.maxWidth > 800
                                        ? 3
                                        : constraints.maxWidth > 600
                                            ? 2
                                            : 1;
                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 24,
                                    mainAxisSpacing: 24,
                                    childAspectRatio: 0.65,
                                  ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _filteredGuestHouses.length,
                                  itemBuilder: (context, index) {
                                    return _buildGuestHouseCard(_filteredGuestHouses[index]);
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 16),
            // About Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16),
              child: MediaQuery.of(context).size.width > 900
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About LodgeLogic',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                        SizedBox(height: 16),
                        Text(
                          'LodgeLogic is a revolutionary platform that connects travelers with unique guest house experiences worldwide. We believe that every journey should be memorable, comfortable, and hassle-free.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Founded with the vision of making travel accommodation booking simple and secure, we provide a comprehensive platform for both guests and property owners to connect seamlessly.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
                        ),
                              SizedBox(height: 32),
                              Row(
                                children: [
                                  _buildAboutStat('10K+', 'Happy Guests'),
                                  SizedBox(width: 48),
                                  _buildAboutStat('500+', 'Guest Houses'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 48),
                        Expanded(
                          child: Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.image, size: 64, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          'About LodgeLogic',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'LodgeLogic is a revolutionary platform that connects travelers with unique guest house experiences worldwide.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 32,
                          runSpacing: 16,
                          children: [
                            _buildAboutStat('10K+', 'Happy Guests'),
                            _buildAboutStat('500+', 'Guest Houses'),
                          ],
                        ),
                      ],
                    ),
            ),

            // Contact Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16),
              child: Column(
                children: [
                  Text(
                    'Get In Touch',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Have questions? We\'d love to hear from you.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 32),
                  MediaQuery.of(context).size.width > 900
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildContactItem('📍 Address', '123 Business Street\nNew York, NY 10001'),
                                  SizedBox(height: 24),
                                  _buildContactItem('📞 Phone', '+1 (555) 123-4567'),
                                  SizedBox(height: 24),
                                  _buildContactItem('📧 Email', 'support@lodgelogic.com'),
                                ],
                              ),
                            ),
                            SizedBox(width: 48),
                            Expanded(
                              child: Container(
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Your name',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'your@email.com',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Your message...',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                maxLines: 4,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Send Message'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 48),
                                ),
                              ),
                            ],
                              ),
                            ),)
                          ],
                        )
                      : Column(
                          children: [
                            _buildContactItem('📍 Address', '123 Business Street\nNew York, NY 10001'),
                            SizedBox(height: 16),
                            _buildContactItem('📞 Phone', '+1 (555) 123-4567'),
                            SizedBox(height: 16),
                            _buildContactItem('📧 Email', 'support@lodgelogic.com'),
                            SizedBox(height: 32),
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Your name',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'your@email.com',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Your message...',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    maxLines: 4,
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Send Message'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(double.infinity, 48),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),

            // Footer
            Container(
              color: Colors.grey[900],
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: MediaQuery.of(context).size.width > 600 ? 32 : 16),
              child: Column(
                children: [
                  MediaQuery.of(context).size.width > 900
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'LodgeLogic',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Your trusted partner for finding and booking the perfect guest house experience.',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: _buildFooterColumn('Quick Links', ['Home', 'Features', 'About', 'Contact']),
                            ),
                            Expanded(
                              child: _buildFooterColumn('Support', ['Help Center', 'Safety', 'Cancellation', 'Terms']),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text('support@lodgelogic.com', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                  Text('+1 (555) 123-4567', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                  Text('24/7 Customer Support', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'LodgeLogic',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Your trusted partner for finding and booking the perfect guest house experience.',
                              style: TextStyle(color: Colors.grey[400]),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            Text('support@lodgelogic.com', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            Text('+1 (555) 123-4567', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ],
                        ),
                  SizedBox(height: 32),
                  Divider(color: Colors.grey[700]),
                  SizedBox(height: 16),
                  Text(
                    '© 2024 LodgeLogic. All rights reserved.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Experience seamless booking',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGuestHouseCard(GuestHouse house) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuestHouseRoomsScreen(guestHouse: house),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.home_work, size: 72, color: Colors.white.withOpacity(0.9)),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Featured',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    house.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
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
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.meeting_room, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${house.totalRooms} Rooms',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GuestHouseRoomsScreen(guestHouse: house),
                          ),
                        );
                      },
                      child: Text('View Rooms', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Guest Houses'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(labelText: 'Country'),
                items: _guestHouses
                    .map((h) => h.country)
                    .toSet()
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCountry = v),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: InputDecoration(labelText: 'City'),
                items: _guestHouses
                    .map((h) => h.city)
                    .toSet()
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCity = v),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCountry = null;
                _selectedCity = null;
                _selectedAmenities = [];
              });
              _applyFilters();
              Navigator.pop(context);
            },
            child: Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              _applyFilters();
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildContactItem(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 16),
        Expanded(
          child: Text(content, style: TextStyle(color: Colors.grey[600])),
        ),
      ],
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(item, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            )),
      ],
    );
  }
}

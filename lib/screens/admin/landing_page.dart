import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isMenuOpen = false;
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();
    // Simulate scroll listener
  }

  final List<Map<String, dynamic>> dummyGuestHouses = [
    {
      'id': 1,
      'name': 'Sunset Villa Resort',
      'price': 120,
      'rating': 4.8,
      'location': 'Bali, Indonesia',
    },
    {
      'id': 2,
      'name': 'Mountain View Lodge',
      'price': 85,
      'rating': 4.6,
      'location': 'Swiss Alps',
    },
    {
      'id': 3,
      'name': 'Ocean Breeze House',
      'price': 95,
      'rating': 4.9,
      'location': 'Maldives',
    },
    {
      'id': 4,
      'name': 'City Center Boutique',
      'price': 110,
      'rating': 4.7,
      'location': 'Paris, France',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Navigation
            Container(
              color: isScrolled ? Colors.white : Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LodgeLogic',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isScrolled ? Colors.indigo : Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('For Administration'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Hero Section
            Container(
              height: 600,
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
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                          ).createShader(bounds),
                          child: Text(
                            'Guest House',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Discover exceptional accommodations with instant booking,\nsecure payments, and verified reviews from real guests.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                              label: Text('Explore Guest Houses'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStat('10K+', 'Happy Guests'),
                            SizedBox(width: 64),
                            _buildStat('500+', 'Guest Houses'),
                            SizedBox(width: 64),
                            _buildStat('4.9★', 'Average Rating'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Features Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
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
                    style: TextStyle(
                      fontSize: 40,
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
                  SizedBox(height: 48),
                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    shrinkWrap: true,
                    children: [
                      _buildFeatureCard('Smart Search', Icons.search, Colors.blue),
                      _buildFeatureCard('Instant Booking', Icons.lock_clock, Colors.green),
                      _buildFeatureCard('Secure Payments', Icons.shield, Colors.purple),
                    ],
                  ),
                ],
              ),
            ),

            // Popular Guest Houses Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Popular Guest Houses',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Discover our most loved accommodations worldwide',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(height: 32),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.8,
                    ),
                    shrinkWrap: true,
                    itemCount: dummyGuestHouses.length,
                    itemBuilder: (context, index) {
                      final house = dummyGuestHouses[index];
                      return _buildPopularHouseCard(house);
                    },
                  ),
                ],
              ),
            ),

            // About Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
              child: Row(
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
              ),
            ),

            // Contact Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
              child: Column(
                children: [
                  Text(
                    'Get In Touch',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Have questions? We\'d love to hear from you.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 48),
                  Row(
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
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
              child: Column(
                children: [
                  Row(
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

  Widget _buildPopularHouseCard(Map<String, dynamic> house) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            color: Colors.grey[300],
            child: Icon(Icons.image, color: Colors.grey[600], size: 48),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house['name'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(house['location'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('${house['rating']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${house['price']}/night', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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

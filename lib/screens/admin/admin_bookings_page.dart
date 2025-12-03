import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class Booking {
  final String bookingId;
  final String guestName;
  final String guestEmail;
  final String guesthouseName;
  final String roomNumber;
  final String checkIn;
  final String checkOut;
  final String amount;
  final String status;
  final int roomsCount;
  final int guestsCount;
  final String bookingDate;

  Booking({
    required this.bookingId,
    required this.guestName,
    required this.guestEmail,
    required this.guesthouseName,
    required this.roomNumber,
    required this.checkIn,
    required this.checkOut,
    required this.amount,
    required this.status,
    required this.roomsCount,
    required this.guestsCount,
    required this.bookingDate,
  });
}

class AdminBookingsPage extends StatefulWidget {
  final String? pageType; // 'pending', 'modify', 'status'

  const AdminBookingsPage({Key? key, this.pageType}) : super(key: key);

  @override
  State<AdminBookingsPage> createState() => _AdminBookingsPageState();
}

class _AdminBookingsPageState extends State<AdminBookingsPage> {
  bool loading = true;
  List<Booking> bookings = [];
  Map<String, dynamic> stats = {'total': 0, 'confirmed': 0, 'pending': 0, 'revenue': 0};

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    // Simulated API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      bookings = [
        Booking(
          bookingId: 'BK001',
          guestName: 'John Doe',
          guestEmail: 'john@example.com',
          guesthouseName: 'Paradise Inn',
          roomNumber: '101',
          checkIn: '2024-12-05',
          checkOut: '2024-12-10',
          amount: '\$500',
          status: 'confirmed',
          roomsCount: 1,
          guestsCount: 2,
          bookingDate: '2024-12-01',
        ),
        Booking(
          bookingId: 'BK002',
          guestName: 'Sarah Smith',
          guestEmail: 'sarah@example.com',
          guesthouseName: 'Ocean View',
          roomNumber: '205',
          checkIn: '2024-12-08',
          checkOut: '2024-12-12',
          amount: '\$450',
          status: 'pending',
          roomsCount: 1,
          guestsCount: 3,
          bookingDate: '2024-12-02',
        ),
      ];
      
      stats = {
        'total': bookings.length,
        'confirmed': bookings.where((b) => b.status == 'confirmed').length,
        'pending': bookings.where((b) => b.status == 'pending').length,
        'revenue': 950,
      };
      loading = false;
    });
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    setState(() {
      final index = bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        bookings[index] = Booking(
          bookingId: bookings[index].bookingId,
          guestName: bookings[index].guestName,
          guestEmail: bookings[index].guestEmail,
          guesthouseName: bookings[index].guesthouseName,
          roomNumber: bookings[index].roomNumber,
          checkIn: bookings[index].checkIn,
          checkOut: bookings[index].checkOut,
          amount: bookings[index].amount,
          status: newStatus,
          roomsCount: bookings[index].roomsCount,
          guestsCount: bookings[index].guestsCount,
          bookingDate: bookings[index].bookingDate,
        );
      }
    });
  }

  String getPageTitle() {
    switch (widget.pageType) {
      case 'pending':
        return 'Pending Bookings';
      case 'modify':
        return 'Modify Bookings';
      case 'status':
        return 'Booking Status';
      default:
        return 'All Bookings';
    }
  }

  String getPageDescription() {
    switch (widget.pageType) {
      case 'pending':
        return 'Review and approve pending bookings';
      case 'modify':
        return 'Modify existing booking details';
      case 'status':
        return 'Update and track booking statuses';
      default:
        return 'Monitor and manage all platform bookings';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      drawer: isMobile ? AdminSidebarWidget(isDrawer: true) : null,
      body: isMobile
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        AdminSidebarWidget(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              Expanded(
                child: Text(
                  getPageTitle(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          if (!isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getPageTitle(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  getPageDescription(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),

          // Stats Cards
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: isMobile ? 12 : 24,
              mainAxisSpacing: isMobile ? 12 : 24,
              childAspectRatio: 1.4,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              _buildStatCard('Total Bookings', '${stats['total']}', Colors.blue),
              _buildStatCard('Confirmed', '${stats['confirmed']}', Colors.green),
              _buildStatCard('Pending', '${stats['pending']}', Colors.orange),
              _buildStatCard('Revenue', '\$${stats['revenue']}', Colors.purple),
            ],
          ),
          SizedBox(height: 32),

          // Bookings List
          if (loading)
            Center(child: CircularProgressIndicator())
          else if (bookings.isEmpty)
            Center(child: Text('No bookings found'))
          else
            SizedBox(
              height: 600,
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return _buildBookingCard(booking, isMobile);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: isMobile ? 36 : 48,
            height: isMobile ? 36 : 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.event, color: color, size: isMobile ? 18 : 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, bool isMobile) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: isMobile ? 40 : 48,
                    height: isMobile ? 40 : 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.indigo],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.event, color: Colors.white, size: isMobile ? 20 : 24),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.bookingId,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Booked on ${booking.bookingDate}',
                        style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(booking.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              mainAxisSpacing: isMobile ? 12 : 16,
              crossAxisSpacing: isMobile ? 12 : 24,
              childAspectRatio: isMobile ? 2.5 : 3.5,
            ),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GUEST',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  Text(booking.guestName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  Text(booking.guestEmail, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PROPERTY',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  Text(booking.guesthouseName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  Text('Room ${booking.roomNumber}', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHECK-IN',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  Text(booking.checkIn, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  Text(
                    'CHECK-OUT: ${booking.checkOut}',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AMOUNT',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  Text(booking.amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
                  Text(
                    '${booking.roomsCount}R • ${booking.guestsCount}G',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(width: 8),
                if (widget.pageType == 'modify') ...[
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Edit Dates', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Change Room', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => updateBookingStatus(booking.bookingId, 'cancelled'),
                    child: Text('Cancel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ] else if (widget.pageType == 'status') ...[
                  ElevatedButton(
                    onPressed: () => updateBookingStatus(booking.bookingId, 'confirmed'),
                    child: Text('Confirm', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => updateBookingStatus(booking.bookingId, 'completed'),
                    child: Text('Complete', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => updateBookingStatus(booking.bookingId, 'cancelled'),
                    child: Text('Cancel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () => updateBookingStatus(booking.bookingId, 'confirmed'),
                    child: Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => updateBookingStatus(booking.bookingId, 'cancelled'),
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

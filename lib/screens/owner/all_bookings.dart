import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';
 // Assume this file exists

class AllBookingsScreen extends StatefulWidget {
  const AllBookingsScreen({super.key});

  @override
  State<AllBookingsScreen> createState() => _AllBookingsScreenState();
}

// Mock Data Structure
class Booking {
  final int id;
  final String guest;
  final String room;
  final String checkIn;
  final String checkOut;
  final String amount;
  final String status;

  Booking({
    required this.id,
    required this.guest,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.amount,
    required this.status,
  });
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  String _searchTerm = '';

  final List<Booking> _bookings = [
    Booking(id: 1, guest: 'John Doe', room: '101', checkIn: '2024-01-15', checkOut: '2024-01-20', amount: '\$600', status: 'Confirmed'),
    Booking(id: 2, guest: 'Jane Smith', room: '205', checkIn: '2024-01-18', checkOut: '2024-01-22', amount: '\$480', status: 'Pending'),
    Booking(id: 3, guest: 'Mike Johnson', room: '301', checkIn: '2024-01-20', checkOut: '2024-01-25', amount: '\$1000', status: 'Cancelled'),
    Booking(id: 4, guest: 'Sarah Williams', room: '102', checkIn: '2024-01-22', checkOut: '2024-01-24', amount: '\$240', status: 'Confirmed'),
  ];

  List<Booking> get _filteredBookings => _bookings.where((booking) {
    final searchLower = _searchTerm.toLowerCase();
    return booking.guest.toLowerCase().contains(searchLower) ||
        booking.room.toLowerCase().contains(searchLower);
  }).toList();

  Widget _getStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      // case 'Confirmed':
      //   bgColor = AppColors.confirmedBg;
      //   textColor = AppColors.confirmedGreen;
      //   icon = AppIcons.checkCircle;
      //   break;
      // case 'Pending':
      //   bgColor = AppColors.pendingBg;
      //   textColor = AppColors.pendingYellow;
      //   icon = AppIcons.clock;
      //   break;
      // case 'Cancelled':
      //   bgColor = AppColors.cancelledBg;
      //   textColor = AppColors.cancelledRed;
      //   icon = AppIcons.xCircle;
      //   break;
      default:
        bgColor = AppColors.gray100;
        textColor = AppColors.gray700;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: isMobile
          ? Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterButton(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildSearchBar()),
                const SizedBox(width: 16),
                _buildFilterButton(),
              ],
            ),
    );
  }

  Widget _buildSearchBar() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _searchTerm = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search bookings...',
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: Icon(AppIcons.search, size: 18, color: AppColors.gray400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.green600, width: 2),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.gray200),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(AppIcons.filter, size: 18, color: AppColors.gray600),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Filter',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray700),
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }

  List<DataColumn> get _tableColumns {
    return const [
      DataColumn(label: Text('BOOKING ID', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('GUEST', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('ROOM', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('CHECK-IN', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('CHECK-OUT', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
    ];
  }

  List<DataRow> get _tableRows {
    return _filteredBookings.map((booking) {
      return DataRow(
        cells: [
          DataCell(Text('#${booking.id}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900, fontSize: 13))),
          DataCell(Text(booking.guest, style: const TextStyle(color: AppColors.gray900, fontSize: 13))),
          DataCell(Text('Room ${booking.room}', style: const TextStyle(color: AppColors.gray600, fontSize: 13))),
          DataCell(Text(booking.checkIn, style: const TextStyle(color: AppColors.gray600, fontSize: 13))),
          DataCell(Text(booking.checkOut, style: const TextStyle(color: AppColors.gray600, fontSize: 13))),
          DataCell(Text(booking.amount, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900, fontSize: 13))),
          DataCell(_getStatusBadge(booking.status)),
          DataCell(
            IconButton(
              icon: Icon(Icons.remove_red_eye, size: 16, color: AppColors.green600),
              onPressed: () {},
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildContent(double screenWidth, bool isMobile) {
    return SingleChildScrollView(
      padding: kPagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Visual effect handled by Stack in build method)
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Pages', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    Text(' / ', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                    Text('Booking Management', style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
                    Text(' / ', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                    Text('All Bookings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('All Bookings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('View and manage all reservations', style: TextStyle(fontSize: 14, color: AppColors.green100)),
              ],
            ),
          ),

          _buildSearchAndFilter(isMobile),

          // Bookings Table Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(color: AppColors.gray100),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith((states) => AppColors.gray50),
                columnSpacing: 32,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 60,
                columns: _tableColumns,
                rows: _tableRows,
              ),
            ),
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
              title: const Text('All Bookings'),
              backgroundColor: AppColors.green600,
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
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 256,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF065F46)], // from-green-600 via-green-500 to-emerald-600
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Main Content
                Positioned.fill(
                  child: _buildContent(screenWidth, isMobile),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
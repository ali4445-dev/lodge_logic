import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


// Mock Data Structure
class Room {
  final int id;
  final String number;
  final String type;
  final int floor;
  final int capacity;
  final String price;
  final String status; // Available, Occupied, Maintenance

  Room({
    required this.id, required this.number, required this.type,
    required this.floor, required this.capacity, required this.price,
    required this.status,
  });
}

class EditRoomScreen extends StatefulWidget {
  const EditRoomScreen({super.key});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  String _searchTerm = '';

  final List<Room> _rooms = [
    Room(id: 1, number: '101', type: 'Deluxe', floor: 1, capacity: 2, price: '\$120', status: 'Available'),
    Room(id: 2, number: '102', type: 'Standard', floor: 1, capacity: 2, price: '\$80', status: 'Occupied'),
    Room(id: 3, number: '201', type: 'Suite', floor: 2, capacity: 4, price: '\$200', status: 'Available'),
    Room(id: 4, number: '202', type: 'Deluxe', floor: 2, capacity: 2, price: '\$120', status: 'Maintenance'),
  ];

  List<Room> get _filteredRooms => _rooms.where((room) {
    final searchLower = _searchTerm.toLowerCase();
    return room.number.toLowerCase().contains(searchLower) ||
        room.type.toLowerCase().contains(searchLower);
  }).toList();

  Map<String, dynamic> _getStatus(String status) {
    switch (status) {
      case 'Available': return {'bg': AppColors.green100, 'text': AppColors.green600, 'icon': AppIcons.check};
      case 'Occupied': return {'bg': AppColors.blue100, 'text': AppColors.blue600, 'icon': AppIcons.x};
      case 'Maintenance': return {'bg': AppColors.yellow100, 'text': AppColors.yellow600, 'icon': AppIcons.alertCircle};
      default: return {'bg': AppColors.gray100, 'text': AppColors.gray600, 'icon': AppIcons.x};
    }
  }

  Widget _buildStatusBadge(String status) {
    final statusMap = _getStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusMap['bg'] as Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusMap['icon'] as IconData, size: 12, color: statusMap['text'] as Color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusMap['text'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> get _tableColumns {
    return const [
      DataColumn(label: Text('ROOM #', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('TYPE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('FLOOR', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('CAPACITY', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('PRICE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
      DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.gray500))),
    ];
  }

  List<DataRow> get _tableRows {
    return _filteredRooms.map((room) {
      return DataRow(
        cells: [
          DataCell(Text(room.number, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900, fontSize: 13))),
          DataCell(Text(room.type, style: const TextStyle(color: AppColors.gray900, fontSize: 13))),
          DataCell(Text(room.floor.toString(), style: const TextStyle(color: AppColors.gray600, fontSize: 13))),
          DataCell(Text(room.capacity.toString(), style: const TextStyle(color: AppColors.gray600, fontSize: 13))),
          DataCell(Text(room.price, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900, fontSize: 13))),
          DataCell(_buildStatusBadge(room.status)),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(AppIcons.edit, size: 16, color: AppColors.orange600),
                  onPressed: () => print('Edit room ${room.id}'),
                  style: IconButton.styleFrom(backgroundColor: AppColors.orange600.withOpacity(0.05)),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(AppIcons.trash, size: 16, color: AppColors.red600),
                  onPressed: () => print('Delete room ${room.id}'),
                  style: IconButton.styleFrom(backgroundColor: AppColors.red600.withOpacity(0.05)),
                ),
              ],
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
          // Header
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Text('Pages / Room Management', style: TextStyle(color: Colors.white.withOpacity(0.9)))]),
                const SizedBox(height: 8),
                const Text('All Rooms', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('View, edit, and manage all guest rooms', style: TextStyle(fontSize: 14, color: AppColors.yellow100)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tools Bar
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (val) => setState(() => _searchTerm = val),
                  decoration: InputDecoration(
                    hintText: 'Search by room number or type...',
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
                  onPressed: () => print('Navigate to Add Room'),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Room', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange600,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Rooms Table Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              border: Border.all(color: AppColors.gray100),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith((states) => AppColors.gray50),
                columnSpacing: 24,
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
              title: const Text('All Rooms'),
              backgroundColor: AppColors.orange600,
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
                        colors: [AppColors.orange600, Color(0xFFF97316), AppColors.yellow600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(child: _buildContent(screenWidth, isMobile)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
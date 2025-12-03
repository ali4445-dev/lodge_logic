import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


class EditRoomFormScreen extends StatefulWidget {
  const EditRoomFormScreen({super.key});

  @override
  State<EditRoomFormScreen> createState() => _EditRoomFormScreenState();
}

class _EditRoomFormScreenState extends State<EditRoomFormScreen> {
  // Mock initial data for an existing room
  String _roomNumber = '101';
  String _roomType = 'deluxe';
  String _floor = '1';
  String _capacity = '2';
  String _price = '120';
  String _size = '250';
  String _description = 'Spacious deluxe room with ocean view';
  String _guestHouse = '1'; // Selected Guest House ID

  final List<Map<String, String>> _guestHouses = [
    {'id': '1', 'name': 'Sunny Side Guest House'},
    {'id': '2', 'name': 'Ocean View Villa'},
  ];

  final List<String> _roomTypes = ['standard', 'deluxe', 'suite'];

  void _handleUpdate() {
    print('Room 101 updated: Type: $_roomType, Price: \$$_price');
    // In a real app, navigate back to the room list
    // Navigator.pop(context);
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
    String keyboardType = 'text',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.gray700),
              const SizedBox(width: 8),
              Text(
                '$label *',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray700),
              ),
            ],
          ),
        ),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType == 'number' ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.gray200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.orange600, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? currentValue,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.gray700),
              const SizedBox(width: 8),
              Text(
                '$label *',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray700),
              ),
            ],
          ),
        ),
        DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.gray200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.orange600, width: 2)),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item[0].toUpperCase() + item.substring(1)), // Capitalize first letter
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildContent(double screenWidth) {
    final isWide = screenWidth > 600;
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
                Row(children: [Text('Pages / Room Management / Edit', style: TextStyle(color: Colors.white.withOpacity(0.9)))]),
                const SizedBox(height: 8),
                Text('Edit Room $_roomNumber', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('Update the details for this room', style: TextStyle(fontSize: 14, color: AppColors.yellow100)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Form Card
          Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              border: Border.all(color: AppColors.gray100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray900),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: isWide ? 2 : 1,
                  childAspectRatio: isWide ? 3.5 : 4,
                  mainAxisSpacing: 24.0,
                  crossAxisSpacing: 24.0,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Guest House Dropdown
                    _buildDropdownField(
                      label: 'Guest House',
                      currentValue: _guestHouse,
                      icon: AppIcons.building,
                      items: _guestHouses.map((e) => e['id']!).toList(),
                      onChanged: (val) => setState(() => _guestHouse = val!),
                    ),
                    _buildTextField(label: 'Room Number', initialValue: _roomNumber, icon: AppIcons.bedDouble, onChanged: (val) => _roomNumber = val),
                    _buildDropdownField(
                      label: 'Room Type',
                      currentValue: _roomType,
                      icon: AppIcons.bedDouble,
                      items: _roomTypes,
                      onChanged: (val) => setState(() => _roomType = val!),
                    ),
                    _buildTextField(label: 'Floor', initialValue: _floor, icon: Icons.stairs_rounded, onChanged: (val) => _floor = val, keyboardType: 'number'),
                    _buildTextField(label: 'Max Capacity', initialValue: _capacity, icon: AppIcons.users, onChanged: (val) => _capacity = val, keyboardType: 'number'),
                    _buildTextField(label: 'Price per Night', initialValue: _price, icon: AppIcons.dollar, onChanged: (val) => _price = val, keyboardType: 'number'),
                    _buildTextField(label: 'Size (sq ft)', initialValue: _size, icon: AppIcons.square, onChanged: (val) => _size = val, keyboardType: 'number'),
                    const SizedBox.shrink(), // Empty slot
                  ],
                ),
                const SizedBox(height: 24),
                // Description (Full width)
                _buildTextField(label: 'Description', initialValue: _description, icon: Icons.description_rounded, onChanged: (val) => _description = val, maxLines: 4),
                const SizedBox(height: 32),
                // Submit Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange600,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Update Room',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context), // Go back
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.gray100,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
              title: const Text('Edit Room'),
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
                Positioned.fill(child: _buildContent(screenWidth)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
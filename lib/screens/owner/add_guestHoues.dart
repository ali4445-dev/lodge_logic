import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';
import 'package:lodge_logic/services/guest_house_service.dart';
import 'package:lodge_logic/services/image_service.dart';

class AddGuestHouseScreen extends StatefulWidget {
  const AddGuestHouseScreen({super.key});

  @override
  State<AddGuestHouseScreen> createState() => _AddGuestHouseScreenState();
}

class _AddGuestHouseScreenState extends State<AddGuestHouseScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController amenityController = TextEditingController();

  int numberOfRooms = 0;
  List<int> roomList = [];
  List<String> amenities = [];

  bool hasBalcony = false;
  bool hasKitchen = false;
  bool hasWifi = false;
  bool hasParking = false;
  bool hasAC = false;

  List<Uint8List> selectedImages = [];

  void _addAmenity() {
    final amenity = amenityController.text.trim();
    if (amenity.isEmpty) return;

    setState(() {
      amenities.add(amenity);
      amenityController.clear();
    });
  }

  Widget _amenityChip(String amenity, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.indigo600,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo600.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amenity,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                amenities.removeAt(index);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: amenityController,
              decoration: InputDecoration(
                hintText: "e.g., Pool, Gym, Spa",
                hintStyle: const TextStyle(color: AppColors.gray400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
              onFieldSubmitted: (_) => _addAmenity(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppColors.indigo600, size: 28),
              onPressed: _addAmenity,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRoomCreation(int n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.gray50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Confirm Rooms",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Do you want to create $n rooms?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "No",
              style: TextStyle(color: AppColors.gray700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                numberOfRooms = n;
                roomList = List.generate(n, (i) => i + 1);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    GuestHouseService.addGuestHouse(
      GuestHouse(
        name: nameController.text,
        rooms: int.parse(roomController.text),
        hasBalcony: hasBalcony,
        hasKitchen: hasKitchen,
        hasWifi: hasWifi,
        hasParking: hasParking,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String hint = '',
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
    VoidCallback? onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ),
        Material(
          elevation: 1.5,
          shadowColor: AppColors.gray300,
          borderRadius: BorderRadius.circular(12),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLines,
            onFieldSubmitted: (_) => onSubmit?.call(),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.indigo600,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitySwitch(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                label == 'Balcony'
                    ? Icons.balcony
                    : label == 'Kitchen'
                        ? Icons.kitchen
                        : label == 'Wifi'
                            ? Icons.wifi
                            : label == 'Parking'
                                ? Icons.local_parking
                                : Icons.ac_unit,
                color: AppColors.indigo600,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.indigo600,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guest House Images',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            List<Uint8List> pickedImages =
                await ImageService.pickMultipleImages();
            if (pickedImages.isNotEmpty) {
              setState(() => selectedImages.addAll(pickedImages));
            }
          },
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.upload, size: 40, color: AppColors.gray400),
                  SizedBox(height: 8),
                  Text(
                    'Tap to upload images (PNG, JPG up to 10MB)',
                    style: TextStyle(color: AppColors.gray500),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(selectedImages.length, (index) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    selectedImages[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => setState(() => selectedImages.removeAt(index)),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
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
              title: const Text('Add Guest House'),
              backgroundColor: AppColors.indigo600,
              elevation: 2,
            )
          : null,
      drawer: isMobile ? const CustomSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          if (!isMobile) const CustomSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Guest House Name',
                    controller: nameController,
                    hint: 'Enter name',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Address',
                    controller: addressController,
                    hint: '123 Main Street',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'City',
                    controller: cityController,
                    hint: 'Enter city name',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Country',
                    controller: countryController,
                    hint: 'Enter country name',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Street Address',
                    controller: streetController,
                    hint: 'Enter street address',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Number of Rooms',
                    controller: roomController,
                    hint: 'Enter number',
                    inputType: TextInputType.number,
                    onSubmit: () {
                      int n = int.tryParse(roomController.text) ?? 0;
                      if (n > 0) _confirmRoomCreation(n);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Starting Price',
                    controller: priceController,
                    hint: 'Price Per night(per room)',
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  // Rooms display
                  // if (roomList.length > 0)
                  //   Wrap(
                  //     spacing: 12,
                  //     runSpacing: 12,
                  //     children: roomList
                  //         .map(
                  //           (room) => Container(
                  //             width: 100,
                  //             padding: const EdgeInsets.all(12),
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(12),
                  //               border: Border.all(color: AppColors.gray200),
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 const Icon(
                  //                   Icons.meeting_room,
                  //                   size: 32,
                  //                   color: AppColors.indigo600,
                  //                 ),
                  //                 const SizedBox(height: 4),
                  //                 Text(
                  //                   'Room $room',
                  //                   style: const TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: AppColors.gray900,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         )
                  //         .toList(),
                  //   ),
                  const SizedBox(height: 24),
                  // Dynamic Amenities Input
                  const Text(
                    'Add Custom Amenities',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAmenitiesInput(),
                  // Display Added Amenities
                  if (amenities.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Selected Amenities:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: amenities.asMap().entries.map((entry) {
                        return _amenityChip(entry.value, entry.key);
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  // Amenities
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Other Amenities',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAmenitySwitch(
                          'Balcony',
                          hasBalcony,
                          (v) => setState(() => hasBalcony = v),
                        ),
                        _buildAmenitySwitch(
                          'Kitchen',
                          hasKitchen,
                          (v) => setState(() => hasKitchen = v),
                        ),
                        _buildAmenitySwitch(
                          'Wifi',
                          hasWifi,
                          (v) => setState(() => hasWifi = v),
                        ),
                        _buildAmenitySwitch(
                          'Parking',
                          hasParking,
                          (v) => setState(() => hasParking = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Image picker
                  _buildImagePicker(),
                  const SizedBox(height: 32),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.indigo600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Register Guest House',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

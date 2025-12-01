import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/services/guest_house_service.dart';
import 'package:lodge_logic/services/image_service.dart';

class AddGuestHouseScreen extends StatefulWidget {
  const AddGuestHouseScreen({super.key});

  @override
  State<AddGuestHouseScreen> createState() => _AddGuestHouseScreenState();
}

class _AddGuestHouseScreenState extends State<AddGuestHouseScreen> {
  int numberOfRooms = 0;
  List<int> roomList = [];

  bool hasBalcony = false;
  bool hasKitchen = false;
  bool hasWifi = false;
  bool hasParking = false;

  List<Uint8List> selectedImages = [];

  final TextEditingController roomController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    "Add Guest House",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: const Text(
                    "Fill the property details below",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 25),

                // LOCATION PICKER
                _header("Select Location"),
                InkWell(
                  onTap: () {
                    // Later: open Google Maps Picker
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _whiteBox(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 28,
                          color: Colors.blue.shade900,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Pick location",
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // GUEST HOUSE NAME
                _header("Guest House Name"),
                _textInput(nameController, "Royal Palace Guest House"),

                const SizedBox(height: 20),

                // NUMBER OF ROOMS
                _header("Number of Rooms"),
                _textInput(
                  roomController,
                  "Enter number",
                  numberInput: true,
                  onSubmit: () {
                    if (roomController.text.isEmpty) return;

                    int n = int.tryParse(roomController.text) ?? 0;
                    if (n <= 0) return;

                    _confirmRoomCreation(n);
                  },
                ),

                const SizedBox(height: 20),

                // ROOM LIST DISPLAY
                if (roomList.isNotEmpty) _header("Rooms Created"),
                if (roomList.isNotEmpty)
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: roomList.map((room) {
                      return _roomIcon(room);
                    }).toList(),
                  ),

                const SizedBox(height: 25),

                // BALCONY & KITCHEN TOGGLES
                _header("Amenities"),
                const SizedBox(height: 10),

                _toggleOption(
                  "Balcony",
                  hasBalcony,
                  (v) => setState(() => hasBalcony = v),
                ),
                const SizedBox(height: 10),
                _toggleOption(
                  "Kitchen",
                  hasKitchen,
                  (v) => setState(() => hasKitchen = v),
                ),
                const SizedBox(height: 10),
                _toggleOption(
                  "Wifi",
                  hasWifi,
                  (v) => setState(() => hasWifi = v),
                ),
                 const SizedBox(height: 10),

                _toggleOption(
                  "Parking",
                  hasParking,
                  (v) => setState(() => hasParking = v),
                ),

                const SizedBox(height: 25),

                // UPLOAD IMAGES SECTION
                _header("Guest House Pictures (Mandatory)"),
                GestureDetector(
                  onTap: () async {
                    List<Uint8List> pickedImages =
                        await ImageService.pickMultipleImages();

                    if (pickedImages != null) {
                      print("Image selected: ${pickedImages[0]}");
                      setState(() {
                        selectedImages.addAll(pickedImages);
                      });
                    }
                    // Later: image picker
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.blue.shade900, width: 1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.blue.shade900,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Tap to upload images",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(selectedImages.length, (index) {
                    return Stack(
                      children: [
                        // --- IMAGE THUMBNAIL ---
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.memory(
                              selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // --- DELETE BUTTON ---
                        Positioned(
                          right: 3,
                          top: 3,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 215, 93, 93),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                SizedBox(height: 30),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Register Guest House",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------
  // COMPONENTS
  // -------------------------------------

  BoxDecoration _whiteBox() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(18),
    );
  }

  Widget _header(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _textInput(
    TextEditingController controller,
    String hint, {
    bool numberInput = false,
    VoidCallback? onSubmit,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: _whiteBox(),
      child: TextField(
        controller: controller,
        keyboardType: numberInput ? TextInputType.number : TextInputType.text,
        onSubmitted: (_) => onSubmit?.call(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
        ),
      ),
    );
  }

  // ROOM ICON CARD
  Widget _roomIcon(int roomNumber) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(Icons.meeting_room, size: 40, color: Colors.blue.shade900),
          const SizedBox(height: 8),
          Text(
            "Room $roomNumber",
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // TOGGLE OPTION
  Widget _toggleOption(String label, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _whiteBox(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue.shade900,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue.shade700,
          ),
        ],
      ),
    );
  }

  // CONFIRMATION DIALOG
  void _confirmRoomCreation(int n) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Confirm Rooms"),
          content: Text("Do you want to create $n rooms?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  numberOfRooms = n;
                  roomList = List.generate(n, (i) => i + 1);
                });
                Navigator.pop(ctx);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

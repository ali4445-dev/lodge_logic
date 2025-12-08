import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lodge_logic/global.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';
import 'package:lodge_logic/services/image_service.dart';
import 'package:lodge_logic/services/guest_house_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddGuestHouseScreen extends StatefulWidget {
  const AddGuestHouseScreen({super.key});
  

  @override
  State<AddGuestHouseScreen> createState() => _AddGuestHouseScreenState();
}

class _AddGuestHouseScreenState extends State<AddGuestHouseScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController amenityController = TextEditingController();

  int numberOfRooms = 0;
  List<int> roomList = [];
  List<String> allAmenities = [];
  bool showAmenityInput = false;

  

  bool hasBalcony = false;
  bool hasKitchen = false;
  bool hasWifi = false;
  bool hasParking = false;
  bool hasAC = false;

  List<Uint8List> selectedImages = [];
  bool isLoading = false;
  GuestHouse? existingGuestHouse;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (existingGuestHouse == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is GuestHouse) {
        existingGuestHouse = args;
        _populateFields();
      }
    }
  }

  void _populateFields() {
    if (existingGuestHouse == null) return;
    
    nameController.text = existingGuestHouse!.name;
    cityController.text = existingGuestHouse!.city;
    countryController.text = existingGuestHouse!.country;
    streetController.text = existingGuestHouse!.address ?? '';
    descriptionController.text = existingGuestHouse!.description ?? '';
    roomController.text = existingGuestHouse!.totalRooms.toString();
    
    if (existingGuestHouse!.amenities != null) {
      for (var amenity in existingGuestHouse!.amenities!) {
        if (amenity == 'Balcony') hasBalcony = true;
        else if (amenity == 'Kitchen') hasKitchen = true;
        else if (amenity == 'WiFi') hasWifi = true;
        else if (amenity == 'Parking') hasParking = true;
        else if (amenity == 'Air Conditioning') hasAC = true;
        else allAmenities.add(amenity);
      }
    }
    
    setState(() {});
  }

  void _addAmenity() {
    final amenity = amenityController.text.trim();
    if (amenity.isEmpty) return;

    setState(() {
      allAmenities.add(amenity);
      amenityController.clear();
    });
  }

  void _removeAmenity(int index) {
    setState(() {
      allAmenities.removeAt(index);
    });
  }

  List<String> _getAllAmenitiesSelected() {
    List<String> amenities = [...allAmenities];
    if (hasBalcony) amenities.add('Balcony');
    if (hasKitchen) amenities.add('Kitchen');
    if (hasWifi) amenities.add('WiFi');
    if (hasParking) amenities.add('Parking');
    if (hasAC) amenities.add('Air Conditioning');
    return amenities;
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
            child: Text("No", style: TextStyle(color: AppColors.gray700)),
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
              backgroundColor: AppColors.primaryTeal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (nameController.text.isEmpty ||
        cityController.text.isEmpty ||
        countryController.text.isEmpty ||
        streetController.text.isEmpty ||
        roomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Upload images if selected
      List<String>? imageUrls = existingGuestHouse?.images;
      if (selectedImages.isNotEmpty) {
        imageUrls = [];
        for (int i = 0; i < selectedImages.length; i++) {
          try {
            final fileName = 'guesthouse_${user.id}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            final imageUrl = await ImageService.uploadImage(
              selectedImages[i],
              fileName,
            );
            if (imageUrl != null) {
              imageUrls.add(imageUrl);
            }
          } catch (e) {
            print('Error uploading image $i: $e');
          }
        }
      }

      final userEmail = user.email?.trim().toLowerCase();
      final userResult = await Supabase.instance.client
          .from('users')
          .select('user_id')
          .eq('email', userEmail!)
          .maybeSingle();
      
      if (userResult == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ User not found. Email: $userEmail'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final guestHouse = GuestHouse(
        guesthouseId: existingGuestHouse?.guesthouseId,
        ownerId: userResult['user_id'] as int,
        name: nameController.text.trim(),
        address: streetController.text.trim(),
        city: cityController.text.trim(),
        country: countryController.text.trim(),
        totalRooms: int.parse(roomController.text),
        description: descriptionController.text.trim(),
        amenities: _getAllAmenitiesSelected(),
        images: imageUrls,
        isActive: existingGuestHouse?.isActive ?? true,
      );

      final success = existingGuestHouse != null
          ? await GuestHouseService.updateGuestHouse(guestHouse)
          : await GuestHouseService.addGuestHouse(guestHouse);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(existingGuestHouse != null
                  ? '✅ Guest House updated successfully!'
                  : '✅ Guest House registered successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(existingGuestHouse != null
                  ? '❌ Failed to update guest house'
                  : '❌ Failed to register guest house'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error in _handleSubmit: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.gray900,
           
          ),
        ),
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
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            onFieldSubmitted: (_) => onSubmit?.call(),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityToggle(String label, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
             
              borderRadius: BorderRadius.circular(16),
             
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTeal.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
           
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gray700,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.gray700,
            
            inactiveThumbColor:AppColors.gray500 ,
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(String amenity, int index, [bool isCustom = true]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 0, 159, 146), Color.fromARGB(255, 0, 91, 84).withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal600.withOpacity(0.3),
            blurRadius: 6,
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
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          // Only show delete button for custom amenities
          if (isCustom)
            GestureDetector(
              onTap: () => _removeAmenity(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
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
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            List<Uint8List> pickedImages = await ImageService.pickMultipleImages();
            if (pickedImages.isNotEmpty) {
              setState(() => selectedImages.addAll(pickedImages));
            }
          },
          child: Container(
            width: double.infinity,
            height: 150,
            decoration:BoxDecoration(
             
              borderRadius: BorderRadius.circular(16),
             
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTeal.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.upload, size: 40, color: AppColors.primaryTeal),
                  SizedBox(height: 8),
                  Text(
                    'Tap to upload images',
                    style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (selectedImages.isNotEmpty)
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
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 14),
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
     mq = MediaQuery.of(context).size;
    final isMobile = mq!.width < kMobileBreakpoint;

    return Scaffold(
      backgroundColor:AppColors.teal100,
      appBar: isMobile
          ? AppBar(
              title: Text(existingGuestHouse != null ? 'Update Guest House' : 'Add Guest House'),
              backgroundColor:AppColors.primaryTeal,
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
                  _buildSectionHeader(existingGuestHouse != null
                      ? '🏠 Update Guest House Information'
                      : '🏠 Guest House Information'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Guest House Name',
                          controller: nameController,
                          hint: 'e.g., Sunset Resort',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Description',
                          controller: descriptionController,
                          hint: 'Describe your property',
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Location Section
                  _buildSectionHeader('🌍 Location Details'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Country',
                          controller: countryController,
                          hint: 'Enter country',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'City',
                          controller: cityController,
                          hint: 'Enter city',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Street',
                          controller: streetController,
                          hint: 'Enter street name',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Property Details Section
                  _buildSectionHeader('🛏️ Room Details'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        
                        _buildTextField(
                          label: 'Number of Rooms',
                          controller: roomController,
                          hint: 'Enter number ',
                          inputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onSubmit: () {
                            // int n = int.tryParse(roomController.text) ?? 0;
                            // if (n > 0) _confirmRoomCreation(n);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Price Per Night(PKR)',
                          controller: priceController,
                          hint: 'Enter price',
                          inputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amenities Section
                  _buildSectionHeader('✨ ##Amenities'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Standard Amenities Toggle
                        const Text(
                          'Select Standard Amenities:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAmenityToggle('Balcony', hasBalcony, (v) => setState(() => hasBalcony = v)),
                        _buildAmenityToggle('Kitchen', hasKitchen, (v) => setState(() => hasKitchen = v)),
                        _buildAmenityToggle('WiFi', hasWifi, (v) => setState(() => hasWifi = v)),
                        _buildAmenityToggle('Parking', hasParking, (v) => setState(() => hasParking = v)),
                        _buildAmenityToggle('Air Conditioning', hasAC, (v) => setState(() => hasAC = v)),
                        const SizedBox(height: 16),

                        // Custom Amenities Button
                        Center(
                          child: SizedBox(
                            width: mq!.width * 0.6,
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => showAmenityInput = !showAmenityInput),
                              icon: const Icon(Icons.add),
                              label: Text(showAmenityInput ? 'Hide Custom Amenities' : 'Add Custom Amenities'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:AppColors.primaryTeal,
                                foregroundColor:Colors.white,
                               
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ),

                        // Custom Amenities Input (shown only if user clicks add)
                        if (showAmenityInput) ...[
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.indigo100, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.tealAccent600.withOpacity(0.1),
                                  blurRadius: 8,
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
                                      hintText: 'e.g., Pool, Gym, Spa',
                                      hintStyle: const TextStyle(color: AppColors.gray400),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    onFieldSubmitted: (_) => _addAmenity(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.add_circle, color: AppColors.tealAccent600, size: 28),
                                    onPressed: _addAmenity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Display All Selected Amenities
                        if (_getAllAmenitiesSelected().isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Selected Amenities:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _getAllAmenitiesSelected().asMap().entries.map((entry) {
                              String amenity = entry.value;
                              // Check if it's a custom amenity or standard one
                              bool isCustom = allAmenities.contains(amenity);
                              return _buildAmenityChip(amenity, isCustom ? allAmenities.indexOf(amenity) : -1, isCustom);
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Image Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildImagePicker(),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          disabledBackgroundColor: AppColors.gray400,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : Text(
                                existingGuestHouse != null
                                    ? 'Update Guest House'
                                    : 'Register Guest House',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    countryController.dispose();
    streetController.dispose();
    descriptionController.dispose();
    roomController.dispose();
    priceController.dispose();
    amenityController.dispose();
    super.dispose();
  }
}

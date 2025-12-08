import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/models/room.dart';
import 'package:lodge_logic/services/room_service.dart';

class EditRoomScreen extends StatefulWidget {
  final GuestHouse guestHouse;
  final int roomNumber;

  const EditRoomScreen({
    super.key,
    required this.guestHouse,
    required this.roomNumber,
  });

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _floorController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _status = 'available';
  bool _isAvailable = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _roomNumberController.text = widget.roomNumber.toString();
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _floorController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final room = Room(
        guesthouseId: widget.guestHouse.guesthouseId,
        roomNumber: _roomNumberController.text,
        floor: int.tryParse(_floorController.text),
        capacity: int.tryParse(_capacityController.text),
        price: double.tryParse(_priceController.text),
        description: _descriptionController.text,
        isAvailable: _isAvailable,
        status: _status,
      );

      final success = await RoomService.addRoom(room);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Room saved successfully'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Failed to save room'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Configure Room ${widget.roomNumber}'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.guestHouse.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _roomNumberController,
                    label: 'Room Number',
                    hint: 'e.g., 101',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _floorController,
                    label: 'Floor',
                    hint: 'e.g., 1',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _capacityController,
                    label: 'Capacity',
                    hint: 'Number of guests',
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Price per Night',
                    hint: 'e.g., 5000',
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Room description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  // DropdownButtonFormField<String>(
                  //   value: _status,
                  //   decoration: InputDecoration(
                  //     labelText: 'Status',
                  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  //   ),
                  //   items: const [
                  //     DropdownMenuItem(value: 'available', child: Text('Available')),
                  //     DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                  //     DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                  //   ],
                  //   onChanged: (value) => setState(() => _status = value!),
                  // ),
                  // const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Is Available'),
                    value: _isAvailable,
                    onChanged: (value) => setState(() => _isAvailable = value),
                    activeColor: Colors.teal,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _saveRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Save Room',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}

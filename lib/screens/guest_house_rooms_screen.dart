import 'package:flutter/material.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/models/room.dart';
import 'package:lodge_logic/models/booking.dart';
import 'package:lodge_logic/services/booking_service.dart';
import 'package:lodge_logic/utils/app_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuestHouseRoomsScreen extends StatefulWidget {
  final GuestHouse guestHouse;

  const GuestHouseRoomsScreen({super.key, required this.guestHouse});

  @override
  State<GuestHouseRoomsScreen> createState() => _GuestHouseRoomsScreenState();
}

class _GuestHouseRoomsScreenState extends State<GuestHouseRoomsScreen> {
  List<Room> _rooms = [];
  List<Room> _filteredRooms = [];
  bool _loading = true;
  final _searchController = TextEditingController();
  double? _maxPrice;
  String? _status;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await Supabase.instance.client
          .from('room')
          .select()
          .eq('guesthouse', widget.guestHouse.guesthouseId!);

      setState(() {
        _rooms = (rooms as List).map((e) => Room.fromJson(e)).toList();
        _filteredRooms = _rooms;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredRooms = _rooms.where((room) {
        if (_searchController.text.isNotEmpty &&
            !(room.roomNumber?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false)) {
          return false;
        }
        if (_maxPrice != null && (room.price ?? 0) > _maxPrice!) return false;
        if (_status != null && room.status != _status) return false;
        return true;
      }).toList();
    });
  }

  Future<void> _bookRoom(Room room) async {
    // First ask for email
    final email = await showDialog<String>(
      context: context,
      builder: (context) => _EmailDialog(),
    );
    
    if (email == null || email.isEmpty) return;
    
    // Set AppState email
    AppState.userEmail = email;
    
    DateTime? checkIn;
    DateTime? checkOut;
    int guestsCount = 1;
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _BookingDialog(
        room: room,
        onBook: (ci, co, gc) {
          checkIn = ci;
          checkOut = co;
          guestsCount = gc;
        },
      ),
    );
    
    if (result == null) return;
    
    checkIn = result['checkIn'];
    checkOut = result['checkOut'];
    guestsCount = result['guestsCount'];
    
    final nights = checkOut!.difference(checkIn!).inDays;
    final amount = (room.price ?? 0) * nights;
    
    final booking = Booking(
      guestId: null,
      guesthouseId: widget.guestHouse.guesthouseId,
      roomId: room.roomId,
      checkIn: checkIn,
      checkOut: checkOut,
      roomsCount: 1,
      guestsCount: guestsCount,
      amount: amount,
      status: 'pending',
    );
    
    final success = await BookingService.createBooking(booking);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room ${room.roomNumber} booked successfully!')),
      );
      _loadRooms();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error booking room')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.guestHouse.name),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.guestHouse.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.guestHouse.city}, ${widget.guestHouse.country}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilters(),
                  decoration: InputDecoration(
                    hintText: 'Search rooms...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: _showFilterDialog,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRooms.isEmpty
                    ? const Center(child: Text('No rooms found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredRooms.length,
                        itemBuilder: (context, index) {
                          return _buildRoomCard(_filteredRooms[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    final isAvailable = room.status == 'available';
    final colors = [
      [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
      [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
      [const Color(0xFFEC4899), const Color(0xFFDB2777)],
      [const Color(0xFF10B981), const Color(0xFF059669)],
    ];
    final colorPair = colors[(room.roomId ?? 0) % colors.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colorPair),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.door_front_door, size: 48, color: Colors.white),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Occupied',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Room ${room.roomNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (room.price != null)
                    Text(
                      '\$${room.price}/night',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (room.capacity != null)
                    Text(
                      'Capacity: ${room.capacity}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showRoomDetails(room),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorPair[1],
                            side: BorderSide(color: colorPair[1]),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('View', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isAvailable ? () => _bookRoom(room) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorPair[1],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('Book', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRoomDetails(Room room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Room ${room.roomNumber} Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Price', '\$${room.price ?? 'N/A'}/night'),
              _detailRow('Capacity', '${room.capacity ?? 'N/A'} guests'),
              _detailRow('Floor', '${room.floor ?? 'N/A'}'),
              _detailRow('Status', room.status),
              if (room.description != null) ...[
                const SizedBox(height: 8),
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(room.description!),
              ],
              if (room.amenities != null && room.amenities!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: room.amenities!
                      .map((a) => Chip(label: Text(a, style: TextStyle(fontSize: 12))))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Rooms'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['available', 'occupied', 'maintenance']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _status = v),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Max Price'),
              keyboardType: TextInputType.number,
              onChanged: (v) => _maxPrice = double.tryParse(v),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _status = null;
                _maxPrice = null;
              });
              _applyFilters();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              _applyFilters();
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}


class _BookingDialog extends StatefulWidget {
  final Room room;
  final Function(DateTime, DateTime, int) onBook;

  const _BookingDialog({required this.room, required this.onBook});

  @override
  State<_BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<_BookingDialog> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guestsCount = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Book Room ${widget.room.roomNumber}'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Check-in Date'),
              subtitle: Text(_checkIn?.toString().split(' ')[0] ?? 'Select date'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _checkIn = date);
              },
            ),
            ListTile(
              title: const Text('Check-out Date'),
              subtitle: Text(_checkOut?.toString().split(' ')[0] ?? 'Select date'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _checkIn?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1)),
                  firstDate: _checkIn ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _checkOut = date);
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Number of Guests'),
              keyboardType: TextInputType.number,
              onChanged: (v) => _guestsCount = int.tryParse(v) ?? 1,
            ),
            if (_checkIn != null && _checkOut != null) ...[
              const SizedBox(height: 16),
              Text('Total: \$${((widget.room.price ?? 0) * _checkOut!.difference(_checkIn!).inDays).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _checkIn != null && _checkOut != null && _checkOut!.isAfter(_checkIn!)
              ? () {
                  Navigator.pop(context, {
                    'checkIn': _checkIn,
                    'checkOut': _checkOut,
                    'guestsCount': _guestsCount,
                  });
                }
              : null,
          child: const Text('Confirm Booking'),
        ),
      ],
    );
  }
}


class _EmailDialog extends StatefulWidget {
  @override
  State<_EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<_EmailDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _registerAndContinue() async {
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        !_emailController.text.contains('@') ||
        _passwordController.text.isEmpty) {
      return;
    }

    setState(() => _loading = true);

    try {
      // Register user in users table
      await Supabase.instance.client.from('users').insert({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': 'customer',
        'is_approved': true,
      });

      if (mounted) {
        Navigator.pop(context, _emailController.text);
      }
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Register to Book'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'your@email.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _registerAndContinue,
          child: _loading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Continue'),
        ),
      ],
    );
  }
}

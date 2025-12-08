import 'package:flutter/material.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/models/room.dart';
import 'package:lodge_logic/screens/admin/admin_sidebar_widget.dart';
import 'package:lodge_logic/screens/admin/edit_room_screen.dart';
import 'package:lodge_logic/services/guest_house_service.dart';
import 'package:lodge_logic/utils/app_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({super.key});

  @override
  State<RoomManagementScreen> createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  List<GuestHouse> _guestHouses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGuestHouses();
  }

  Future<void> _loadGuestHouses() async {
    try {
      if (AppState.userEmail == null) return;

      final userResult = await Supabase.instance.client
          .from('users')
          .select('user_id')
          .eq('email', AppState.userEmail!)
          .maybeSingle();

      if (userResult == null) return;

      final adminResult = await Supabase.instance.client
          .from('admin')
          .select('admin_id, owner_id')
          .eq('user_id', userResult['user_id'])
          .maybeSingle();

      if (adminResult == null) return;

      final houses = await Supabase.instance.client
          .from('guesthouse')
          .select()
          .eq('owner_id', adminResult['owner_id']);

      setState(() {
        _guestHouses =
            (houses as List).map((e) => GuestHouse.fromJson(e)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      print("Error loading guest houses: $e");
    }
  }

  void _showAddRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => AddRoomDialog(
        guestHouses: _guestHouses,
        onRoomAdded: _loadGuestHouses,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: isMobile
          ? AppBar(
              title: const Text("Room Management"),
              backgroundColor: const Color.fromARGB(255, 93, 104, 122),
              elevation: 0,
            )
          : null,
      drawer: isMobile ? const AdminSidebarWidget(isDrawer: true) : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRoomDialog,
        backgroundColor: const Color.fromARGB(255, 37, 176, 235),
        icon: const Icon(Icons.add_home_work),
        label: const Text("Add Room"),
      ),
      body: Row(
        children: [
          if (!isMobile) const AdminSidebarWidget(),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF334155)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white.withOpacity(0.1),
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: const Icon(Icons.meeting_room,
                      //       color: Colors.white, size: 28),
                      // ),
                      // const SizedBox(width: 16),
                      // const Expanded(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Room Management",
                      //         style: TextStyle(
                      //             fontSize: 28,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white),
                      //       ),
                      //       SizedBox(height: 4),
                      //       Text(
                      //         "Manage rooms across all your guest houses",
                      //         style: TextStyle(
                      //             fontSize: 14, color: Color(0xFFCBD5E1)),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _guestHouses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.home_work_outlined,
                                      size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No guest houses found",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(24),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: isMobile ? 400 : 350,
                                childAspectRatio: 1.1,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: _guestHouses.length,
                              itemBuilder: (context, index) {
                                return _buildGuestHouseCard(
                                    _guestHouses[index]);
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestHouseCard(GuestHouse house) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomListScreen(guestHouse: house),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.meeting_room,
                              size: 14, color: Color(0xFF2563EB)),
                          const SizedBox(width: 4),
                          Text(
                            "${house.totalRooms}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF1E293B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(Icons.home_work,
                        size: 48, color: Colors.white.withOpacity(0.9)),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(house.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E293B))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text("${house.city}, ${house.country}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                        )
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("View Rooms",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward,
                            size: 14, color: Colors.blue[700])
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// ADD ROOM DIALOG — FIXED OVERFLOW WITH SCROLL VIEW
// ---------------------------------------------------------

class AddRoomDialog extends StatefulWidget {
  final List<GuestHouse> guestHouses;
  final VoidCallback onRoomAdded;

  const AddRoomDialog(
      {super.key, required this.guestHouses, required this.onRoomAdded});

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  GuestHouse? _selectedGuestHouse;
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  bool _loading = false;

  Future<void> _addRoom() async {
    if (!_formKey.currentState!.validate() ||
        _selectedGuestHouse == null ||
        _selectedGuestHouse!.guesthouseId == null) return;

    setState(() => _loading = true);

    try {
      final id = _selectedGuestHouse!.guesthouseId!;
      await Supabase.instance.client.from("room").insert({
        "guesthouse": id,
        "room_number": _roomNumberController.text
      });

      await Supabase.instance.client
          .from("guesthouse")
          .update({"total_rooms": _selectedGuestHouse!.totalRooms + 1}).eq(
              "guesthouse_id", id);

      if (mounted) {
        Navigator.pop(context);
        widget.onRoomAdded();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Room added successfully")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Room"),
      content: SingleChildScrollView(   // 🔥 FIX OVERFLOW
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<GuestHouse>(
                value: _selectedGuestHouse,
                items: widget.guestHouses
                    .map((x) => DropdownMenuItem(
                        value: x, child: Text(x.name)))
                    .toList(),
                decoration:
                    const InputDecoration(labelText: "Guest House"),
                validator: (v) =>
                    v == null ? "Select a guest house" : null,
                onChanged: (v) => setState(() {
                  _selectedGuestHouse = v;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roomNumberController,
                decoration: const InputDecoration(labelText: "Room Number"),
                validator: (v) =>
                    v!.isEmpty ? "Enter room number" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: _loading ? null : _addRoom,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("Add")),
      ],
    );
  }
}

// ---------------------------------------------------------
// ROOM LIST SCREEN — ADDED CLOSE BUTTON IN THE HEADER
// ---------------------------------------------------------

class RoomListScreen extends StatelessWidget {
  final GuestHouse guestHouse;

  const RoomListScreen({super.key, required this.guestHouse});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(guestHouse.name),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.home_work,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(guestHouse.name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text("${guestHouse.city}, ${guestHouse.country}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                ),

                // ---------------------------------------------------------
                // 🔥 CLOSE BUTTON ADDED HERE
                // ---------------------------------------------------------
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close,
                      size: 32, color: Colors.white),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: isMobile ? 200 : 180,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: guestHouse.totalRooms,
              itemBuilder: (context, index) {
                return _buildRoomCard(context, index);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, int index) {
    final colors = [
      [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
      [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
      [const Color(0xFFEC4899), const Color(0xFFDB2777)],
      [const Color(0xFF10B981), const Color(0xFF059669)],
      [const Color(0xFFF59E0B), const Color(0xFFD97706)],
    ];

    final colorPair = colors[index % colors.length];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditRoomScreen(
              guestHouse: guestHouse,
              roomNumber: index + 1,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ]),
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: colorPair,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const Icon(Icons.door_front_door,
                        color: Colors.white, size: 36),
                    const SizedBox(height: 8),
                    Text("${index + 1}",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ])),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Room ${index + 1}",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    Text("Configure",
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Icon(Icons.edit, size: 16, color: colorPair[1])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

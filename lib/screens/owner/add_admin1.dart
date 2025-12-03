import 'package:flutter/material.dart';
import 'package:lodge_logic/components/snackbar.dart';
import 'package:lodge_logic/global.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/services/guest_house_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();

  String? selectedGH;
  List<GuestHouse> guestHouses = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchGuestHouses();
  }

  Future<void> fetchGuestHouses() async {
    final houses = await GuestHouseService.getUserGuestHouses();

    setState(() {
      guestHouses = houses;
    });
  }

  Future<void> createAdmin() async {
    if (selectedGH == null) {
      showCustomSnackbar(
        context: context,
        message: "Please select a Guest House to manage",
        type: SnackbarType.info,
      );
      return;
    }

    setState(() => loading = true);
    final supabase = Supabase.instance.client;

    try {
      // 1️⃣ Register Admin in AUTH
      final authRes = await supabase.auth.signUp(
        email: emailCtrl.text.trim(),
        password: pwdCtrl.text.trim(),
        data: {
          "role":"Guest House Admin",
          "name":nameCtrl.text,
        }
      );

      if (authRes.user == null) {
        throw "Admin registration failed.";
      }

      final adminUid = authRes.user!.id;

      // 2️⃣ Insert Admin Object
      await supabase.from("guest_house_admins").insert({
        "admin_uid": adminUid,
        "email": emailCtrl.text.trim(),
        "name": nameCtrl.text.trim(),
        "gh_id": selectedGH,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Admin Created Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: const Text(
                    "Add Guest House Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: const Text(
                    "Create admin accounts for your guest houses",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 30),

                // Name Field
                _styledField(
                  controller: nameCtrl,
                  label: "Admin Name",
                  icon: Icons.person,
                ),

                // Email Field
                _styledField(
                  controller: emailCtrl,
                  label: "Admin Email",
                  icon: Icons.email_outlined,
                ),

                // Password Field
                _styledField(
                  controller: pwdCtrl,
                  label: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                // Guest House Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedGH,
                      borderRadius: BorderRadius.circular(15),
                      hint: const Text("Select Guest House"),
                      items: guestHouses.map((gh) {
                        return DropdownMenuItem(
                          value: gh.ghId, // <-- store ID
                          child: Text(gh.name), // <-- show name
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() => selectedGH = v);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : createAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Create Admin",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔵 Styled Input Fields (Reuse same login theme)
  Widget _styledField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade900),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lodge_logic/global.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/models/admin.dart';
import 'package:lodge_logic/models/guest_house.dart';
import 'package:lodge_logic/models/user_profile.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';
import 'package:lodge_logic/services/admin_service.dart';
import 'package:lodge_logic/services/guest_house_service.dart';
import 'package:lodge_logic/services/user_service.dart';
import 'package:lodge_logic/utils/password_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  String _name = '';
  String _email = '';
  String _password = '';
  String? _role; // Dropdown value
  final List<String> _roles = ['Super Admin', 'Admin', 'Manager'];
  
  GuestHouse? _selectedGuestHouse;
  List<GuestHouse> _guestHouses = [];
  bool _loadingGuestHouses = true;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadGuestHouses();
  }

  Future<void> _loadGuestHouses() async {
    try {
      final houses = await GuestHouseService.getUserGuestHouses();
      setState(() {
        _guestHouses = houses;
        _loadingGuestHouses = false;
      });
    } catch (e) {
      setState(() {
        _loadingGuestHouses = false;
      });
      // ignore: avoid_print
      print('Error loading guest houses: $e');
    }
  }

  Future<void> _handleSubmit() async {
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty || _selectedGuestHouse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      // 1. Sign up admin via Supabase Auth
      // final authResponse = await Supabase.instance.client.auth.signUp(
      //   email: _email,
      //   password: _password,
      //   data: {
      //    "role":"admin",
      //    "name":_name, 
      //   }
      // );

      // if (authResponse.user == null) {
      //   throw Exception('Failed to create auth user');
      // }

      // 2. Hash password
      final hashedPassword = PasswordUtils.hashPassword(_password);

      // 3. Create user in users table
      final userCreated = await UserService.createUser(
        UserProfile(
          name: _name,
          email: _email,
          role: "admin",
          password: hashedPassword,
          isApproved: true,
        ),
      );

      if (!userCreated) {
        throw Exception('Failed to create user in users table');
      }

      // 3. Get the created user's ID
      final createdUser = await UserService.getUserByEmail(_email);
      if (createdUser == null || createdUser.userId == null) {
        throw Exception('Failed to retrieve created user');
      }

      // 4. Get current owner's ID
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No owner logged in');
      }

      final ownerResult = await Supabase.instance.client
          .from('users')
          .select('user_id')
          .eq('email', currentUser.email!)
          .maybeSingle();

      if (ownerResult == null) {
        throw Exception('Owner not found');
      }

      // 5. Create admin in admins table
      final admin = Admin(
        userId: createdUser.userId,
        ownerId: ownerResult['user_id'] as int,
        name: _name,
        email: _email,
        isActive: true,
      );

      final adminCreated = await AdminService.createAdmin(admin);

      if (!adminCreated) {
        throw Exception('Failed to create admin in admins table');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Admin created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
      print('Error creating admin: $e');
    }
  }

  Widget _buildTextField({
    required String label,
    required String name,
    required String placeholder,
    required Function(String) onChanged,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child:Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ),
        TextFormField(
          obscureText: isPassword ? !_passwordVisible : false,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.gray700,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : null,
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
              borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              const Icon(Icons.shield, size: 16, color: AppColors.gray700),
              const SizedBox(width: 8),
              const Text(
                'Role *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
            ],
          ),
        ),
        DropdownButtonFormField<String>(
          value: _role,
          decoration: InputDecoration(
            hintText: 'Select role',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
            ),
          ),
          items: _roles.map((String role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _role = newValue;
            });
          },
        ),
      ],
    );
  }
 
  Widget _buildGuestHouseDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              const Icon(Icons.home, size: 16, color: AppColors.gray700),
              const SizedBox(width: 8),
              const Text(
                'Guest House *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
            ],
          ),
        ),
        _loadingGuestHouses
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gray200),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : DropdownButtonFormField<GuestHouse>(
                value: _selectedGuestHouse,
                decoration: InputDecoration(
                  hintText: 'Select guest house',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
                  ),
                ),
                items: _guestHouses.map((GuestHouse house) {
                  return DropdownMenuItem<GuestHouse>(
                    value: house,
                    child: Text(house.name),
                  );
                }).toList(),
                onChanged: (GuestHouse? newValue) {
                  setState(() {
                    _selectedGuestHouse = newValue;
                  });
                },
              ),
      ],
    );
  }

  Widget _buildContent(double screenWidth) {
    return SingleChildScrollView(
      padding: kPagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Area (Fixed height area with gradient)
         
          // Form Card
          Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color:const Color.fromARGB(255, 37, 123, 235),
              borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(color: AppColors.gray100),
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;
                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: isWide ? 2 : 1,
                        childAspectRatio: 3, // Adjust aspect ratio for better look
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 24.0,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildTextField(
                            label: 'Full Name',
                            name: 'name',
                            placeholder: 'John Doe',
                            onChanged: (val) => _name = val,
                          ),
                          _buildTextField(
                            label: 'Email Address',
                            name: 'email',
                            placeholder: 'admin@example.com',
                            onChanged: (val) => _email = val,
                          ),
                          _buildTextField(
                            label: 'Password',
                            name: 'password',
                            placeholder: 'Enter a secure password',
                            onChanged: (val) => _password = val,
                            isPassword: true,
                          ),
                        
                          _buildGuestHouseDropdown(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: mq!.width*0.3,
                      child: ElevatedButton(
                        
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue600,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          elevation: 0,
                        
                        ),
                        child: const Text(
                          'Assign Admin',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    final isMobile = mq!.width < kMobileBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: isMobile
          ? AppBar(
              title: const Text('Add Admin'),
              backgroundColor: AppColors.primaryPurple,
            )
          : null,
      drawer: isMobile ? const CustomSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          if (!isMobile) const CustomSidebar(),
          Expanded(
            child: Stack(
              children: [
                // Background Gradient (Absolute positioning effect)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 256,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9), Color(0xFF4F46E5)], // from-purple-600 via-purple-500 to-indigo-600
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Main Content (z-10 relative)
                Positioned.fill(
                  child: _buildContent(mq!.width),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
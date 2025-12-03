import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';
 // Assume this file exists

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

  void _handleSubmit() {
    // ignore: avoid_print
    print('Form submitted: Name: $_name, Email: $_email, Role: $_role');
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
          child: Text(
            '$label *',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ),
        TextFormField(
          obscureText: isPassword,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
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

  Widget _buildContent(double screenWidth) {
    return SingleChildScrollView(
      padding: kPagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Area (Fixed height area with gradient)
          Container(
            height: 160, // approx h-64 * 0.75 for a better look
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9), Color(0xFF4F46E5)], // from-purple-600 via-purple-500 to-indigo-600
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Pages', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                      Text(' / ', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                      Text('Manage Admins', style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
                      Text(' / ', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                      Text('Add Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Add New Admin', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text('Create a new administrator account', style: TextStyle(fontSize: 14, color: AppColors.purple100)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Form Card
          Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
                            placeholder: '••••••••',
                            onChanged: (val) => _password = val,
                            isPassword: true,
                          ),
                          _buildRoleDropdown(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Create Admin',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
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
                  child: _buildContent(screenWidth),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


class PasswordSettingsScreen extends StatefulWidget {
  const PasswordSettingsScreen({super.key});

  @override
  State<PasswordSettingsScreen> createState() => _PasswordSettingsScreenState();
}

class _PasswordSettingsScreenState extends State<PasswordSettingsScreen> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  void _handleSubmit() {
    if (_newPassController.text != _confirmPassController.text) {
      // Show error in a real app
      print('New passwords do not match!');
      return;
    }
    print('Password updated successfully!');
    // Clear fields
    _currentPassController.clear();
    _newPassController.clear();
    _confirmPassController.clear();
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            '$label *',
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: placeholder,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isMobile ? 10 : 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.gray600, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Pages / Settings / Password',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isMobile ? 12 : 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Password Settings',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update your account password',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.gray100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Form Card
          Container(
            padding: EdgeInsets.all(isMobile ? 20 : 32.0),
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              border: Border.all(color: AppColors.gray100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordField(
                  label: 'Current Password',
                  controller: _currentPassController,
                  placeholder: 'Enter current password',
                  isMobile: isMobile,
                ),
                const SizedBox(height: 24),
                _buildPasswordField(
                  label: 'New Password',
                  controller: _newPassController,
                  placeholder: 'Enter new password',
                  isMobile: isMobile,
                ),
                const SizedBox(height: 24),
                _buildPasswordField(
                  label: 'Confirm Password',
                  controller: _confirmPassController,
                  placeholder: 'Confirm new password',
                  isMobile: isMobile,
                ),
                const SizedBox(height: 32),
                isMobile
                    ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gray600,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Update Password',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.gray100,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray700),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gray600,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Update Password',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.gray100,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray700),
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
              title: const Text('Password Settings'),
              backgroundColor: AppColors.gray600,
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
                        colors: [AppColors.gray600, AppColors.gray500, AppColors.gray700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
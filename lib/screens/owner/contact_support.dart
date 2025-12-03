import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _handleSubmit() {
    print('Support message sent: ${_subjectController.text}');
    // Clear fields
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  Widget _buildInfoCard({required String title, required String value, required IconData icon}) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.teal100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: AppColors.teal600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String placeholder = '',
    int maxLines = 1,
    bool isEmail = false,
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
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isMobile ? 10 : 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.teal600, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(double screenWidth) {
    final isMobile = screenWidth < 768;
    final isWide = screenWidth > 1000;
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
                      'Pages / Support',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isMobile ? 12 : 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Contact Support',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get in touch with our support team',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.teal100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Contact Info Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : (isWide ? 3 : 2),
            crossAxisSpacing: isMobile ? 0 : 24.0,
            mainAxisSpacing: isMobile ? 16 : 24.0,
            childAspectRatio: isMobile ? 2.5 : (isWide ? 2.5 : 3.0),
            children: [
              _buildInfoCard(title: 'Email', value: 'support@admin.com', icon: AppIcons.mail),
              _buildInfoCard(title: 'Phone', value: '+1 (555) 123-4567', icon: AppIcons.phone),
              _buildInfoCard(title: 'Office', value: '123 Admin Lane, City, Country', icon: AppIcons.mapPin),
            ],
          ),
          const SizedBox(height: 32),

          // Message Form Card
          Container(
            padding: EdgeInsets.all(isMobile ? 20 : 32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              border: Border.all(color: AppColors.gray100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send Us a Message',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 1 : (isWide ? 2 : 1),
                  crossAxisSpacing: 24.0,
                  mainAxisSpacing: 24.0,
                  childAspectRatio: isMobile ? 5.5 : (isWide ? 4.5 : 5.5),
                  children: [
                    _buildTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      isMobile: isMobile,
                    ),
                    if (!isMobile)
                      _buildTextField(
                        label: 'Email Address',
                        controller: _emailController,
                        isEmail: true,
                        isMobile: isMobile,
                      ),
                  ],
                ),
                if (isMobile) ...[
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    isEmail: true,
                    isMobile: isMobile,
                  ),
                ],
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Subject',
                  controller: _subjectController,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Message',
                  controller: _messageController,
                  maxLines: 6,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 32),
                isMobile
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _handleSubmit,
                          icon: const Icon(AppIcons.send, color: Colors.white),
                          label: const Text(
                            'Send Message',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal600,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: _handleSubmit,
                        icon: const Icon(AppIcons.send, color: Colors.white),
                        label: const Text(
                          'Send Message',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal600,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
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
              title: const Text('Contact Support'),
              backgroundColor: AppColors.teal600,
            )
          : null,
      drawer: isMobile ? const CustomSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          if (!isMobile) const CustomSidebar(),
          Expanded(
            child: Stack(
              children: [
                // Background Gradient (Teal/Cyan for Support)
                Positioned(
                  top: 0, left: 0, right: 0, height: 256,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.teal600, Color(0xFF14B8A6), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(child: _buildContent(screenWidth)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
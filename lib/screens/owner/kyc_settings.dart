import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


// Mock Data
class KycDocument {
  final String key;
  final String label;
  final String desc;

  KycDocument({required this.key, required this.label, required this.desc});
}

class KYCSettingsScreen extends StatefulWidget {
  const KYCSettingsScreen({super.key});

  @override
  State<KYCSettingsScreen> createState() => _KYCSettingsScreenState();
}

class _KYCSettingsScreenState extends State<KYCSettingsScreen> {
  // Mock state for uploaded/verified documents
  final Map<String, bool> _documents = {
    'idProof': true,
    'addressProof': false,
    'businessLicense': false,
  };

  final List<KycDocument> _docList = [
    KycDocument(key: 'idProof', label: 'Government ID Proof', desc: 'Passport, Driver\'s License, or National ID Card.'),
    KycDocument(key: 'addressProof', label: 'Address Proof', desc: 'Utility Bill, Bank Statement, or Rental Agreement (last 3 months).'),
    KycDocument(key: 'businessLicense', label: 'Business License', desc: 'Valid Guest House/Hotel operating license.'),
  ];

  void _handleUpload(String key) {
    // Mock upload logic
    setState(() {
      _documents[key] = !_documents[key]!;
    });
    print('Toggled verification status for $key to ${_documents[key]}');
  }

  Widget _buildKycCard(KycDocument doc) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isVerified = _documents[doc.key] ?? false;

    final badgeColor = isVerified ? AppColors.green600 : AppColors.yellow600;
    final badgeBg = isVerified ? AppColors.green100 : AppColors.yellow100;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.label,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc.desc,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isVerified ? AppIcons.check : Icons.access_time_rounded, size: 14, color: badgeColor),
                    const SizedBox(width: 4),
                    Text(
                      isVerified ? 'Verified' : 'Pending',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badgeColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Upload Area
          InkWell(
            onTap: () => _handleUpload(doc.key),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 32.0),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.gray300, style: BorderStyle.solid, width: 2),
              ),
              child: Column(
                children: [
                  Icon(AppIcons.upload, size: isMobile ? 40 : 48, color: AppColors.gray400),
                  const SizedBox(height: 16),
                  Text(
                    isVerified ? 'Document uploaded successfully' : 'Click to upload or drag and drop',
                    style: TextStyle(
                      color: AppColors.gray700,
                      fontWeight: FontWeight.w500,
                      fontSize: isMobile ? 13 : 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PDF, JPG, PNG up to 5MB',
                    style: TextStyle(
                      color: AppColors.gray500,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(double screenWidth) {
    final isMobile = screenWidth < 768;
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
                      'Pages / Settings / KYC',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isMobile ? 12 : 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'KYC Verification',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete your Know Your Customer verification',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.gray100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Verification Statuses
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _docList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) => _buildKycCard(_docList[index]),
          ),

          const SizedBox(height: 32),
          // Save Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => print('Saving KYC status...'),
              icon: const Icon(Icons.save_rounded, color: Colors.white),
              label: const Text('Save Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue600,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              title: const Text('KYC Settings'),
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
                // Background Gradient (Gray/Slate for Settings)
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
                Positioned.fill(child: _buildContent(screenWidth)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
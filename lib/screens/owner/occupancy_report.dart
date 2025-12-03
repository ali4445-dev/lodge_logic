import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


// Mock Data Structure
class OccupancyData {
  final String name;
  final double value; // percentage
  final Color color;

  OccupancyData({required this.name, required this.value, required this.color});
}

class OccupancyReportScreen extends StatelessWidget {
  final List<OccupancyData> occupancyData = [
    OccupancyData(name: 'Occupied', value: 75, color: AppColors.red600),
    OccupancyData(name: 'Available', value: 20, color: AppColors.green600),
    OccupancyData(name: 'Maintenance', value: 5, color: AppColors.yellow600),
  ];

  OccupancyReportScreen({super.key});

  Widget _buildPieChartCard(bool isMobile) {
    // In a real application, you would use a package like 'fl_chart' or 'charts_flutter'
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
          Text(
            'Room Occupancy Distribution',
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: isMobile ? 250 : 300,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Mock Pie Chart - Use a CustomPaint or external library for real charts
                  Container(
                    width: isMobile ? 180 : 250,
                    height: isMobile ? 180 : 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gray200, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        '${occupancyData[0].value.toInt()}%',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray900,
                        ),
                      ),
                    ),
                  ),
                  // Mock sectors - for visual representation only
                  ...occupancyData.map((data) => Container(
                    width: 20, height: 20,
                    margin: EdgeInsets.only(
                      left: data.name == 'Occupied' ? 100 : 0,
                      top: data.name == 'Available' ? 100 : 0,
                      right: data.name == 'Maintenance' ? 100 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(bool isMobile) {
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
          Text(
            'Occupancy Statistics',
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          ...occupancyData.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 10 : 12),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                          fontSize: isMobile ? 13 : 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${item.value.toInt()}%',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
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
                      'Pages / Reports & Analytics / Occupancy',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isMobile ? 12 : 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Occupancy Report',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detailed breakdown of room status and usage',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.red100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Chart and Stats
          GridView.count(
            crossAxisCount: isMobile ? 1 : (isWide ? 2 : 1),
            crossAxisSpacing: isMobile ? 12 : 24,
            mainAxisSpacing: isMobile ? 12 : 24,
            childAspectRatio: isMobile ? 1.0 : 1.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPieChartCard(true),
              _buildStatsCard(true),
            ],
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
              title: const Text('Occupancy Report'),
              backgroundColor: AppColors.red600,
            )
          : null,
      drawer: isMobile ? const CustomSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          if (!isMobile) const CustomSidebar(),
          Expanded(
            child: Stack(
              children: [
                // Background Gradient (Red/Pink for Reports)
                Positioned(
                  top: 0, left: 0, right: 0, height: isMobile ? 200 : 256,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.red600, Color(0xFFEF4444), AppColors.pink600],
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
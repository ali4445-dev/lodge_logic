import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';
import 'package:lodge_logic/screens/owner/components/custom_sidebar.dart';


// Mock Data
class DashboardMetric {
  final String title;
  final String value;
  final double change;
  final Color iconBg;
  final IconData icon;

  DashboardMetric({
    required this.title,
    required this.value,
    required this.change,
    required this.iconBg,
    required this.icon,
  });
}

class DashboardOverviewScreen extends StatelessWidget {
   DashboardOverviewScreen({super.key});

 final List<DashboardMetric> metrics =  [
    // DashboardMetric(
    //   title: 'Total Revenue',
    //   value: '\$45,231',
    //   change: 12.5,
    //   iconBg: AppColors.green600,
    //   icon: Icons.attach_money_rounded,
    // ),
    // DashboardMetric(
    //   title: 'New Bookings',
    //   value: '1,342',
    //   change: 4.8,
    //   iconBg: AppColors.blue600,
    //   icon: AppIcons.calendarCheck,
    // ),
    // DashboardMetric(
    //   title: 'Occupancy Rate',
    //   value: '72%',
    //   change: -1.2,
    //   iconBg: AppColors.orange600,
    //   icon: Icons.trending_up_rounded,
    // ),
    // DashboardMetric(
    //   title: 'Active Guests',
    //   value: '105',
    //   change: 2.1,
    //   iconBg: AppColors.primaryPurple,
    //   icon: AppIcons.users,
    // ),
  ];
  Widget _buildMetricCard(DashboardMetric metric) {
    final isPositive = metric.change >= 0;
    final changeColor = isPositive ? AppColors.green600 : AppColors.red600;
    final changeIcon = isPositive ? AppIcons.trendingUp : AppIcons.trendingDown;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1),
        ],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  metric.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray500,
                    letterSpacing: 0.8,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: metric.iconBg,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: metric.iconBg.withOpacity(0.3), blurRadius: 5)],
                ),
                child: Icon(metric.icon, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(changeIcon, size: 12, color: changeColor),
                const SizedBox(width: 4),
                Text(
                  '${metric.change.abs()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: changeColor,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'vs last month',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gray500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mock widget for the Area Chart
  Widget _buildAreaChartCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1),
        ],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Trends',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Monthly performance overview',
            style: TextStyle(fontSize: 14, color: AppColors.gray500),
          ),
          const SizedBox(height: 24),
          Container(
            height: 300,
            color: AppColors.gray50,
            child: const Center(
              child: Text(
                'Area Chart Placeholder\n(Use a package like fl_chart or charts_flutter)',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.gray400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Guest Houses', 'desc': 'Manage all properties', 'icon': AppIcons.building, 'iconBg': AppColors.indigo600},
      {'name': 'Rooms', 'desc': 'Configure room types and rates', 'icon': AppIcons.bedDouble, 'iconBg': AppColors.orange600},
      {'name': 'Bookings', 'desc': 'View and manage reservations', 'icon': AppIcons.calendarCheck, 'iconBg': AppColors.green600},
      {'name': 'Guests', 'desc': 'Manage user profiles', 'icon': AppIcons.users, 'iconBg': AppColors.red600},
    ];

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1),
        ],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Access',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Navigate to key management areas',
            style: TextStyle(fontSize: 14, color: AppColors.gray500),
          ),
          const SizedBox(height: 16),
          ...categories.map((cat) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () => print('Tapped ${cat['name']}'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: cat['iconBg'],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: (cat['iconBg'] as Color).withOpacity(0.3), blurRadius: 5)],
                      ),
                      child: Icon(cat['icon'] as IconData, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.gray900)),
                          Text(cat['desc'], style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.gray400),
                  ],
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildContent(double screenWidth) {
    final isMobile = screenWidth < 600;
    return SingleChildScrollView(
      padding: kPagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Visual effect handled by Stack in build method)
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 4),
                Text('Welcome back to the Guest House Admin Panel', style: TextStyle(fontSize: 14, color: AppColors.blue100)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Metrics Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (screenWidth < 1000 ? 2 : 4),
              crossAxisSpacing: isMobile ? 8 : 24.0,
              mainAxisSpacing: isMobile ? 8 : 24.0,
              childAspectRatio: isMobile ? 3.2 : 1.3,
            ),
            itemBuilder: (context, index) => _buildMetricCard(metrics[index]),
          ),
          const SizedBox(height: 32),

          // Charts and Quick Access
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Wide layout: 2/3 chart, 1/3 quick access
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildAreaChartCard()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildCategoryList()),
                  ],
                );
              } else {
                // Narrow layout: Stacked
                return Column(
                  children: [
                    _buildAreaChartCard(),
                    const SizedBox(height: 24),
                    _buildCategoryList(),
                  ],
                );
              }
            },
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
              title: const Text('Dashboard'),
              backgroundColor: AppColors.blue600,
            )
          : null,
      drawer: isMobile ? const CustomSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          if (!isMobile) const CustomSidebar(),
          Expanded(
            child: Stack(
              children: [
                // Background Gradient (Primary color for Dashboard is blue)
                Positioned(
                  top: 0, left: 0, right: 0, height: 256,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.blue600, Color(0xFF3B82F6), AppColors.indigo600],
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
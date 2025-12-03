// (Same as the one provided in the previous response)
import 'package:flutter/material.dart';
import 'package:lodge_logic/helper/themes.dart';


class CustomSidebar extends StatelessWidget {
  final bool isDrawer;

  const CustomSidebar({this.isDrawer = false});

  Color _getColorForIndex(int index) {
    final colors = [
      AppColors.blue600,      // Dashboard
      AppColors.green600,     // Guest Houses
      AppColors.indigo600,    // All Rooms
      AppColors.orange600,    // All Bookings
      AppColors.red600,       // Assign Admin
      AppColors.yellow600,    // Occupancy Report
      AppColors.teal600,      // KYC Settings
      AppColors.pink600,      // Password Settings
      AppColors.orange600,    // Contact Support
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // Mock menu items for demonstration
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Dashboard', 'icon': AppIcons.dashboard, 'route': '/dashboard'},
      {'title': 'Guest Houses', 'icon': AppIcons.building, 'route': '/guest-houses'},
      {'title': 'All Rooms', 'icon': AppIcons.bedDouble, 'route': '/all-rooms'},
      {'title': 'All Bookings', 'icon': AppIcons.calendarCheck, 'route': '/bookings'},
      {'title': 'Assign Admin', 'icon': AppIcons.users, 'route': '/add-admin'},
      {'title': 'Occupancy Report', 'icon': AppIcons.pieChart, 'route': '/occupancy-report'},
      {'title': 'KYC Settings', 'icon': AppIcons.fileCheck, 'route': '/kyc-settings'},
      {'title': 'Password Settings', 'icon': AppIcons.lock, 'route': '/password-settings'},
      {'title': 'Contact Support', 'icon': AppIcons.contact, 'route': '/contact-support'},
    ];

    return Container(
      width: kSidebarWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isDrawer ? null : Border(right: BorderSide(color: AppColors.gray100)),
        boxShadow: isDrawer ? null : [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.blue600, AppColors.indigo600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Owner Panel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ...menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final itemColor = _getColorForIndex(index);
            final bool isActive = ModalRoute.of(context)?.settings.name == item['route'];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: isActive
                  ? BoxDecoration(
                      color: itemColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: itemColor, width: 2),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: itemColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item['icon'],
                    color: itemColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  item['title'],
                  style: TextStyle(
                    color: isActive ? itemColor : AppColors.gray700,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                  Navigator.pushNamed(context, item['route']);
                },
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lodge_logic/screens/auth/sign_in_screen.dart';

class AdminSidebarWidget extends StatefulWidget {
  final bool isDrawer;

  const AdminSidebarWidget({Key? key, this.isDrawer = false}) : super(key: key);

  @override
  State<AdminSidebarWidget> createState() => _AdminSidebarWidgetState();
}

class _AdminSidebarWidgetState extends State<AdminSidebarWidget> {

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    if (isMobile) {
      return Drawer(
        child: _buildSidebarContent(),
      );
    }
    
    return Container(
      width: 256,
      color: Colors.white,
      child: _buildSidebarContent(),
    );
  }
  
  Widget _buildSidebarContent() {
    return ListView(
      children: [
        // Branding
        Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.indigo],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.shield, color: Colors.white),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Lodge Logic',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
        SizedBox(height: 8),
        // Menu Items
        ..._buildMenuItems(),
        Spacer(),
        // Logout Button
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout, size: 16),
            label: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems() {
    final menuItems = [
      {
        'title': 'Dashboard',
        'icon': Icons.dashboard,
        'color': Colors.blue,
        'route': '/admin-dashboard',
      },
      // {
      //   'title': 'User Management',
      //   'icon': Icons.people,
      //   'color': Colors.cyan,
      //   'route': '/admin-all-users',
      // },
      {
        'title': 'Booking Management',
        'icon': Icons.event,
        'color': Colors.green,
        'route': '/admin-bookings',
      },
      // {
      //   'title': 'Payment Management',
      //   'icon': Icons.payment,
      //   'color': Colors.purple,
      //   'route': '/admin-payments',
      // },
      {
        'title': 'Complaints',
        'icon': Icons.warning,
        'color': Colors.orange,
        'route': '/admin-complaints',
      },
      // {
      //   'title': 'Content Management',
      //   'icon': Icons.description,
      //   'color': Colors.indigo,
      //   'route': '/admin-content',
      // },
      {
        'title': 'Room Management',
        'icon': Icons.meeting_room,
        'color': Colors.teal,
        'route': '/admin-room-management',
      },
    ];

    return menuItems.map((menu) => _buildMenuItem(
          menu['title'] as String,
          menu['icon'] as IconData,
          menu['color'] as Color,
          menu['route'] as String,
        )).toList();
  }

  Widget _buildMenuItem(String title, IconData icon, Color color, String route) {
    final bool isActive = ModalRoute.of(context)?.settings.name == route;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? color.withOpacity(0.1) : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? color : Colors.grey[700],
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        onTap: () {
          if (widget.isDrawer) Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}

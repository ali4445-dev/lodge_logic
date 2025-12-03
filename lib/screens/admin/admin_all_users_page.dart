import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class AdminAllUsers {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final bool verified;
  final String joined;

  AdminAllUsers({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.verified,
    required this.joined,
  });
}

class AdminAllUsersPage extends StatefulWidget {
  const AdminAllUsersPage({Key? key}) : super(key: key);

  @override
  State<AdminAllUsersPage> createState() => _AdminAllUsersPageState();
}

class _AdminAllUsersPageState extends State<AdminAllUsersPage> {
  String searchTerm = '';
  String filterRole = 'all';

  final List<AdminAllUsers> users = [
    AdminAllUsers(
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
      phone: '+1 234 567 8900',
      role: 'Customer',
      status: 'Active',
      verified: true,
      joined: '2024-01-15',
    ),
    AdminAllUsers(
      id: 2,
      name: 'Sarah Smith',
      email: 'sarah@example.com',
      phone: '+1 234 567 8901',
      role: 'Owner',
      status: 'Active',
      verified: true,
      joined: '2024-02-10',
    ),
    AdminAllUsers(
      id: 3,
      name: 'Mike Johnson',
      email: 'mike@example.com',
      phone: '+1 234 567 8902',
      role: 'Customer',
      status: 'Pending',
      verified: false,
      joined: '2024-03-05',
    ),
    AdminAllUsers(
      id: 4,
      name: 'Emma Wilson',
      email: 'emma@example.com',
      phone: '+1 234 567 8903',
      role: 'Owner',
      status: 'Active',
      verified: true,
      joined: '2024-01-20',
    ),
    AdminAllUsers(
      id: 5,
      name: 'David Brown',
      email: 'david@example.com',
      phone: '+1 234 567 8904',
      role: 'Customer',
      status: 'Blocked',
      verified: false,
      joined: '2024-02-15',
    ),
  ];

  List<AdminAllUsers> getFilteredUsers() {
    return users.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          user.email.toLowerCase().contains(searchTerm.toLowerCase()) ||
          user.phone.toLowerCase().contains(searchTerm.toLowerCase());
      
      final matchesRole = filterRole == 'all' ||
          user.role.toLowerCase() == filterRole.toLowerCase();
      
      return matchesSearch && matchesRole;
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Blocked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getRoleColor(String role) {
    return role == 'Owner' ? Colors.purple : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = getFilteredUsers();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      drawer: isMobile ? AdminSidebarWidget(isDrawer: true) : null,
      body: isMobile
          ? _buildMobileLayout(filteredUsers)
          : _buildDesktopLayout(filteredUsers),
    );
  }

  Widget _buildDesktopLayout(List<AdminAllUsers> filteredUsers) {
    return Row(
      children: [
        AdminSidebarWidget(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: _buildContent(filteredUsers),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(List<AdminAllUsers> filteredUsers) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Mobile Header
          Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              Expanded(
                child: Text(
                  'All Users',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: _buildContent(filteredUsers),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<AdminAllUsers> filteredUsers) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          if (!isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Users',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage and monitor all platform users',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),

          // Filters and Search
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: EdgeInsets.all(isMobile ? 12 : 24),
            child: isMobile
                ? Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() => searchTerm = value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.purple, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: filterRole,
                              onChanged: (value) {
                                setState(() => filterRole = value ?? 'all');
                              },
                              items: [
                                DropdownMenuItem(
                                  value: 'all',
                                  child: Text('All Roles'),
                                ),
                                DropdownMenuItem(
                                  value: 'customer',
                                  child: Text('Customers'),
                                ),
                                DropdownMenuItem(
                                  value: 'owner',
                                  child: Text('Owners'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.tune, size: 18),
                            label: Text('Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() => searchTerm = value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search by name, email, or phone...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[200]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.purple, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      DropdownButton<String>(
                        value: filterRole,
                        onChanged: (value) {
                          setState(() => filterRole = value ?? 'all');
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('All Roles'),
                          ),
                          DropdownMenuItem(
                            value: 'customer',
                            child: Text('Customers'),
                          ),
                          DropdownMenuItem(
                            value: 'owner',
                            child: Text('Owners'),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.tune),
                        label: Text('Filter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 24),

          // Stats Cards
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: isMobile ? 12 : 24,
              mainAxisSpacing: isMobile ? 12 : 24,
              childAspectRatio: 1.4,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              _buildStatCard('Total Users', '5,823', Colors.blue),
              _buildStatCard('Active Users', '5,234', Colors.green),
              _buildStatCard('Pending Approval', '456', Colors.orange),
              _buildStatCard('Blocked Users', '133', Colors.red),
            ],
          ),
          SizedBox(height: 24),

          // Users Table/List
          if (isMobile)
            _buildMobileUsersList(filteredUsers)
          else
            _buildDesktopUsersTable(filteredUsers),
        ],
      ),
    );
  }

  Widget _buildDesktopUsersTable(List<AdminAllUsers> filteredUsers) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 24,
            columns: [
              DataColumn(label: Text('User')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Joined')),
              DataColumn(label: Text('Actions')),
            ],
            rows: filteredUsers.map((user) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (user.verified)
                              Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email, size: 14, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(user.email, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(user.phone, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: getRoleColor(user.role).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: getRoleColor(user.role),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(user.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: getStatusColor(user.status),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(user.joined, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileUsersList(List<AdminAllUsers> filteredUsers) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 20,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getRoleColor(user.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user.role,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: getRoleColor(user.role),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(user.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(user.status),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Joined: ${user.joined}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: isMobile ? 36 : 48,
            height: isMobile ? 36 : 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.people, color: color, size: isMobile ? 18 : 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

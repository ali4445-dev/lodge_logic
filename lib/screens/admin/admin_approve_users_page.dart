import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class PendingUser {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String type;
  final String createdAt;
  final int guestHouses;

  PendingUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.type,
    required this.createdAt,
    required this.guestHouses,
  });
}

class AdminApproveUsersPage extends StatefulWidget {
  const AdminApproveUsersPage({Key? key}) : super(key: key);

  @override
  State<AdminApproveUsersPage> createState() => _AdminApproveUsersPageState();
}

class _AdminApproveUsersPageState extends State<AdminApproveUsersPage> {
  bool loading = true;
  List<PendingUser> pendingUsers = [];

  @override
  void initState() {
    super.initState();
    fetchPendingUsers();
  }

  Future<void> fetchPendingUsers() async {
    // Simulated API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      pendingUsers = [
        PendingUser(
          userId: '1',
          name: 'Alice Johnson',
          email: 'alice@example.com',
          phone: '+1 234 567 8900',
          role: 'Owner',
          type: 'Property Owner',
          createdAt: '2024-12-01',
          guestHouses: 2,
        ),
        PendingUser(
          userId: '2',
          name: 'Bob Smith',
          email: 'bob@example.com',
          phone: '+1 234 567 8901',
          role: 'Customer',
          type: 'Individual',
          createdAt: '2024-12-02',
          guestHouses: 0,
        ),
      ];
      loading = false;
    });
  }

  Future<void> handleApprove(String userId) async {
    setState(() {
      pendingUsers.removeWhere((user) => user.userId == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User approved successfully')),
    );
  }

  Future<void> handleReject(String userId) async {
    setState(() {
      pendingUsers.removeWhere((user) => user.userId == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Row(
        children: [
          AdminSidebarWidget(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Approve Users',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Review and approve pending user registrations',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Stats
                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.2,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      _buildStatCard('Pending Approvals', '23', Colors.orange),
                      _buildStatCard('Approved Today', '145', Colors.green),
                      _buildStatCard('Rejected Today', '12', Colors.red),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Pending Users List
                  if (loading)
                    Center(child: CircularProgressIndicator())
                  else if (pendingUsers.isEmpty)
                    Center(child: Text('No pending users'))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: pendingUsers.length,
                        itemBuilder: (context, index) {
                          final user = pendingUsers[index];
                          return _buildUserCard(user);
                        },
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

  Widget _buildStatCard(String title, String value, Color color) {
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
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.check_circle, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(PendingUser user) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.indigo],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: user.role == 'Owner' ? Colors.purple.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.role,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: user.role == 'Owner' ? Colors.purple : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 3,
                      ),
                      shrinkWrap: true,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email, size: 14, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(child: Text(user.email, style: TextStyle(fontSize: 12))),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(child: Text(user.phone, style: TextStyle(fontSize: 12))),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(child: Text('Joined: ${user.createdAt}', style: TextStyle(fontSize: 12))),
                          ],
                        ),
                        if (user.role == 'Owner')
                          Row(
                            children: [
                              Icon(Icons.business, size: 14, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${user.guestHouses} Guest House${user.guestHouses != 1 ? 's' : ''}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.description, size: 14, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Type: ${user.type}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24),
              // Action Buttons
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => handleApprove(user.userId),
                    icon: Icon(Icons.check),
                    label: Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => handleReject(user.userId),
                    icon: Icon(Icons.close),
                    label: Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

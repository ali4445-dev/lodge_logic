import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class Complaint {
  final String id;
  final String title;
  final String description;
  final String customer;
  final String guestHouse;
  final String priority;
  final String status;
  final String submitted;
  final String assignedTo;
  final String category;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.customer,
    required this.guestHouse,
    required this.priority,
    required this.status,
    required this.submitted,
    required this.assignedTo,
    required this.category,
  });
}

class AdminComplaintsPage extends StatefulWidget {
  const AdminComplaintsPage({Key? key}) : super(key: key);

  @override
  State<AdminComplaintsPage> createState() => _AdminComplaintsPageState();
}

class _AdminComplaintsPageState extends State<AdminComplaintsPage> {
  final List<Complaint> complaints = [
    Complaint(
      id: 'CP-1001',
      title: 'Room cleanliness issue',
      description: 'The room was not properly cleaned before check-in. Found dust and stains.',
      customer: 'John Doe',
      guestHouse: 'Paradise Inn',
      priority: 'High',
      status: 'Open',
      submitted: '2024-12-01',
      assignedTo: 'Not Assigned',
      category: 'Cleanliness',
    ),
    Complaint(
      id: 'CP-1002',
      title: 'Booking cancellation refund delay',
      description: 'Cancelled booking 2 weeks ago but have not received refund yet.',
      customer: 'Sarah Smith',
      guestHouse: 'Ocean View Hotel',
      priority: 'Medium',
      status: 'In Progress',
      submitted: '2024-11-30',
      assignedTo: 'Support Agent #2',
      category: 'Payment',
    ),
    Complaint(
      id: 'CP-1003',
      title: 'WiFi not working',
      description: 'Internet connection is very slow and keeps disconnecting.',
      customer: 'Mike Johnson',
      guestHouse: 'Mountain Lodge',
      priority: 'Low',
      status: 'Resolved',
      submitted: '2024-11-29',
      assignedTo: 'Support Agent #1',
      category: 'Amenities',
    ),
  ];

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      drawer: isMobile ? AdminSidebarWidget(isDrawer: true) : null,
      body: isMobile
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        AdminSidebarWidget(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
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
                  'Complaints',
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
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complaints & Support',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage customer complaints and support tickets',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),

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
              _buildStatCard('Total Tickets', '156', Colors.orange),
              _buildStatCard('Open Complaints', '23', Colors.red),
              _buildStatCard('In Progress', '45', Colors.blue),
              _buildStatCard('Resolved', '88', Colors.green),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 32),

          // Complaints List
          SizedBox(
            height: 600,
            child: ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final complaint = complaints[index];
                return _buildComplaintCard(complaint, isMobile);
              },
            ),
          ),
        ],
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
            child: Icon(Icons.warning, color: color, size: isMobile ? 18 : 24),
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

  Widget _buildComplaintCard(Complaint complaint, bool isMobile) {
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
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.red],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.warning, color: Colors.white, size: isMobile ? 20 : 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            complaint.title,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: getStatusColor(complaint.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            complaint.status,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(complaint.status),
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: getPriorityColor(complaint.priority).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            complaint.priority,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: getPriorityColor(complaint.priority),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      complaint.description,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              mainAxisSpacing: isMobile ? 10 : 12,
              crossAxisSpacing: isMobile ? 10 : 16,
              childAspectRatio: isMobile ? 3 : 4,
            ),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ID', style: TextStyle(fontSize: 8, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                  Text(complaint.id, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('CUSTOMER', style: TextStyle(fontSize: 8, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                  Text(complaint.customer, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('PROPERTY', style: TextStyle(fontSize: 8, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                  Text(complaint.guestHouse, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('DATE', style: TextStyle(fontSize: 8, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                  Text(complaint.submitted, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.message, size: 11, color: Colors.purple),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          complaint.category,
                          style: TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 11, color: Colors.blue),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          complaint.assignedTo,
                          style: TextStyle(fontSize: 9),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(height: 12),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Assign', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Update', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Resolve', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

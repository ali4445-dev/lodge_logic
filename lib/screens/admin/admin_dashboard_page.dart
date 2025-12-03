import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final List<Map<String, dynamic>> recentActivity = [
    {
      'type': 'User Registration',
      'user': 'John Doe',
      'action': 'New customer registered',
      'time': '5 min ago',
      'icon': Icons.person_add,
      'color': Colors.blue,
    },
    {
      'type': 'Booking Approval',
      'user': 'Sarah Smith',
      'action': 'Booking #12345 approved',
      'time': '15 min ago',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'type': 'Complaint',
      'user': 'Mike Johnson',
      'action': 'New complaint submitted',
      'time': '30 min ago',
      'icon': Icons.warning,
      'color': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> pendingTasks = [
    {'task': 'User Approvals', 'count': 23, 'color': Colors.blue},
    {'task': 'Booking Approvals', 'count': 15, 'color': Colors.green},
    {'task': 'Open Tickets', 'count': 8, 'color': Colors.orange},
    {'task': 'Payout Requests', 'count': 12, 'color': const Color.fromARGB(255, 114, 33, 243)},
  ];

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
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              Expanded(
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Column(
      children: [
        if (!isMobile)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin / Dashboard',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Admin Overview',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Monitor and manage all platform activities',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple[100],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 4,
                      crossAxisSpacing: isMobile ? 12 : 24,
                      mainAxisSpacing: isMobile ? 12 : 24,
                      childAspectRatio: 1.3,
                    ),
                    shrinkWrap: true,
                    children: [
                      _buildMetricCard('TOTAL USERS', '5,823', '+12% this month', Colors.blue),
                      _buildMetricCard('ACTIVE BOOKINGS', '1,234', '+8% this week', Colors.green),
                      _buildMetricCard('TOTAL REVENUE', '\$234,500', '+15% this month', Colors.purple),
                      _buildMetricCard('OPEN COMPLAINTS', '23', '-5% from yesterday', Colors.orange),
                    ],
                  ),
                  SizedBox(height: isMobile ? 16 : 32),
                  if (isMobile)
                    Column(
                      children: [
                        _buildActivityChart(isMobile),
                        SizedBox(height: 16),
                        _buildDistributionChart(isMobile),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildActivityChart(isMobile),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: _buildDistributionChart(isMobile),
                        ),
                      ],
                    ),
                  SizedBox(height: isMobile ? 16 : 24),
                  if (isMobile)
                    Column(
                      children: [
                        _buildActivitySection(isMobile),
                        SizedBox(height: 16),
                        _buildTasksSection(isMobile),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _buildActivitySection(isMobile),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: _buildTasksSection(isMobile),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityChart(bool isMobile) {
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
        children: [
          Text(
            'Platform Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Growing trend in user engagement',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          Container(
            height: isMobile ? 150 : 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDEF7EC), Color(0xFFDEEFF8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('Activity Chart'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart(bool isMobile) {
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
        children: [
          Text(
            'User Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 32),
          Container(
            height: isMobile ? 120 : 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0E7FF), Color(0xFFFCE7F3)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('Pie Chart'),
            ),
          ),
          SizedBox(height: 16),
          _buildDistributionLegend('Customers', 3500, Colors.blue),
          SizedBox(height: 8),
          _buildDistributionLegend('Owners', 1200, Colors.purple),
          SizedBox(height: 8),
          _buildDistributionLegend('Pending', 450, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildActivitySection(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue)),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...recentActivity.map((activity) {
            return _buildActivityItem(activity);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTasksSection(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pending Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Manage', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue)),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...pendingTasks.map((task) {
            return _buildTaskItem(task);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change, Color color) {
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
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 9 : 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.trending_up, size: 10, color: Colors.green),
                        SizedBox(width: 2),
                        Text(
                          change,
                          style: TextStyle(
                            fontSize: isMobile ? 9 : 11,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: isMobile ? 36 : 50,
                height: isMobile ? 36 : 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.trending_up, color: color, size: isMobile ? 16 : 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionLegend(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
        Text(value.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(activity['icon'], color: activity['color'], size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['type'],
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  activity['action'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            activity['time'],
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: task['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_circle, color: task['color'], size: 24),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['task'],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Requires attention',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${task['count']}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

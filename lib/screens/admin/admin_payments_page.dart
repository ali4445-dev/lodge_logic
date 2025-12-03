import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class PayoutRequest {
  final String id;
  final String owner;
  final String ownerEmail;
  final String amount;
  final String period;
  final String requestDate;
  final String status;
  final int bookings;
  final String commission;
  final String netAmount;

  PayoutRequest({
    required this.id,
    required this.owner,
    required this.ownerEmail,
    required this.amount,
    required this.period,
    required this.requestDate,
    required this.status,
    required this.bookings,
    required this.commission,
    required this.netAmount,
  });
}

class AdminPaymentsPage extends StatefulWidget {
  const AdminPaymentsPage({Key? key}) : super(key: key);

  @override
  State<AdminPaymentsPage> createState() => _AdminPaymentsPageState();
}

class _AdminPaymentsPageState extends State<AdminPaymentsPage> {
  final List<PayoutRequest> payoutRequests = [
    PayoutRequest(
      id: 'PO-5001',
      owner: 'Hotel Paradise',
      ownerEmail: 'paradise@example.com',
      amount: '\$5,000',
      period: 'November 2024',
      requestDate: '2024-12-01',
      status: 'Pending',
      bookings: 45,
      commission: '\$500',
      netAmount: '\$4,500',
    ),
    PayoutRequest(
      id: 'PO-5002',
      owner: 'Ocean View Resort',
      ownerEmail: 'oceanview@example.com',
      amount: '\$8,500',
      period: 'November 2024',
      requestDate: '2024-11-30',
      status: 'Approved',
      bookings: 78,
      commission: '\$850',
      netAmount: '\$7,650',
    ),
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
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
                  'Payment',
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
                  'Payment Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Monitor revenue, approve payouts, and track payment logs',
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
              _buildStatCard('Total Revenue', '\$234,500', Colors.purple),
              _buildStatCard('Platform Earnings', '\$52,300', Colors.blue),
              _buildStatCard('Pending Payouts', '12', Colors.orange),
              _buildStatCard('Completed Payouts', '145', Colors.green),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 32),

          // Revenue Overview
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            padding: EdgeInsets.all(isMobile ? 12 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Revenue Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Monthly revenue and commission breakdown',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMobile)
                      DropdownButton<String>(
                        items: [
                          DropdownMenuItem(
                            value: '6m',
                            child: Text('Last 6 Months'),
                          ),
                          DropdownMenuItem(
                            value: '12m',
                            child: Text('Last 12 Months'),
                          ),
                          DropdownMenuItem(
                            value: 'year',
                            child: Text('This Year'),
                          ),
                        ],
                        onChanged: (value) {},
                        value: '6m',
                      ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  height: isMobile ? 150 : 256,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFA7F3D0), Color(0xFF93C5FD)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Revenue Chart Visualization',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 16 : 32),

          // Payout Requests
          Text(
            'Payout Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),

          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: payoutRequests.length,
              itemBuilder: (context, index) {
                final payout = payoutRequests[index];
                return _buildPayoutCard(payout, isMobile);
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
            child: Icon(Icons.money, color: color, size: isMobile ? 18 : 24),
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

  Widget _buildPayoutCard(PayoutRequest payout, bool isMobile) {
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
            children: [
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.green],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.money, color: Colors.white, size: isMobile ? 20 : 24),
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
                            payout.owner,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: getStatusColor(payout.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            payout.status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(payout.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      'ID: ${payout.id}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
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
              mainAxisSpacing: isMobile ? 12 : 16,
              crossAxisSpacing: isMobile ? 12 : 24,
              childAspectRatio: isMobile ? 2.2 : 3.5,
            ),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('GROSS', style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  Text(payout.amount, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('COMMISSION', style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  Text(payout.commission, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('NET', style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  Text(payout.netAmount, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('BOOKINGS', style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  Text('${payout.bookings}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              if (!isMobile)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.business, size: 12, color: Colors.purple),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Period: ${payout.period}',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isMobile) SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: Colors.blue),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Req: ${payout.requestDate}',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(),
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
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check, size: 16),
                  label: Text('Approve', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(width: 8),
                if (!isMobile)
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Logs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                if (!isMobile) SizedBox(width: 8),
                if (!isMobile)
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('Invoice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue, width: 1),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

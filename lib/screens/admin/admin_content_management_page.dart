import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class ContentFaq {
  final int id;
  final String question;
  final String answer;
  final String category;

  ContentFaq({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });
}

class ContentPolicy {
  final int id;
  final String title;
  final String lastUpdated;
  final String status;

  ContentPolicy({
    required this.id,
    required this.title,
    required this.lastUpdated,
    required this.status,
  });
}

class ContentAnnouncement {
  final int id;
  final String title;
  final String content;
  final String date;
  final String status;

  ContentAnnouncement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.status,
  });
}

class ContentPromotion {
  final int id;
  final String code;
  final String discount;
  final String validUntil;
  final int usageCount;
  final String status;

  ContentPromotion({
    required this.id,
    required this.code,
    required this.discount,
    required this.validUntil,
    required this.usageCount,
    required this.status,
  });
}

class AdminContentManagementPage extends StatefulWidget {
  const AdminContentManagementPage({Key? key}) : super(key: key);

  @override
  State<AdminContentManagementPage> createState() => _AdminContentManagementPageState();
}

class _AdminContentManagementPageState extends State<AdminContentManagementPage> {
  String activeTab = 'faqs';

  final List<ContentFaq> faqs = [
    ContentFaq(
      id: 1,
      question: 'How do I book a guest house?',
      answer: 'You can book a guest house by browsing our listings and clicking the "Book Now" button.',
      category: 'Booking',
    ),
    ContentFaq(
      id: 2,
      question: 'What is the cancellation policy?',
      answer: 'Cancellation policies vary by property. Please check the specific policy on the listing page.',
      category: 'Policies',
    ),
    ContentFaq(
      id: 3,
      question: 'How do I contact customer support?',
      answer: 'You can reach our customer support team via the support page or email support@lodgelogic.com',
      category: 'Support',
    ),
  ];

  final List<ContentPolicy> policies = [
    ContentPolicy(id: 1, title: 'Privacy Policy', lastUpdated: '2024-11-15', status: 'Published'),
    ContentPolicy(id: 2, title: 'Terms of Service', lastUpdated: '2024-11-10', status: 'Published'),
    ContentPolicy(id: 3, title: 'Refund Policy', lastUpdated: '2024-10-20', status: 'Draft'),
  ];

  final List<ContentAnnouncement> announcements = [
    ContentAnnouncement(
      id: 1,
      title: 'Holiday Season Discounts',
      content: 'Get up to 30% off on all bookings during the holiday season!',
      date: '2024-12-01',
      status: 'Active',
    ),
    ContentAnnouncement(
      id: 2,
      title: 'New Features Released',
      content: 'We have launched new features to enhance your booking experience.',
      date: '2024-11-25',
      status: 'Active',
    ),
  ];

  final List<ContentPromotion> promotions = [
    ContentPromotion(
      id: 1,
      code: 'WINTER2024',
      discount: '25%',
      validUntil: '2024-12-31',
      usageCount: 234,
      status: 'Active',
    ),
    ContentPromotion(
      id: 2,
      code: 'NEWUSER10',
      discount: '10%',
      validUntil: '2024-12-31',
      usageCount: 567,
      status: 'Active',
    ),
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
          child: Padding(
            padding: EdgeInsets.all(32),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
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
                'Content',
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
          child: SingleChildScrollView(
            child: _buildContent(),
          ),
        ),
      ],
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
                  'Content Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage FAQs, policies, announcements, and promotions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),

          // Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab('faqs', 'FAQs', Icons.help_outline),
                  _buildTab('policies', 'Policies', Icons.shield),
                  _buildTab('announcements', 'Announce', Icons.notification_add),
                  _buildTab('promotions', 'Promos', Icons.discount),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Content
          _buildContentArea(),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    switch (activeTab) {
      case 'faqs':
        return _buildFaqContent();
      case 'policies':
        return _buildPoliciesContent();
      case 'announcements':
        return _buildAnnouncementsContent();
      case 'promotions':
        return _buildPromotionsContent();
      default:
        return SizedBox();
    }
  }

  Widget _buildTab(String tabName, String label, IconData icon) {
    final isActive = activeTab == tabName;
    return InkWell(
      onTap: () => setState(() => activeTab = tabName),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.purple : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? Colors.purple : Colors.grey),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.purple : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContentArea() {
    switch (activeTab) {
      case 'faqs':
        return _buildFaqContent();
      case 'policies':
        return _buildPoliciesContent();
      case 'announcements':
        return _buildAnnouncementsContent();
      case 'promotions':
        return _buildPromotionsContent();
      default:
        return SizedBox();
    }
  }

  Widget _buildFaqContent() {   final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16),
              label: Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
              final faq = faqs[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: EdgeInsets.all(isMobile ? 10 : 16),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      faq.question,
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      faq.category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                faq.answer,
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: isMobile ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue, size: 18),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 18),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPoliciesContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Policies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16),
              label: Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: policies.length,
          itemBuilder: (context, index) {
              final policy = policies[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: EdgeInsets.all(isMobile ? 10 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: isMobile ? 35 : 48,
                          height: isMobile ? 35 : 48,
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.shield, color: Colors.purple, size: isMobile ? 16 : 20),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                policy.title,
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Updated: ${policy.lastUpdated}',
                                style: TextStyle(
                                  fontSize: isMobile ? 10 : 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: policy.status == 'Published' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            policy.status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: policy.status == 'Published' ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        if (!isMobile)
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Edit', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                          ),
                        if (isMobile)
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue, size: 18),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAnnouncementsContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16),
              label: Text('Create', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
              final announcement = announcements[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: EdgeInsets.all(isMobile ? 10 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            announcement.title,
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: announcement.status == 'Active' ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            announcement.status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: announcement.status == 'Active' ? Colors.green : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      announcement.content,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Posted: ${announcement.date}',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (!isMobile)
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Edit', style: TextStyle(fontSize: 11)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                ),
                              ),
                              SizedBox(width: 6),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Delete', style: TextStyle(fontSize: 11)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                ),
                              ),
                            ],
                          ),
                        if (isMobile)
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue, size: 16),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red, size: 16),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPromotionsContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Promotions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16),
              label: Text('Create', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: promotions.length,
          itemBuilder: (context, index) {
              final promo = promotions[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: EdgeInsets.all(isMobile ? 10 : 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isMobile ? 6 : 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.indigo],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CODE',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                promo.code,
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GridView(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.8,
                            ),
                            shrinkWrap: true,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Disc', style: TextStyle(fontSize: 8, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                  Text(promo.discount, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Valid', style: TextStyle(fontSize: 8, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                  Text(promo.validUntil, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Used', style: TextStyle(fontSize: 8, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                  Text('${promo.usageCount}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: promo.status == 'Active' ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      promo.status,
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: promo.status == 'Active' ? Colors.green : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue, size: 16),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red, size: 16),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

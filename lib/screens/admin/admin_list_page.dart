import 'package:flutter/material.dart';
import 'admin_sidebar_widget.dart';

class Admin {
  final String userId;
  final String name;
  final String email;
  final String role;
  final bool isApproved;

  Admin({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.isApproved,
  });
}

class AdminListPage extends StatefulWidget {
  const AdminListPage({Key? key}) : super(key: key);

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  String searchTerm = '';
  bool loading = true;
  List<Admin> admins = [];
  bool showDeleteDialog = false;
  String? deleteAdminId;
  String? deleteAdminName;

  @override
  void initState() {
    super.initState();
    fetchAdmins();
  }

  Future<void> fetchAdmins() async {
    // Simulated API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      admins = [
        Admin(
          userId: '1',
          name: 'Alice Admin',
          email: 'alice@example.com',
          role: 'Super Admin',
          isApproved: true,
        ),
        Admin(
          userId: '2',
          name: 'Bob Manager',
          email: 'bob@example.com',
          role: 'Admin',
          isApproved: true,
        ),
        Admin(
          userId: '3',
          name: 'Charlie Support',
          email: 'charlie@example.com',
          role: 'Support Admin',
          isApproved: false,
        ),
      ];
      loading = false;
    });
  }

  void showDeleteDialog_(String userId, String name) {
    setState(() {
      showDeleteDialog = true;
      deleteAdminId = userId;
      deleteAdminName = name;
    });
  }

  Future<void> handleDelete() async {
    if (deleteAdminId != null) {
      setState(() {
        admins.removeWhere((admin) => admin.userId == deleteAdminId);
        showDeleteDialog = false;
        deleteAdminId = null;
        deleteAdminName = null;
      });
    }
  }

  List<Admin> getFilteredAdmins() {
    return admins.where((admin) {
      return admin.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          admin.email.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAdmins = getFilteredAdmins();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin List',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage administrator accounts',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add New Admin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Search
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: TextField(
                      onChanged: (value) {
                        setState(() => searchTerm = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search admins...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.purple, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),

                  // Table
                  if (loading)
                    Center(child: CircularProgressIndicator())
                  else
                    Expanded(
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
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: filteredAdmins.map((admin) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.purple.withOpacity(0.1),
                                          child: Icon(Icons.person, color: Colors.purple),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          admin.name,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(admin.email, style: TextStyle(fontSize: 12))),
                                  DataCell(
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        admin.role,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: admin.isApproved ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        admin.isApproved ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: admin.isApproved ? Colors.green : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.purple, size: 18),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red, size: 18),
                                          onPressed: () => showDeleteDialog_(admin.userId, admin.name),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Delete Dialog
      floatingActionButton: showDeleteDialog
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.close),
            )
          : null,
    );
  }
}

import 'package:flutter/material.dart';

class AdminPermissionsPage extends StatefulWidget {
  const AdminPermissionsPage({Key? key}) : super(key: key);

  @override
  State<AdminPermissionsPage> createState() => _AdminPermissionsPageState();
}

class _AdminPermissionsPageState extends State<AdminPermissionsPage> {
  bool loading = true;
  List<Map<String, dynamic>> admins = [];
  Map<String, Map<String, bool>> permissions = {};
  String? toastMessage;
  String? toastType;

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
        {'userId': '1', 'name': 'Alice Admin'},
        {'userId': '2', 'name': 'Bob Manager'},
        {'userId': '3', 'name': 'Charlie Support'},
      ];

      // Initialize permissions
      permissions = {};
      for (var admin in admins) {
        permissions[admin['userId']] = {
          'bookings': false,
          'rooms': false,
          'guests': false,
          'reports': false,
        };
      }
      loading = false;
    });
  }

  void showToast(String message, String type) {
    setState(() {
      toastMessage = message;
      toastType = type;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        toastMessage = null;
        toastType = null;
      });
    });
  }

  void togglePermission(String adminId, String permission) {
    setState(() {
      permissions[adminId]![permission] = !(permissions[adminId]![permission] ?? false);
    });
  }

  Future<void> savePermissions() async {
    // Simulated API call
    await Future.delayed(Duration(seconds: 1));
    showToast('Permissions saved successfully!', 'success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Row(
        children: [
          // Sidebar would go here
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
                        'Admin Permissions',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage access permissions for administrators',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Permissions Table
                  if (loading)
                    Center(child: CircularProgressIndicator())
                  else
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'ADMIN',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'MANAGE BOOKINGS',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'MANAGE ROOMS',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'MANAGE GUESTS',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'VIEW REPORTS',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Expanded(
                              child: ListView.builder(
                                itemCount: admins.length,
                                itemBuilder: (context, index) {
                                  final admin = admins[index];
                                  return _buildPermissionRow(
                                    admin['name'],
                                    admin['userId'],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Divider(),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: savePermissions,
                                  child: Text('Save Permissions'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Toast notification
      floatingActionButton: toastMessage != null
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(
                toastType == 'success' ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              backgroundColor: toastType == 'success' ? Colors.green : Colors.red,
            )
          : null,
    );
  }

  Widget _buildPermissionRow(String adminName, String adminId) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              adminName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ..._buildPermissionToggles(adminId),
        ],
      ),
    );
  }

  List<Widget> _buildPermissionToggles(String adminId) {
    final permissionKeys = ['bookings', 'rooms', 'guests', 'reports'];
    return permissionKeys.map((permission) {
      final isEnabled = permissions[adminId]?[permission] ?? false;
      return Expanded(
        child: Center(
          child: GestureDetector(
            onTap: () => togglePermission(adminId, permission),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isEnabled ? Colors.purple : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: isEnabled
                  ? Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
        ),
      );
    }).toList();
  }
}

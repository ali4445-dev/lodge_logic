import 'package:flutter/material.dart';
import 'package:lodge_logic/screens/owner/add_admin.dart';
import 'package:lodge_logic/screens/owner/add_admin1.dart' hide AddAdminScreen;
import 'package:lodge_logic/screens/owner/add_guestHoues.dart';
import 'package:lodge_logic/screens/owner/all_bookings.dart';
import 'package:lodge_logic/screens/owner/contact_support.dart';
import 'package:lodge_logic/screens/owner/edit_room.dart';
import 'package:lodge_logic/screens/owner/edit_room_form.dart';
import 'package:lodge_logic/screens/owner/guest_houses.dart';
import 'package:lodge_logic/screens/owner/kyc_settings.dart';
import 'package:lodge_logic/screens/owner/occupancy_report.dart';
import 'package:lodge_logic/screens/owner/ownerdashboard.dart';
import 'package:lodge_logic/screens/owner/password_settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ADMIN SCREENS
import 'package:lodge_logic/screens/admin/admin_dashboard_page.dart';
import 'package:lodge_logic/screens/admin/admin_all_users_page.dart';
import 'package:lodge_logic/screens/admin/admin_bookings_page.dart';
import 'package:lodge_logic/screens/admin/admin_payments_page.dart';
import 'package:lodge_logic/screens/admin/admin_complaints_page.dart';
import 'package:lodge_logic/screens/admin/admin_content_management_page.dart';

// AUTH SCREENS
import 'package:lodge_logic/screens/auth/sign_in_screen.dart';
import 'package:lodge_logic/screens/auth/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
     await Supabase.initialize(
      url: 'https://dicqpsjxmpusoelvtzza.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpY3Fwc2p4bXB1c29lbHZ0enphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxOTIyNzksImV4cCI6MjA3OTc2ODI3OX0.B-ZF5mL4Hwzy57687UU1RejFTzsBBB_rSAy1E99w8XY',
    );
    print("Connection Successfull...");
  } catch (e) {
    print(e);
  }

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    print("Session Refreshed");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lodge Logic',
      debugShowCheckedModeBanner: false,

      // 👇 THIS MAKES SIGNIN THE DEFAULT PAGE
      initialRoute: '/sign-in',

      // 👇 ALL YOUR NAMED ROUTES
      routes: {
        '/sign-in': (_) => SignInPage(),
        '/login': (_) => LoginScreen(),   // if you need it

        '/dashboard': (_) => DashboardOverviewScreen(),
        '/guest-houses': (_) => const GuestHousesScreen(),
        '/edit-rooms': (_) => const EditRoomScreen(),
        '/edit-room-form': (_) => const EditRoomFormScreen(),
        '/bookings': (_) => const AllBookingsScreen(),
        '/add-admin': (_) => const AddAdminScreen(),
        '/add-guest-house': (_) => const AddGuestHouseScreen(),

        
        // '/complaints': (_) => const ComplaintsScreen(),
        '/occupancy-report': (_) =>  OccupancyReportScreen(),
        '/kyc-settings': (_) => const KYCSettingsScreen(),
        '/password-settings': (_) => const PasswordSettingsScreen(),
        '/contact-support': (_) => const ContactSupportScreen(),

        // ADMIN ROUTES
        '/admin-dashboard': (_) => const AdminDashboardPage(),
        '/admin-all-users': (_) => const AdminAllUsersPage(),
        '/admin-bookings': (_) => const AdminBookingsPage(),
        '/admin-payments': (_) => const AdminPaymentsPage(),
        '/admin-complaints': (_) => const AdminComplaintsPage(),
        '/admin-content': (_) => const AdminContentManagementPage(),
      },
    );
  }
}

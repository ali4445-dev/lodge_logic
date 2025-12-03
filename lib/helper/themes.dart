import 'package:flutter/material.dart';

// --- Color Palette (Based on Tailwind/Design) ---
class AppColors {
  // General & Utility
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray900 = Color(0xFF111827);

  // Primary Colors (Purple/Indigo for Admin/Rooms)
  static const Color primaryPurple = Color(0xFF7C3AED); // Purple 600
  static const Color primaryPurpleDark = Color(0xFF6D28D9); // Purple 700
  static const Color purple50 = Color(0xFFF3F2F8);
  static const Color purple100 = Color(0xFFEDE9FE);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color indigo100 = Color(0xFFE0E7FF);

  // Status/Feature Colors
  static const Color green600 = Color(0xFF059669); // Green/Emerald for Bookings
  static const Color green100 = Color(0xFFD1FAE5);
  static const Color blue600 = Color(0xFF2563EB); // Blue for Dashboard/Checkins
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color orange600 = Color(0xFFEA580C); // Orange for Rooms
  static const Color red600 = Color(0xFFDC2626); // Red for Complaints/Occupied
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color yellow600 = Color(0xFFF59E0B); // Yellow for Maintenance/Pending
  static const Color yellow100 = Color(0xFFFEF9C3);
  static const Color teal600 = Color(0xFF0D9488); // Teal for Support
  static const Color teal100 = Color(0xFFCCFBF1);
  static const Color pink600 = Color(0xEDEC4899); // Pink for Notifications
  static const Color pink50 = Color(0xFFFDF2F8);

  // Login Screen Colors (from login.jsx)
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate50 = Color(0xFFF8FAFC);
}

// --- Icons (Mapping Lucide-React to Material Icons) ---
class AppIcons {
  static const IconData dashboard = Icons.dashboard_rounded;
  static const IconData building = Icons.business_rounded;
  static const IconData bedDouble = Icons.bed_rounded;
  static const IconData calendarCheck = Icons.check_circle_outline;
  static const IconData history = Icons.history_rounded;
  static const IconData checkIn = Icons.login_rounded;
  static const IconData alertCircle = Icons.error_outline_rounded;
  static const IconData contact = Icons.support_agent_rounded;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData edit = Icons.edit_rounded;
  static const IconData trash = Icons.delete_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData x = Icons.close_rounded;
  static const IconData mapPin = Icons.pin_drop_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData phone = Icons.phone_rounded;
  static const IconData mail = Icons.mail_outline_rounded;
  static const IconData upload = Icons.cloud_upload_rounded;
  static final IconData fileCheck = Icons.file_copy_sharp;
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData send = Icons.send_rounded;
  static const IconData pieChart = Icons.pie_chart_outline_rounded;
  static const IconData trendingUp = Icons.trending_up_rounded;
  static const IconData trendingDown = Icons.trending_down_rounded;
  static const IconData users = Icons.people_outline_rounded;
  static const IconData square = Icons.square_foot_rounded;
  static const IconData dollar = Icons.attach_money_rounded;
  static const IconData message = Icons.message_rounded;
  static const IconData bell = Icons.notifications_none_rounded;
}

// --- Layout Constants ---
const double kSidebarWidth = 256.0;
const double kMobileBreakpoint = 800.0;
const EdgeInsets kPagePadding = EdgeInsets.all(32.0);
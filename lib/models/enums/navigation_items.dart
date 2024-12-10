import 'package:flutter/material.dart';
import 'package:fintech_dashboard_clone/screens/profile_screen.dart'; // Import your ProfileScreen
import 'package:fintech_dashboard_clone/screens/home_page.dart'; // Import your ProfileScreen

enum NavigationItems {
  home,
  users,
  panel,
  pieChart,
}

extension NavigationItemsExtensions on NavigationItems {
  IconData get icon {
    switch (this) {
      case NavigationItems.home:
        return Icons.home;
      case NavigationItems.panel:
        return Icons.bar_chart;
      case NavigationItems.pieChart:
        return Icons.pie_chart;
      case NavigationItems.users:
        return Icons.person;
      default:
        return Icons.person;
    }
  }
}

// Function to handle navigation
void navigate(BuildContext context, NavigationItems item) {
  switch (item) {
    case NavigationItems.users:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),  // Navigate to ProfileScreen
      );
      break;
    case NavigationItems.home:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),  // Navigate to HomePage
        (Route<dynamic> route) => false,  // This clears the navigation stack
      );
      break;
    // Add other cases for other navigation items if needed
    default:
      break;
  }
}

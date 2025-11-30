import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'admin_add_user.dart';
import 'admin_attendance_history.dart';
import 'admin_profile.dart';
import 'admin_subjects_page.dart';

class BottomNavigationAdmin extends StatefulWidget {
  const BottomNavigationAdmin({super.key});

  @override
  State<BottomNavigationAdmin> createState() => _BottomNavigationAdminState();
}

class _BottomNavigationAdminState extends State<BottomNavigationAdmin> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    AdminAddUserPage(),
    AdminHistoryPage(),
    AdminSubjectsPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.05)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[100]!,
              hoverColor: Colors.grey[200]!,
              gap: 8,
              activeColor: const Color(0xFF256BE8),
              tabBackgroundColor: const Color(0xFF256BE8).withOpacity(.15),
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              color: Colors.grey[600],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              tabs: const [
                GButton(icon: Icons.person_add_alt, text: "Add User"),
                GButton(icon: Icons.history, text: "History"),
                GButton(icon: Icons.book, text: "Subjects"),
                GButton(icon: Icons.admin_panel_settings, text: "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

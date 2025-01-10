import 'package:budgy/screens/analysis_screen.dart';
import 'package:budgy/screens/category_screen.dart';
import 'package:budgy/screens/home_screen.dart';
import 'package:budgy/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  // Define the pages for each navigation index
  final List<Widget> _pages = [
    HomeScreen(),
    AnalysisScreen(),
    CategoryScreen(),
    ProfileScreen(),
  ];

  CustomBottomNavBar({required this.currentIndex});

  void _navigateToPage(BuildContext context, int index) {
    // Navigate to the selected page if it's different from the current page
    if (index != currentIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 12.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              size: 35,
              color: currentIndex == 0 ? Color(0xFF97349e) : Colors.grey,
            ),
            onPressed: () => _navigateToPage(context, 0),
          ),
          IconButton(
            icon: Icon(
              Icons.analytics,
              size: 35,
              color: currentIndex == 1 ? Color(0xFF97349e) : Colors.grey,
            ),
            onPressed: () => _navigateToPage(context, 1),
          ),
          const SizedBox(width: 50), // Space for the FAB
          IconButton(
            icon: Icon(
              Icons.category,
              size: 35,
              color: currentIndex == 2 ? Color(0xFF97349e) : Colors.grey,
            ),
            onPressed: () => _navigateToPage(context, 2),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              size: 35,
              color: currentIndex == 3 ? Color(0xFF97349e) : Colors.grey,
            ),
            onPressed: () => _navigateToPage(context, 3),
          ),
        ],
      ),
    );
  }
}

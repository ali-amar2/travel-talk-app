import 'package:flutter/material.dart';
import 'package:travel_talk/features/home/presentation/screens/home_screen.dart';
import 'package:travel_talk/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:travel_talk/features/profile/presentation/screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    Center(child: Text("Map")),
    Center(child: Text("Saved")),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onTap,
      ),
      floatingActionButton: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.pink,
          onPressed: () {},
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

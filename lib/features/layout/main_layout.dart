import 'package:flutter/material.dart';
import 'package:travel_talk/features/discover/presentation/screens/discover_screen.dart';
import 'package:travel_talk/features/home/presentation/screens/home_screen.dart';
import 'package:travel_talk/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:travel_talk/features/posts/presentation/screens/create_post_screen.dart';
import 'package:travel_talk/features/profile/presentation/screens/profile_screen.dart';
import 'package:travel_talk/features/trips/presentation/screens/trips_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    DiscoverScreen(),
    TripsScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<void> _openCreatePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );

    if (result == true && mounted) {
      setState(() {
        currentIndex = 3;
      });
    }
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
          onPressed: _openCreatePost,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

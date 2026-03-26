import 'package:flutter/material.dart';
import '../domain/onboarding_usecase.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final OnboardingUseCase useCase;
  const OnboardingScreen({super.key, required this.useCase});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _controller = PageController();

  List<Widget> _pages() => [
    _buildPage(
      title: "Discover Tourist Places in Egypt",
      description:
          "Explore the best attractions, read reviews, and get detailed information.",
      image: null,
    ),
    _buildPage(
      title: "Your Journey Starts Here",
      description: "Enjoy a unique travel experience and discover new places.",
      image: "assets/images/onboarding_bg2.jpg",
    ),
  ];

  Widget _buildPage({
    required String title,
    required String description,
    String? image,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: image != null
            ? DecorationImage(image: AssetImage(image), fit: BoxFit.cover)
            : null,
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: image != null
            ? BoxDecoration(
                color: Colors.black.withOpacity(0.4), // overlay عشان النص يظهر
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: image != null ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: image != null ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages().length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await widget.useCase.completeOnboarding();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: _pages(),
          ),

          /// Skip
          Positioned(
            right: 20,
            top: 40,
            child: TextButton(
              onPressed: _skip,
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),

          /// Next Button
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                _currentPage == _pages().length - 1 ? "Start" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

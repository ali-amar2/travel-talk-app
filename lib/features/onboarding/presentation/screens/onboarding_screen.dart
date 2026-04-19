import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_talk/features/auth/data/repositories/user_repository.dart';
import 'package:travel_talk/features/layout/main_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _controller = PageController();
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false;

  List<Widget> _pages() => [
    _buildPage(
      title: 'Discover Tourist Places in Egypt',
      description:
          'Explore the best attractions, read reviews, and get detailed information.',
      image: null,
      icon: Icons.travel_explore_rounded,
    ),
    _buildPage(
      title: 'Your Journey Starts Here',
      description: 'Enjoy a unique travel experience and discover new places.',
      image: 'assets/images/onboarding_bg2.jpg',
      icon: Icons.explore_rounded,
    ),
  ];

  bool get _isLastPage => _currentPage == _pages().length - 1;

  Widget _buildPage({
    required String title,
    required String description,
    required IconData icon,
    String? image,
  }) {
    final bool hasImage = image != null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        image: hasImage
            ? DecorationImage(image: AssetImage(image), fit: BoxFit.cover)
            : null,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 120, 24, 48),
        decoration: hasImage
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.18),
                    Colors.black.withOpacity(0.42),
                    Colors.black.withOpacity(0.65),
                  ],
                ),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!hasImage)
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF1296DB).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 54, color: const Color(0xFF1296DB)),
              ),
            if (!hasImage) const SizedBox(height: 34),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: hasImage ? Colors.white.withOpacity(0.12) : Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: hasImage
                    ? Border.all(color: Colors.white.withOpacity(0.14))
                    : null,
                boxShadow: hasImage
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      color: hasImage ? Colors.white : const Color(0xFF0D1B3E),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: hasImage
                          ? Colors.white70
                          : const Color(0xFF6D7690),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        if (!mounted) return;
        Navigator.pop(context);
        return;
      }

      await _userRepository.completeOnboarding(currentUser.uid);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to complete onboarding')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _nextPage() {
    if (!_isLastPage) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  Widget _buildDotsIndicator() {
    final pagesCount = _pages().length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pagesCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFF1296DB)
                : Colors.white.withOpacity(_currentPage == 1 ? 0.45 : 0.35),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages();
    final bool isImagePage = _currentPage == 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: pages,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : _skip,
                      style: TextButton.styleFrom(
                        backgroundColor: isImagePage
                            ? Colors.white.withOpacity(0.14)
                            : Colors.white,
                        foregroundColor: isImagePage
                            ? Colors.white
                            : const Color(0xFF0D1B3E),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildDotsIndicator(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1296DB),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isLastPage ? 'Start Exploring' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
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
    );
  }
}

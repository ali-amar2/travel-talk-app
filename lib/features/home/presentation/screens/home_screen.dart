import 'package:flutter/material.dart';
import 'package:travel_talk/features/posts/data/repositories/post_repository.dart';
import 'package:travel_talk/features/posts/domain/entities/user_post.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/home_repository.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../widgets/destination_card.dart';
import '../widgets/firestore_post_card.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GetHomeDataUseCase _getHomeDataUseCase;
  final PostRepository _postRepository = PostRepository();

  HomeData? _homeData;
  bool _isLoading = true;

  final List<String> _postCategories = const [
    'All',
    'Beach',
    'Safari',
    'Cultural & Historical',
    'Medical & Wellness',
    'Entertainment',
  ];

  String _selectedPostCategory = 'All';

  @override
  void initState() {
    super.initState();
    _getHomeDataUseCase = GetHomeDataUseCase(repository: HomeRepository());
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    final data = await _getHomeDataUseCase();
    if (!mounted) return;

    setState(() {
      _homeData = data;
      _isLoading = false;
    });
  }

  void _selectPostCategory(String category) {
    setState(() {
      _selectedPostCategory = category;
    });
  }

  Widget _buildSectionTitle({
    required String title,
    String? subtitle,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (actionText != null)
              GestureDetector(
                onTap: onActionTap,
                child: Text(
                  actionText,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeroIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1296DB).withOpacity(0.12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Egypt',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Explore iconic destinations, hidden gems, and authentic local experiences across Egypt.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection(HomeData data) {
    return SizedBox(
      height: 265,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: data.trendingDestinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = data.trendingDestinations[index];
          return DestinationCard(destination: item, width: 240, height: 265);
        },
      ),
    );
  }

  Widget _buildPostFilterCategories() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _postCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = _postCategories[index];
          final isSelected = _selectedPostCategory == category;

          return GestureDetector(
            onTap: () => _selectPostCategory(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFE3E8EF),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFirestoreCommunitySection() {
    return StreamBuilder<List<UserPost>>(
      stream: _postRepository.watchAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              'Failed to load posts: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final allPosts = snapshot.data ?? [];
        final posts = _selectedPostCategory == 'All'
            ? allPosts
            : allPosts
                  .where((post) => post.category == _selectedPostCategory)
                  .toList();

        if (posts.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.post_add_rounded,
                  size: 38,
                  color: Color(0xFF9AA3B2),
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedPostCategory == 'All'
                      ? 'No posts yet'
                      : 'No posts in $_selectedPostCategory',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _selectedPostCategory == 'All'
                      ? 'Posts from travelers will appear here.'
                      : 'Posts for this category will appear here.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7F88A3),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: List.generate(
            posts.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == posts.length - 1 ? 0 : 16,
              ),
              child: FirestorePostCard(post: posts[index]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _homeData == null
            ? const Center(child: Text('Failed to load data'))
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      const SizedBox(height: 24),
                      _buildHeroIntro(),
                      const SizedBox(height: 28),
                      _buildSectionTitle(
                        title: 'Top places in Egypt',
                        subtitle:
                            'Handpicked destinations for unforgettable travel experiences.',
                      ),
                      const SizedBox(height: 16),
                      _buildTrendingSection(_homeData!),
                      const SizedBox(height: 32),
                      _buildSectionTitle(
                        title: 'Explore Community',
                        subtitle:
                            'See what travelers are sharing across Egypt.',
                      ),
                      const SizedBox(height: 16),
                      _buildPostFilterCategories(),
                      const SizedBox(height: 16),
                      _buildFirestoreCommunitySection(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

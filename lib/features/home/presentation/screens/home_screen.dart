import 'package:flutter/material.dart';
import 'package:travel_talk/features/posts/data/repositories/post_repository.dart';
import 'package:travel_talk/features/posts/domain/entities/user_post.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/home_repository.dart';
import '../../domain/entities/category_item.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../widgets/category_chip_item.dart';
import '../widgets/destination_card.dart';
import '../widgets/firestore_post_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';

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

  void _selectCategory(int selectedIndex) {
    if (_homeData == null) return;

    final updatedCategories = _homeData!.categories.asMap().entries.map((
      entry,
    ) {
      final index = entry.key;
      final item = entry.value;
      return item.copyWith(isSelected: index == selectedIndex);
    }).toList();

    setState(() {
      _homeData = HomeData(
        categories: updatedCategories,
        trendingDestinations: _homeData!.trendingDestinations,
        communityDestinations: _homeData!.communityDestinations,
        communityPosts: _homeData!.communityPosts,
      );
    });
  }

  Widget _buildSectionTitle({
    required String title,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
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
    );
  }

  Widget _buildCategories(List<CategoryItem> categories) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return CategoryChipItem(
            item: categories[index],
            onTap: () => _selectCategory(index),
          );
        },
      ),
    );
  }

  Widget _buildTrendingSection(HomeData data) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: data.trendingDestinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = data.trendingDestinations[index];
          final width = index == 0 ? 220.0 : 150.0;

          return DestinationCard(destination: item, width: width, height: 250);
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

        final posts = snapshot.data ?? [];

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
            child: const Column(
              children: [
                Icon(
                  Icons.post_add_rounded,
                  size: 38,
                  color: Color(0xFF9AA3B2),
                ),
                SizedBox(height: 12),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Posts from users will appear here.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7F88A3)),
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
                      const HomeSearchBar(),
                      const SizedBox(height: 18),
                      _buildCategories(_homeData!.categories),
                      const SizedBox(height: 28),
                      _buildSectionTitle(
                        title: 'Trending Destinations',
                        actionText: 'See all',
                        onActionTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _buildTrendingSection(_homeData!),
                      const SizedBox(height: 28),
                      _buildSectionTitle(title: 'Community Insights'),
                      const SizedBox(height: 16),
                      _buildFirestoreCommunitySection(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

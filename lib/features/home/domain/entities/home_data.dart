import 'category_item.dart';
import 'community_post.dart';
import 'destination.dart';

class HomeData {
  final List<CategoryItem> categories;
  final List<Destination> trendingDestinations;
  final List<Destination> communityDestinations;
  final List<CommunityPost> communityPosts;

  const HomeData({
    required this.categories,
    required this.trendingDestinations,
    required this.communityDestinations,
    required this.communityPosts,
  });
}

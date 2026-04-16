import '../domain/entities/category_item.dart';
import '../domain/entities/community_post.dart';
import '../domain/entities/destination.dart';
import '../domain/entities/home_data.dart';

class HomeRepository {
  Future<HomeData> getHomeData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const HomeData(
      categories: [
        CategoryItem(title: 'Beach', emoji: '🏖️', isSelected: true),
        CategoryItem(title: 'Safari', emoji: '🏕️'),
        CategoryItem(title: 'Winter', emoji: '❄️'),
      ],
      trendingDestinations: [
        Destination(
          title: 'Dahab, Egypt',
          subtitle: 'Explore now',
          imagePath: 'assets/images/dahab.jpg',
          rating: 4.9,
        ),
        Destination(
          title: 'Desert Dune',
          subtitle: 'Explore now',
          imagePath: 'assets/images/desert.jpg',
          rating: 4.7,
        ),
      ],
      communityDestinations: [
        Destination(
          title: 'Siwa Oasis',
          subtitle: 'Popular with travelers',
          imagePath: 'assets/images/siwa.jpg',
          rating: 4.8,
        ),
        Destination(
          title: 'Luxor',
          subtitle: 'Historical wonders',
          imagePath: 'assets/images/luxor.jpg',
          rating: 4.9,
        ),
      ],
      communityPosts: [
        CommunityPost(
          userName: 'Sarah Jenkins',
          userImage: 'assets/images/user1.jpg',
          timeAgo: '2 hours ago',
          location: 'Ali Baba Restaurant',
          postImage: 'assets/images/post1.jpg',
          content:
              'Had the most amazing local seafood platter here. The ambiance is just perfect for a chill evening! Highly recommend trying their signature dish. 👌🌅',
          likesCount: 124,
          commentsCount: 18,
          isSaved: false,
        ),
        CommunityPost(
          userName: 'Omar Khaled',
          userImage: 'assets/images/user2.jpg',
          timeAgo: '5 hours ago',
          location: 'Blue Lagoon',
          postImage: 'assets/images/post2.jpg',
          content:
              'One of the clearest waters I have ever seen. A perfect place to relax, swim, and enjoy the view with friends.',
          likesCount: 98,
          commentsCount: 11,
          isSaved: true,
        ),
      ],
    );
  }
}

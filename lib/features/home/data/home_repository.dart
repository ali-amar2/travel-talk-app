import '../domain/entities/destination.dart';
import '../domain/entities/home_data.dart';

class HomeRepository {
  Future<HomeData> getHomeData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const HomeData(
      categories: [],
      trendingDestinations: [
        Destination(
          title: 'Cairo',
          subtitle: 'History, culture, and vibrant city life',
          imagePath: 'assets/images/cairo.webp',
          rating: 4.9,
          location: 'Cairo, Egypt',
          description:
              'Cairo is the heart of Egypt, blending ancient history with modern urban energy. From the Pyramids of Giza to the bustling Khan El Khalili market, it offers unforgettable cultural experiences.',
          highlights: [
            'Pyramids of Giza',
            'The Egyptian Museum',
            'Khan El Khalili',
            'Nile River views',
          ],
          bestTimeToVisit: 'October to April',
        ),
        Destination(
          title: 'Sharm El Sheikh',
          subtitle: 'Crystal water and luxury seaside escapes',
          imagePath: 'assets/images/sharm.jpg',
          rating: 4.8,
          location: 'South Sinai, Egypt',
          description:
              'Sharm El Sheikh is one of Egypt’s top beach destinations, known for luxury resorts, diving spots, and clear Red Sea waters.',
          highlights: [
            'Red Sea diving',
            'Luxury resorts',
            'Desert safari',
            'Naama Bay',
          ],
          bestTimeToVisit: 'March to May, September to November',
        ),
        Destination(
          title: 'Luxor',
          subtitle: 'Ancient temples and timeless wonders',
          imagePath: 'assets/images/luxor.jpg',
          rating: 4.9,
          location: 'Luxor, Upper Egypt',
          description:
              'Luxor is often called the world’s greatest open-air museum, home to extraordinary temples, tombs, and monuments from ancient Egypt.',
          highlights: [
            'Karnak Temple',
            'Valley of the Kings',
            'Luxor Temple',
            'Nile cruises',
          ],
          bestTimeToVisit: 'October to April',
        ),
        Destination(
          title: 'Siwa Oasis',
          subtitle: 'Nature, serenity, and desert beauty',
          imagePath: 'assets/images/siwa.webp',
          rating: 4.7,
          location: 'Matrouh, Egypt',
          description:
              'Siwa Oasis is a peaceful desert escape known for salt lakes, palm groves, natural springs, and unique Amazigh culture.',
          highlights: [
            'Salt lakes',
            'Desert camping',
            'Temple of the Oracle',
            'Natural springs',
          ],
          bestTimeToVisit: 'October to March',
        ),
      ],
      communityDestinations: [],
      communityPosts: [],
    );
  }
}

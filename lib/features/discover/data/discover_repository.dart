import 'package:flutter/material.dart';
import '../domain/entities/discover_city.dart';
import '../domain/entities/discover_data.dart';
import '../domain/entities/recommended_place.dart';
import '../domain/entities/vibe_item.dart';

class DiscoverRepository {
  Future<DiscoverData> getDiscoverData() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const DiscoverData(
      popularCities: [
        DiscoverCity(
          name: 'Cairo',
          imagePath: 'assets/images/cairo.webp',
          description:
              'Egypt’s vibrant capital, filled with iconic history, museums, and old Islamic streets.',
          attractions: [
            'Pyramids of Giza',
            'The Egyptian Museum',
            'Khan El Khalili',
            'Cairo Tower',
          ],
        ),
        DiscoverCity(
          name: 'Alexandria',
          imagePath: 'assets/images/alexandria.jpg',
          description:
              'A Mediterranean gem known for its sea views, libraries, and Greco-Roman charm.',
          attractions: [
            'Bibliotheca Alexandrina',
            'Citadel of Qaitbay',
            'Montaza Palace',
            'Stanley Bridge',
          ],
        ),
        DiscoverCity(
          name: 'Luxor',
          imagePath: 'assets/images/luxor.jpg',
          description:
              'A timeless open-air museum with some of Egypt’s most impressive ancient temples and tombs.',
          attractions: [
            'Karnak Temple',
            'Luxor Temple',
            'Valley of the Kings',
            'Hatshepsut Temple',
          ],
        ),
        DiscoverCity(
          name: 'Aswan',
          imagePath: 'assets/images/aswan.jpg',
          description:
              'A peaceful Nile destination famous for Nubian culture, islands, and scenic river views.',
          attractions: [
            'Philae Temple',
            'Nubian Village',
            'Elephantine Island',
            'High Dam',
          ],
        ),
        DiscoverCity(
          name: 'Dahab',
          imagePath: 'assets/images/dahab.jpg',
          description:
              'A laid-back Red Sea destination loved for diving, beach vibes, and mountain adventures.',
          attractions: [
            'Blue Hole',
            'Lagoona',
            'Mount Sinai Trips',
            'Dahab Promenade',
          ],
        ),
        DiscoverCity(
          name: 'Sharm El Sheikh',
          imagePath: 'assets/images/sharm.jpg',
          description:
              'A luxury beach escape with diving, resorts, and lively entertainment.',
          attractions: [
            'Naama Bay',
            'Ras Mohamed',
            'SOHO Square',
            'Shark’s Bay',
          ],
        ),
        DiscoverCity(
          name: 'Siwa',
          imagePath: 'assets/images/siwa.webp',
          description:
              'A serene oasis surrounded by desert beauty, springs, and unique local culture.',
          attractions: [
            'Salt Lakes',
            'Temple of the Oracle',
            'Cleopatra Spring',
            'Great Sand Sea',
          ],
        ),
        DiscoverCity(
          name: 'Hurghada',
          imagePath: 'assets/images/hurghada.jpg',
          description:
              'A lively Red Sea city perfect for island trips, water sports, and resort stays.',
          attractions: [
            'Giftun Island',
            'Marina Hurghada',
            'Desert Safari',
            'Snorkeling Spots',
          ],
        ),
      ],
      vibes: [
        VibeItem(
          title: 'Beach',
          emoji: '🏖️',
          backgroundColor: Color(0xFFEAF6FF),
          description:
              'Perfect for sea lovers, sun, diving, and relaxing getaways by the Red Sea and Mediterranean coast.',
          places: [
            'Sharm El Sheikh',
            'Dahab',
            'Hurghada',
            'Marsa Alam',
            'North Coast',
          ],
        ),
        VibeItem(
          title: 'Desert',
          emoji: '🏕️',
          backgroundColor: Color(0xFFFFF2E2),
          description:
              'Ideal for desert safaris, camping, oasis escapes, and magical landscapes.',
          places: [
            'Siwa Oasis',
            'White Desert',
            'Bahariya Oasis',
            'Great Sand Sea',
            'Sinai Desert',
          ],
        ),
        VibeItem(
          title: 'Historical',
          emoji: '🏛️',
          backgroundColor: Color(0xFFE5F8F4),
          description:
              'For travelers who love temples, tombs, museums, and ancient Egyptian heritage.',
          places: ['Luxor', 'Aswan', 'Cairo', 'Saqqara', 'Abu Simbel'],
        ),
        VibeItem(
          title: 'Entertainment',
          emoji: '🎪',
          backgroundColor: Color(0xFFFBECEF),
          description:
              'Best for lively nights, family fun, shopping, cafes, and modern attractions.',
          places: [
            'Cairo Festival City',
            'SOHO Square',
            'Naama Bay',
            'Alexandria Corniche',
            'Hurghada Marina',
          ],
        ),
      ],
      recommendedPlaces: [
        RecommendedPlace(
          title: 'Dahab Escape',
          location: 'South Sinai, Egypt',
          imagePath: 'assets/images/dahab.jpg',
          rating: 4.9,
        ),
        RecommendedPlace(
          title: 'Siwa Oasis Camp',
          location: 'Siwa, Egypt',
          imagePath: 'assets/images/siwa.webp',
          rating: 4.8,
        ),
        RecommendedPlace(
          title: 'Luxor Palace View',
          location: 'Luxor, Egypt',
          imagePath: 'assets/images/luxor.jpg',
          rating: 4.9,
        ),
        RecommendedPlace(
          title: 'Cairo Heritage Walk',
          location: 'Cairo, Egypt',
          imagePath: 'assets/images/cairo.webp',
          rating: 4.7,
        ),
        RecommendedPlace(
          title: 'Alexandria Sea Breeze',
          location: 'Alexandria, Egypt',
          imagePath: 'assets/images/alexandria.jpg',
          rating: 4.6,
        ),
        RecommendedPlace(
          title: 'Aswan Nile Retreat',
          location: 'Aswan, Egypt',
          imagePath: 'assets/images/aswan.jpg',
          rating: 4.8,
        ),
        RecommendedPlace(
          title: 'Hurghada Island Trip',
          location: 'Hurghada, Egypt',
          imagePath: 'assets/images/hurghada.jpg',
          rating: 4.7,
        ),
      ],
    );
  }
}

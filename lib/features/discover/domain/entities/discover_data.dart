import 'discover_city.dart';
import 'recommended_place.dart';
import 'vibe_item.dart';

class DiscoverData {
  final List<DiscoverCity> popularCities;
  final List<VibeItem> vibes;
  final List<RecommendedPlace> recommendedPlaces;

  const DiscoverData({
    required this.popularCities,
    required this.vibes,
    required this.recommendedPlaces,
  });
}

import 'package:flutter/material.dart';
import 'package:travel_talk/features/discover/data/discover_repository.dart';
import 'package:travel_talk/features/discover/domain/entities/discover_data.dart';
import 'package:travel_talk/features/discover/domain/entities/discover_city.dart';
import 'package:travel_talk/features/discover/domain/entities/vibe_item.dart';
import 'package:travel_talk/features/discover/domain/usecases/get_discover_data_usecase.dart';
import 'package:travel_talk/features/discover/presentation/screens/all_recommended_places_screen.dart';
import 'package:travel_talk/features/discover/presentation/screens/city_details_screen.dart';
import 'package:travel_talk/features/discover/presentation/screens/vibe_details_screen.dart';
import 'package:travel_talk/features/discover/presentation/widgets/popular_city_item.dart';
import 'package:travel_talk/features/discover/presentation/widgets/recommended_place_card.dart';
import 'package:travel_talk/features/discover/presentation/widgets/vibe_card.dart';
import '../../../../core/theme/app_colors.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final GetDiscoverDataUseCase _getDiscoverDataUseCase;

  DiscoverData? _discoverData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDiscoverDataUseCase = GetDiscoverDataUseCase(
      repository: DiscoverRepository(),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _getDiscoverDataUseCase();
    if (!mounted) return;

    setState(() {
      _discoverData = data;
      _isLoading = false;
    });
  }

  void _openCityDetails(DiscoverCity city) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CityDetailsScreen(city: city)),
    );
  }

  void _openVibeDetails(VibeItem vibe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VibeDetailsScreen(vibe: vibe)),
    );
  }

  void _openAllRecommendedPlaces() {
    if (_discoverData == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AllRecommendedPlacesScreen(
          places: _discoverData!.recommendedPlaces,
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPopularCitiesSection() {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _discoverData!.popularCities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final city = _discoverData!.popularCities[index];

          return PopularCityItem(
            city: city,
            onTap: () => _openCityDetails(city),
          );
        },
      ),
    );
  }

  Widget _buildVibesSection() {
    return GridView.builder(
      itemCount: _discoverData!.vibes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final vibe = _discoverData!.vibes[index];

        return VibeCard(item: vibe, onTap: () => _openVibeDetails(vibe));
      },
    );
  }

  Widget _buildRecommendedPlacesSection() {
    final previewPlaces = _discoverData!.recommendedPlaces.take(3).toList();

    return Column(
      children: List.generate(
        previewPlaces.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index == previewPlaces.length - 1 ? 0 : 14,
          ),
          child: RecommendedPlaceCard(place: previewPlaces[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _discoverData == null
            ? const Center(child: Text('Failed to load discover data'))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle(title: 'Popular Cities'),
                    const SizedBox(height: 14),
                    _buildPopularCitiesSection(),
                    const SizedBox(height: 28),
                    _buildSectionTitle(title: 'Explore by Vibe'),
                    const SizedBox(height: 14),
                    _buildVibesSection(),
                    const SizedBox(height: 28),
                    _buildSectionTitle(
                      title: 'Recommended Places',
                      actionText: 'See all',
                      onTap: _openAllRecommendedPlaces,
                    ),
                    const SizedBox(height: 14),
                    _buildRecommendedPlacesSection(),
                  ],
                ),
              ),
      ),
    );
  }
}

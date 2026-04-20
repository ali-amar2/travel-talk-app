import 'package:flutter/material.dart';
import '../../domain/entities/recommended_place.dart';
import '../widgets/recommended_place_card.dart';

class AllRecommendedPlacesScreen extends StatelessWidget {
  final List<RecommendedPlace> places;

  const AllRecommendedPlacesScreen({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F5F7),
        foregroundColor: const Color(0xFF0D1B3E),
        title: const Text(
          'All Recommended Places',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        itemCount: places.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          return RecommendedPlaceCard(place: places[index]);
        },
      ),
    );
  }
}

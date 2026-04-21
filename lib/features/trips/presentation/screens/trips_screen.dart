import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_talk/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_talk/features/trips/domain/entities/trip_item.dart';
import 'package:travel_talk/features/trips/presentation/screens/create_trip_screen.dart';
import 'package:travel_talk/features/trips/presentation/screens/trip_details_screen.dart';
import 'package:travel_talk/features/trips/presentation/widgets/trip_card.dart';
import '../../../../core/theme/app_colors.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  bool _showMyTrips = false;
  final TripRepository _tripRepository = TripRepository();

  Future<void> _openCreateTrip() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTripScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: currentUser == null
            ? const Center(child: Text('No user found'))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trips',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F1F5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _TabButton(
                                  title: 'Explore Trips',
                                  isSelected: !_showMyTrips,
                                  onTap: () {
                                    setState(() {
                                      _showMyTrips = false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: _TabButton(
                                  title: 'My Trips',
                                  isSelected: _showMyTrips,
                                  onTap: () {
                                    setState(() {
                                      _showMyTrips = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openCreateTrip,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1296DB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Plan a Trip',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _showMyTrips
                        ? _buildTripsList(
                            stream: _tripRepository.watchMyTrips(
                              currentUser.uid,
                            ),
                            emptyTitle: 'You haven’t planned any trips yet.',
                            emptySubtitle:
                                'Create your first trip and start exploring.',
                          )
                        : _buildTripsList(
                            stream: _tripRepository.watchAllTrips(),
                            excludeUserId: currentUser.uid,
                            emptyTitle: 'No trips available right now.',
                            emptySubtitle:
                                'Be the first traveler to create one.',
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTripsList({
    required Stream<List<TripItem>> stream,
    String? excludeUserId,
    required String emptyTitle,
    required String emptySubtitle,
  }) {
    return StreamBuilder<List<TripItem>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'We could not load trips right now. Please try again in a moment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.6,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var trips = snapshot.data ?? [];

        if (excludeUserId != null) {
          trips = trips
              .where((trip) => trip.creatorId != excludeUserId)
              .toList();
        }

        if (trips.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.travel_explore_rounded,
                    size: 44,
                    color: Color(0xFF9AA3B2),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    emptyTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D1B3E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    emptySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xFF7F88A3),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          itemCount: trips.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final trip = trips[index];

            return StreamBuilder<int>(
              stream: _tripRepository.watchAcceptedParticipantsCount(trip.id),
              builder: (context, countSnapshot) {
                final count = countSnapshot.data ?? 0;

                return TripCard(
                  trip: trip,
                  participantsCount: count,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TripDetailsScreen(trip: trip),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? const Color(0xFF0D1B3E)
                : const Color(0xFF7F88A3),
          ),
        ),
      ),
    );
  }
}

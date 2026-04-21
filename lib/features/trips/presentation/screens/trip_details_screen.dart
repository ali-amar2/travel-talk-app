import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_talk/features/auth/data/repositories/user_repository.dart';
import 'package:travel_talk/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_talk/features/trips/domain/entities/trip_item.dart';
import 'package:travel_talk/features/trips/presentation/screens/trip_requests_screen.dart';
import '../../../../core/theme/app_colors.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripItem trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isOwner = currentUser?.uid == trip.creatorId;
    final tripRepository = TripRepository();
    final userRepository = UserRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: trip.coverImageUrl.isNotEmpty
                  ? Image.network(
                      trip.coverImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300),
                    )
                  : Container(color: Colors.grey.shade300),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(trip.destination),
                      _chip('${trip.days} days'),
                      _chip(trip.category),
                      StreamBuilder<int>(
                        stream: tripRepository.watchAcceptedParticipantsCount(
                          trip.id,
                        ),
                        builder: (context, snapshot) {
                          final joined = snapshot.data ?? 0;
                          final spots = (trip.maxPeople - joined) < 0
                              ? 0
                              : trip.maxPeople - joined;
                          return _chip('$spots spots left');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: userRepository.getUserById(trip.creatorId),
                    builder: (context, snapshot) {
                      final userData = snapshot.data;
                      final userName =
                          (userData?['name'] as String?)?.trim().isNotEmpty ==
                              true
                          ? userData!['name'] as String
                          : 'Unknown User';
                      final photoUrl = (userData?['photoUrl'] as String?) ?? '';

                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFFE9EEF6),
                            backgroundImage: photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : null,
                            child: photoUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    color: Color(0xFF7F88A3),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Created by $userName',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Trip Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    trip.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 26),
                  if (currentUser != null)
                    isOwner
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TripRequestsScreen(trip: trip),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1296DB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'View Join Requests',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                        : StreamBuilder<String?>(
                            stream: tripRepository.watchMyRequestStatus(
                              tripId: trip.id,
                              userId: currentUser.uid,
                            ),
                            builder: (context, snapshot) {
                              final status = snapshot.data;

                              String label = 'Request to Join';
                              bool enabled = true;

                              if (status == 'pending') {
                                label = 'Request Pending';
                                enabled = false;
                              } else if (status == 'accepted') {
                                label = 'Joined';
                                enabled = false;
                              } else if (status == 'rejected') {
                                label = 'Request Rejected';
                                enabled = false;
                              }

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: enabled
                                      ? () async {
                                          await tripRepository.requestToJoin(
                                            tripId: trip.id,
                                            userId: currentUser.uid,
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1296DB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

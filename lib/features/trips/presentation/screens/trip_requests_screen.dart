import 'package:flutter/material.dart';
import 'package:travel_talk/features/auth/data/repositories/user_repository.dart';
import 'package:travel_talk/features/trips/data/repositories/trip_repository.dart';
import 'package:travel_talk/features/trips/domain/entities/trip_item.dart';
import 'package:travel_talk/features/trips/domain/entities/trip_join_request.dart';
import '../../../../core/theme/app_colors.dart';

class TripRequestsScreen extends StatelessWidget {
  final TripItem trip;

  const TripRequestsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final repository = TripRepository();
    final userRepository = UserRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F5F7),
        foregroundColor: const Color(0xFF0D1B3E),
        title: const Text(
          'Join Requests',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<List<TripJoinRequest>>(
        stream: repository.watchTripRequests(trip.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load requests'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = (snapshot.data ?? [])
              .where((request) => request.status == 'pending')
              .toList();

          if (requests.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No join requests yet.\nWhen travelers request to join your trip, they will appear here.',
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

          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final request = requests[index];

              return FutureBuilder<Map<String, dynamic>?>(
                future: userRepository.getUserById(request.userId),
                builder: (context, userSnapshot) {
                  final userData = userSnapshot.data;
                  final userName =
                      (userData?['name'] as String?)?.trim().isNotEmpty == true
                      ? userData!['name'] as String
                      : 'Unknown User';
                  final photoUrl = (userData?['photoUrl'] as String?) ?? '';

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
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
                                userName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  await repository.rejectRequest(
                                    tripId: trip.id,
                                    userId: request.userId,
                                  );
                                },
                                child: const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await repository.acceptRequest(
                                    tripId: trip.id,
                                    userId: request.userId,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1296DB),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Accept'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

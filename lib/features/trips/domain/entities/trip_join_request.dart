import 'package:cloud_firestore/cloud_firestore.dart';

class TripJoinRequest {
  final String userId;
  final String status;
  final DateTime? requestedAt;

  const TripJoinRequest({
    required this.userId,
    required this.status,
    required this.requestedAt,
  });

  factory TripJoinRequest.fromMap(Map<String, dynamic> map) {
    final timestamp = map['requestedAt'];

    return TripJoinRequest(
      userId: map['userId'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      requestedAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}

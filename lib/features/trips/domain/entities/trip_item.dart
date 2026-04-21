import 'package:cloud_firestore/cloud_firestore.dart';

class TripItem {
  final String id;
  final String creatorId;
  final String title;
  final String destination;
  final int days;
  final String description;
  final String category;
  final int maxPeople;
  final String coverImageUrl;
  final DateTime? createdAt;

  const TripItem({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.destination,
    required this.days,
    required this.description,
    required this.category,
    required this.maxPeople,
    required this.coverImageUrl,
    required this.createdAt,
  });

  factory TripItem.fromMap(String id, Map<String, dynamic> map) {
    final timestamp = map['createdAt'];

    return TripItem(
      id: id,
      creatorId: map['creatorId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      days: (map['days'] as num?)?.toInt() ?? 0,
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      maxPeople: (map['maxPeople'] as num?)?.toInt() ?? 0,
      coverImageUrl: map['coverImageUrl'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}

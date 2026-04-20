import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  final String id;
  final String userId;
  final String description;
  final String imageUrl;
  final String category;
  final String location;
  final DateTime? createdAt;

  const UserPost({
    required this.id,
    required this.userId,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.createdAt,
  });

  factory UserPost.fromMap(String id, Map<String, dynamic> map) {
    final timestamp = map['createdAt'];

    return UserPost(
      id: id,
      userId: map['userId'] as String? ?? map['ownerUserId'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      category: map['category'] as String? ?? '',
      location: map['location'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}

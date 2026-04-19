import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  final String id;
  final String userId;
  final String description;
  final String imagePath;
  final DateTime? createdAt;

  const UserPost({
    required this.id,
    required this.userId,
    required this.description,
    required this.imagePath,
    required this.createdAt,
  });

  factory UserPost.fromMap(String id, Map<String, dynamic> map) {
    final timestamp = map['createdAt'];

    return UserPost(
      id: id,
      userId: map['userId'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}

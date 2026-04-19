import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_talk/features/posts/domain/entities/user_post.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firestore.collection('posts');

  Future<void> createPost({
    required String userId,
    required String description,
    required String imagePath,
  }) async {
    await _postsCollection.add({
      'userId': userId,
      'description': description,
      'imagePath': imagePath,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<UserPost>> watchUserPosts(String userId) {
    return _postsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserPost.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<UserPost>> watchAllPosts() {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserPost.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}

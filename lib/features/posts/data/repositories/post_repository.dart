import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_talk/features/posts/domain/entities/user_post.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firestore.collection('posts');

  CollectionReference<Map<String, dynamic>> _postLikesCollection(
    String postId,
  ) => _postsCollection.doc(postId).collection('likes');

  CollectionReference<Map<String, dynamic>> _userLikedPostsCollection(
    String userId,
  ) => _firestore.collection('users').doc(userId).collection('liked_posts');

  Future<void> createPost({
    required String userId,
    required String description,
    required String imageUrl,
    required String category,
    required String location,
  }) async {
    await _postsCollection.add({
      'userId': userId,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'location': location,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePost({
    required String postId,
    required String description,
    required String category,
    required String location,
  }) async {
    await _postsCollection.doc(postId).update({
      'description': description,
      'category': category,
      'location': location,
    });
  }

  Future<void> deletePost(String postId) async {
    final likesSnapshot = await _postLikesCollection(postId).get();

    for (final likeDoc in likesSnapshot.docs) {
      final userId = likeDoc.id;

      await _userLikedPostsCollection(userId).doc(postId).delete();
      await likeDoc.reference.delete();
    }

    await _postsCollection.doc(postId).delete();
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

  Stream<int> watchLikesCount(String postId) {
    return _postLikesCollection(
      postId,
    ).snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<bool> watchIsPostLiked({
    required String postId,
    required String userId,
  }) {
    return _postLikesCollection(
      postId,
    ).doc(userId).snapshots().map((doc) => doc.exists);
  }

  Future<bool> isPostLiked({
    required String postId,
    required String userId,
  }) async {
    final doc = await _postLikesCollection(postId).doc(userId).get();
    return doc.exists;
  }

  Future<void> toggleLike({
    required UserPost post,
    required String userId,
  }) async {
    final likeDocRef = _postLikesCollection(post.id).doc(userId);
    final likedPostRef = _userLikedPostsCollection(userId).doc(post.id);

    final likeDoc = await likeDocRef.get();

    if (likeDoc.exists) {
      await likeDocRef.delete();
      await likedPostRef.delete();
      return;
    }

    await likeDocRef.set({
      'userId': userId,
      'postId': post.id,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await likedPostRef.set({
      'postId': post.id,
      'ownerUserId': post.userId,
      'description': post.description,
      'imageUrl': post.imageUrl,
      'category': post.category,
      'location': post.location,
      'createdAt': post.createdAt != null
          ? Timestamp.fromDate(post.createdAt!)
          : FieldValue.serverTimestamp(),
      'likedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<UserPost>> watchLikedPosts(String userId) {
    return _userLikedPostsCollection(userId)
        .orderBy('likedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserPost.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _usersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': '',
      'photoUrl': '',
      'onboardingCompleted': false,
      'placesVisited': 24,
      'reviews': 112,
      'followers': 8400,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserById(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    return doc.data();
  }

  Stream<Map<String, dynamic>?> watchUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) => doc.data());
  }

  Future<void> completeOnboarding(String uid) async {
    await _usersCollection.doc(uid).update({
      'onboardingCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String bio,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'bio': bio,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (photoUrl != null) {
      data['photoUrl'] = photoUrl;
    }

    await _usersCollection.doc(uid).update(data);
  }
}

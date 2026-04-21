import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_talk/features/trips/domain/entities/trip_item.dart';
import 'package:travel_talk/features/trips/domain/entities/trip_join_request.dart';

class TripRepository {
  final FirebaseFirestore _firestore;

  TripRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tripsCollection =>
      _firestore.collection('trips');

  CollectionReference<Map<String, dynamic>> _requestsCollection(
    String tripId,
  ) => _tripsCollection.doc(tripId).collection('requests');

  CollectionReference<Map<String, dynamic>> _participantsCollection(
    String tripId,
  ) => _tripsCollection.doc(tripId).collection('participants');

  Future<void> createTrip({
    required String creatorId,
    required String title,
    required String destination,
    required int days,
    required String description,
    required String category,
    required int maxPeople,
    required String coverImageUrl,
  }) async {
    await _tripsCollection.add({
      'creatorId': creatorId,
      'title': title,
      'destination': destination,
      'days': days,
      'description': description,
      'category': category,
      'maxPeople': maxPeople,
      'coverImageUrl': coverImageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<TripItem>> watchAllTrips() {
    return _tripsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TripItem.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<TripItem>> watchMyTrips(String userId) {
    return _tripsCollection
        .where('creatorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TripItem.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<int> watchAcceptedParticipantsCount(String tripId) {
    return _participantsCollection(
      tripId,
    ).snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<String?> watchMyRequestStatus({
    required String tripId,
    required String userId,
  }) {
    return _requestsCollection(
      tripId,
    ).doc(userId).snapshots().map((doc) => doc.data()?['status'] as String?);
  }

  Future<void> requestToJoin({
    required String tripId,
    required String userId,
  }) async {
    final existingParticipant = await _participantsCollection(
      tripId,
    ).doc(userId).get();
    if (existingParticipant.exists) return;

    await _requestsCollection(tripId).doc(userId).set({
      'userId': userId,
      'status': 'pending',
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<TripJoinRequest>> watchTripRequests(String tripId) {
    return _requestsCollection(tripId)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TripJoinRequest.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> acceptRequest({
    required String tripId,
    required String userId,
  }) async {
    await _requestsCollection(
      tripId,
    ).doc(userId).update({'status': 'accepted'});

    await _participantsCollection(tripId).doc(userId).set({
      'userId': userId,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectRequest({
    required String tripId,
    required String userId,
  }) async {
    await _requestsCollection(tripId).doc(userId).set({
      'userId': userId,
      'status': 'rejected',
      'requestedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/config/Paths.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/repositories/repositories.dart';
import 'package:meta/meta.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({@required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({@required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({@required String query}) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .get();
    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void followUser({@required String userId, @required String followUserId}) {
    // Add followUser to user's unFollowing
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});
    // Add user to followUser's userFollowers
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(userId)
        .collection(Paths.userFollowers)
        .doc(followUserId)
        .set({});
  }

  @override
  void unfollowUser(
      {@required String userId, @required String unfollowUserId}) {
    //Remove unfollowUser from user's userFollowing
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        .delete();
    //Remove user from unfollowUser's userFollowers
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(userId)
        .collection(Paths.userFollowers)
        .doc(unfollowUserId)
        .delete();
  }

  @override
  Future<bool> isFollowing(
      {@required String userId, @required String otherUserId}) async {
    //otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }
}

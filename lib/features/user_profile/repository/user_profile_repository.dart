import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failures.dart';
import 'package:reddit_clone/core/providers/firbase_provider.dart';
import 'package:reddit_clone/models/user_model.dart';

import '../../../core/type_defs.dart';

final userProfileRepositoryProvider = Provider(
    (ref) => UserProfileRepository(firestore: ref.watch(firestoreProvider)));

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserState user) async {
    try {
      return right(_users.doc(user.model!.uid).update(user.model!.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

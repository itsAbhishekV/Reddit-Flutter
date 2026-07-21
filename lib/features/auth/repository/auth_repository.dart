import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/core.dart';
import 'package:reddit_clone/models/models.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSingInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanged => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      if (!_googleSignInInitialized) {
        await _googleSignIn.initialize(
          serverClientId: FirebaseConstants.googleSignInServerClientId,
        );
        _googleSignInInitialized = true;
      }
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential =
          GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      UserCredential userCredentials =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredentials.additionalUserInfo!.isNewUser) {
        userModel = userCredentials.user!.toUserModel();
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredentials.user!.uid).first;
        // print(userModel);
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

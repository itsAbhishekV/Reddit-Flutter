import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firbase_provider.dart';
import 'package:reddit_clone/models/user_model.dart';

import '../../../core/constants/constants.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvder),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSingInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;
  
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredentials =
          await _auth.signInWithCredential(credential);
      print('Signed in with: ${userCredentials.user?.email}');

      late UserModel userModel;

      if(userCredentials.additionalUserInfo!.isNewUser){
        userModel = UserModel(
            name: userCredentials.user!.displayName ?? 'No Name',
            profilePic: userCredentials.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredentials.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: []);

        await _users.doc(userModel.uid).set(userModel.toMap());
      }

    } catch (e) {
        rethrow;
    }
  }
}

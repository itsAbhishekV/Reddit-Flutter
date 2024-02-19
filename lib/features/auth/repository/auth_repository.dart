import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/firbase_provider.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(firestore: ref.read(firestoreProvder), auth: ref.read(authProvider), googleSignIn: ref.read(googleSingInProvider)));

class AuthRepository{
    final FirebaseFirestore _firestore;
    final FirebaseAuth _auth;
    final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
}) : _auth = auth, _firestore = firestore, _googleSignIn = googleSignIn;


  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken
      );

      UserCredential userCredentials = await _auth.signInWithCredential(
          credential);
      print('Signed in with: ${userCredentials.user?.email}');
    } catch (e) {
      print(e);
    }
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failures.dart';
import 'package:reddit_clone/core/providers/firbase_provider.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/community_model.dart';

final CommunityRepositoryProvider = Provider((ref) => CommunityRepository(firestore: ref.watch(firestoreProvder)));

class CommunityRepository{
  final FirebaseFirestore _firestore;
  
  CommunityRepository({
    required FirebaseFirestore firestore,
}) : _firestore = firestore;

  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for(var doc in event.docs){
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
        // print('single $communities');
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name){
    return _communities.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid createCommunity(Community community) async {
    try{
      var communityDoc = await _communities.doc(community.name).get();
      if(communityDoc.exists){
        throw 'Community with the same name already exists';
      }
      return right(
        _communities.doc(community.name).set(community.toMap())
      );

    }on FirebaseException catch (e){
      throw e.message!;
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editCommunity(Community community) async {
    try{
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e){
      throw e.message!;
    } catch (e){
      return left(Failure(e.toString()));
    }
  }

}
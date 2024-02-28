import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_cotroller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constants/constants.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';

final userCommunityProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) => CommunityController(communityRepository: ref.watch(CommunityRepositoryProvider), ref: ref, storageRepository: ref.watch(storageRepositoryProvider)));

class CommunityController extends StateNotifier<bool>{
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
}) : _communityRepository = communityRepository,
     _ref = ref,
     _storageRepository = storageRepository,
     super(false); //loading

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(id: name, name: name, banner: Constants.bannerDefault, avatar: Constants.avatarDefault, members: [uid], mods: [uid]);
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message.toString()), (r) {
      showSnackBar(context, '${community.name} was created!');
      Routemaster.of(context).pop();
    } );
  }

  Stream<Community> getCommunityByName(String name){
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Community>> getUserCommunities(){
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  void editCommunity({required File? profileFile, required File? bannerFile, required BuildContext context, required Community community}) async {
    state = true;
    var communityNew = community;
    if(profileFile != null){
      final res = await _storageRepository.storeFile(path: 'communities/profile', id: community.name, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message), (r) => communityNew.copyWith(avatar: r));
    }
    if(bannerFile != null){
      final res = await _storageRepository.storeFile(path: 'communities/banner', id: community.name, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message), (r) => communityNew.copyWith(banner: r));
    }

    final res = await _communityRepository.editCommunity(communityNew);
    res.fold((l) => showSnackBar(context, l.message), (r) => Routemaster.of(context).pop());

    state = false;
  }

}
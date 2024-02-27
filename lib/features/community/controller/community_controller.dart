import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_cotroller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';

final UserCommunityProvider = StreamProvider((ref) {
  final communityController = ref.watch(CommunityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(CommunityControllerProvider.notifier).getCommunityByName(name);
});

final CommunityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) => CommunityController(communityRepository: ref.watch(CommunityRepositoryProvider), ref: ref));

class CommunityController extends StateNotifier<bool>{
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref
}) : _communityRepository = communityRepository,
     _ref = ref,
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

}
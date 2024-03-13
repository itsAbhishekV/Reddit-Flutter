import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/user_profile_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) =>
        UserProfileController(
            userProfileRepository: ref.read(userProfileRepositoryProvider),
            ref: ref,
            storageRepository: ref.read(storageRepositoryProvider)));

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserState user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profile', id: user.model!.uid, file: profileFile);

      res.fold((l) {
        showSnackBar(context, l.message);
      }, (r) {
        return user = user.copyWith(model: user.model!.copyWith(profilePic: r));
      });
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/banner', id: user.model!.uid, file: bannerFile);

      res.fold((l) {
        showSnackBar(context, l.message);
      }, (r) {
        return user = user.copyWith(
          model: user.model?.copyWith(banner: r),
        );
      });
    }

    user = user.copyWith(model: user.model!.copyWith(name: name));
    final res = await _userProfileRepository.editProfile(user);

    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }
}

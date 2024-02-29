import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';

final userProvider = StateProvider<UserModelOrError?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, UserModelOrError>((ref) =>
    AuthController(authRepository: ref.watch(authRepositoryProvider), ref: ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<UserModelOrError> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required Ref ref, required AuthRepository authRepository})
      : _authRepository = authRepository,
        _ref = ref,
        super(UserModelOrError(model:null,exceptionMessage: null, isLoading: false)); //loading

  Stream<User?> get authStateChange => _authRepository.authStateChanged;

  void singInWithGoogle(BuildContext context) async {
    state = UserModelOrError(model:null,exceptionMessage: null, isLoading: true);
    final user = await _authRepository.signInWithGoogle();
    user.fold(
        (l) => _ref.read(userProvider.notifier).update((state) {
          final result = UserModelOrError(model: null, exceptionMessage: l.message,isLoading: false);
          this.state = result;
          return result;
        }),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) {
              final result = UserModelOrError(model: userModel, exceptionMessage: null,isLoading: false);
              this.state = result;
              return result;
            }));
  }

  Stream<UserModel> getUserData(String uid) => _authRepository.getUserData(uid);
}

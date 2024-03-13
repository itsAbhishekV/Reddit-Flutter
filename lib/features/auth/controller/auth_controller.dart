import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';

final userProvider = StateProvider<UserState?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, UserState>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<UserState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required Ref ref, required AuthRepository authRepository})
      : _authRepository = authRepository,
        _ref = ref,
        super(UserState(
            model: null, exceptionMessage: null, isLoading: false)); //loading

  Stream<User?> get authStateChange =>
      _authRepository.authStateChanged.map((user) {
        if (user != null) {
          _ref.read(userProvider.notifier).update((state) => UserState(
              model: user.toUserModel(),
              exceptionMessage: null,
              isLoading: false));
        }

        return user;
      });

  void singInWithGoogle(BuildContext context) async {
    state = UserState(model: null, exceptionMessage: null, isLoading: true);
    final user = await _authRepository.signInWithGoogle();
    user.fold(
        (l) => _ref.read(userProvider.notifier).update((state) {
              final result = UserState(
                  model: null, exceptionMessage: l.message, isLoading: false);
              this.state = result;
              return result;
            }),
        (userModel) => _ref.read(userProvider.notifier).update((state) {
              final result = UserState(
                  model: userModel, exceptionMessage: null, isLoading: false);
              this.state = result;
              return result;
            }));
  }

  void logOut() async {
    _authRepository.logOut();
  }

  Stream<UserModel> getUserData(String uid) => _authRepository.getUserData(uid);
}

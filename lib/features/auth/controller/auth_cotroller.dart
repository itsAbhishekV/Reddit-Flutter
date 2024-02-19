import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = Provider((ref) =>
    AuthController(authRepository: ref.read(authRepositoryProvider), ref: ref));

class AuthController extends StateNotifier{
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required Ref ref, required AuthRepository authRepository})
      : _authRepository = authRepository,
        _ref = ref, super();

  void singInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_cotroller.dart';
import 'package:reddit_clone/theme/palette.dart';

import '../constants/constants.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref){
     ref.read(authControllerProvider).singInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(onPressed: (){
        signInWithGoogle(context, ref);
      },
          icon: Image.asset(Constants.googleLogoPath, width: 35,),
          label: const Text('Continue with Google',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.greyColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
            )
          )
          
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';

import '../constants/constants.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(onPressed: (){
        debugPrint('Elevated button clicked');
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
          )
      ),
    );
  }
}

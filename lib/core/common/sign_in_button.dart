import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(onPressed: (){
      debugPrint('Elevated button clicke');
    },
        icon: const Icon(Icons.ac_unit_sharp),
        label: const Text('Sign in with Google.')
    );
  }
}

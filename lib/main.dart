import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/theme/palette.dart';

void main(){
  runApp(const RedditClone());
}

class RedditClone extends StatelessWidget {
  const RedditClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit',
      debugShowCheckedModeBanner: false,
      theme: Palette.darkModeAppTheme,
      home: const LoginScreen(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: RedditClone()));
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

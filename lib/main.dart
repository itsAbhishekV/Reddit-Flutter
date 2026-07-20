import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/common.dart';
import 'package:reddit_clone/features/auth/auth.dart';
import 'package:reddit_clone/router.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/firebase_options.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: RedditClone()));
}

class RedditClone extends ConsumerStatefulWidget {
  const RedditClone({super.key});

  @override
  ConsumerState createState() => _RedditCloneState();
}

class _RedditCloneState extends ConsumerState<RedditClone> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (user) => MaterialApp.router(
              title: 'Reddit',
              debugShowCheckedModeBanner: false,
              theme: ref.watch(themeNotifierProvider),
              routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                if (user != null) {
                  return loggedInRoute;
                }
                return loggedOutRoute;
              }),
              routeInformationParser: const RoutemasterParser(),
            ),
        error: (error, stack) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}

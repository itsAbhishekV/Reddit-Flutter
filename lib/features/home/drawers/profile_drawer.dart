import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/auth.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isDarkMode = ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(user.model?.profilePic ?? ''),
              radius: 60,
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              'u/${user.model?.name.replaceAll(" ", "")}',
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.4),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_outlined),
              title: const Text('My profile'),
              onTap: () {
                navigateToUserProfile(context, user.model?.uid ?? "");
              },
            ),
            ListTile(
              leading: const Icon(EvaIcons.plusCircleOutline),
              title: const Text('Create a community'),
              iconColor: Colors.blue,
              onTap: () {
                navigateToCommunity(context);
              },
            ),
            ListTile(
              leading: const Icon(EvaIcons.logOutOutline),
              title: const Text('Log out'),
              iconColor: Colors.red,
              onTap: () {
                logOut(ref);
              },
            ),
            const SizedBox(height: 15),
            SwitchListTile.adaptive(
              title: const Text('Dark mode'),
              activeThumbColor: Colors.blueAccent,
              value: isDarkMode,
              onChanged: (val) => toggleTheme(ref),
            ),
          ],
        ),
      ),
    );
  }
}

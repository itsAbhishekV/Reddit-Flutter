import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
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
              'u/${user.model?.name.replaceAll(" ", "")}' ?? '',
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
              leading: const Icon(Icons.add_circle_outline_outlined),
              title: const Text('Create a community'),
              iconColor: Colors.blue,
              onTap: () {
                navigateToCommunity(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Log out'),
              iconColor: Colors.red,
              onTap: () {
                logOut(ref);
              },
            ),
            const SizedBox(height: 15),
            Switch.adaptive(value: true, onChanged: (val) {}),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_cotroller.dart';
import 'package:reddit_clone/theme/palette.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

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
              style: const TextStyle(fontFamily: Palette.customFontFamily, fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 0.4),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My profile', style: TextStyle(
                fontFamily: Palette.customFontFamily
              ),),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Log Out'),
              iconColor: Colors.red,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}

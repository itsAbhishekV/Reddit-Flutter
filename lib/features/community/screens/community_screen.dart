import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/widgets/post_component.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/community_model.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinOrLeaveCommunity(
      Community community, WidgetRef ref, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinOrLeaveCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(community.banner, fit: BoxFit.cover),
                    )
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 32,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            community.mods.contains(user?.model?.uid)
                                ? OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                              ),
                              onPressed: () {
                                navigateToModTools(context);
                              },
                              child: const Text('Mod Tools'),
                            )
                                : OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                              ),
                              onPressed: () {
                                joinOrLeaveCommunity(community, ref, context);
                              },
                              child: Text(
                                community.members.contains(user?.model?.uid)
                                    ? 'Joined'
                                    : 'Join',
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            community.members.length == 1
                                ? '${community.members.length} member'
                                : '${community.members.length} members',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Divider(thickness: 2)),
                  const SizedBox(height: 10,)
                ]),
              ),
            ];
          },
          body: ref.watch(getCommunityPostsProvider(name)).when(
            data: (posts) {
              print(posts);
              return CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final post = posts[index];
                        return PostComponent(post: post);
                      },
                      childCount: posts.length,
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              if (kDebugMode) {
                print(error);
              }
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
        ),
        error: (error, stack) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}

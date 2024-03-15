import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/post_component.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;

  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 240,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding:
                              const EdgeInsets.all(20).copyWith(bottom: 70),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              user.profilePic,
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(20).copyWith(left: 30),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 10.0,
                                    color: Colors
                                        .black, // Set your desired color here
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      40.0), // Adjust to your preference
                                ),
                              ),
                              onPressed: () {
                                navigateToEditUser(context);
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: Row(
                              children: [
                                Text('u/${user.name.replaceAll(" ", "")}'),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '•',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text('${user.karma} karma'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(thickness: 2),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getUserPostsProvider(uid)).when(
                    data: (posts) {
                      return CustomScrollView(
                        shrinkWrap: true, // Shrink wrap the contents
                        slivers: [
                          // Use SliverList directly instead of wrapping in SliverToBoxAdapter
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
                    error: (error, stackTract) {
                      if (kDebugMode) {
                        print(error);
                      }
                      return SliverToBoxAdapter(
                          child: ErrorText(error: error.toString()));
                    },
                    loading: () => const SliverToBoxAdapter(child: Loader()),
                  ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

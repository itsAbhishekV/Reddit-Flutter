import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../../models/post_model.dart';
import '../constants/constants.dart';

class PostComponent extends ConsumerWidget {
  final Post post;

  const PostComponent({super.key, required this.post});

  // void deletePost(BuildContext context, WidgetRef ref) async {
  //   ref.read(postControllerProvider.notifier).deletePost(context, post);
  // }

  void deleteItem(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm Delete',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this post?',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(postControllerProvider.notifier)
                    .deletePost(context, post);
                Routemaster.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void upvote(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvote(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUserProfileFromPost(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunityScreenFromPost(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.communityProfilePic),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            navigateToCommunityScreenFromPost(
                                                context);
                                          },
                                          child: Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            navigateToUserProfileFromPost(
                                                context);
                                          },
                                          child: Text(
                                            'u/${post.username.replaceAll(" ", "")}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.model!.uid)
                                IconButton(
                                    onPressed: () => deleteItem(context, ref),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Palette.redColor,
                                    ))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          if (isTypeImage)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: Image.network(post.link!,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                post.description!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4),
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.4),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            child: IconButton(
                                              icon: Icon(
                                                Constants.up,
                                                size: 20,
                                                color: post.upvotes.contains(
                                                        user.model!.uid)
                                                    ? Colors.deepOrange
                                                    : Colors.grey,
                                              ),
                                              onPressed: () => upvote(ref),
                                            ),
                                          ),
                                          Text(
                                            '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: VerticalDivider(
                                              thickness: 1,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30,
                                            child: IconButton(
                                                onPressed: () => downvote(ref),
                                                icon: Icon(
                                                  Constants.down,
                                                  size: 20,
                                                  color: post.downvotes
                                                          .contains(
                                                              user.model!.uid)
                                                      ? Colors.deepOrange
                                                      : Colors.grey,
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 35,
                                  padding: const EdgeInsets.only(
                                    right: 14,
                                    left: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.4),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.mode_comment_outlined,
                                              size: 20,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/common.dart';
import 'package:reddit_clone/features/community/community.dart';
import 'package:reddit_clone/features/posts/posts.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunityProvider).when(
        data: (communities) {
          return ref.watch(userPostsProvider(communities)).when(
              data: (posts) {
                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                      return PostComponent(post: post);
                    });
              },
              error: (error, stackTract) {
                if (kDebugMode) {
                  print(error);
                }
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader());
        },
        error: (error, stackTract) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}

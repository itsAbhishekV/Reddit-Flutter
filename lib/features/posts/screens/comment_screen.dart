import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/post_component.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';

import '../../../core/common/loader.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ref.watch(getPostByIdProvider(widget.postId)).when(
              data: (post) {
                return Column(
                  children: [
                    PostComponent(post: post),
                    const SizedBox(
                      height: 14,
                    ),
                    TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Your thoughts?',
                            border: InputBorder.none))
                  ],
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader())),
    );
  }
}

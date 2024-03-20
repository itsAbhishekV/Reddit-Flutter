import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/post_component.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/core/common/comment_component.dart';

import '../../../core/common/loader.dart';
import '../../../models/post_model.dart';

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

  void addComment(Post post) {
    ref.watch(postControllerProvider.notifier).addComment(
        context: context, post: post, text: commentController.text.trim());
    setState(() {
      commentController.text = '';
    });
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
                      height: 6,
                    ),
                    TextField(
                      cursorColor: Colors.blueAccent,
                      onSubmitted: (val) => addComment(post),
                      controller: commentController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15),
                          filled: true,
                          hintText: 'Your thoughts?',
                          border: InputBorder.none),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (comments) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final comment = comments[index];
                                  return CommentComponent(comment: comment);
                                }),
                          );
                        },
                        error: (error, stackTrace) {
                          if (kDebugMode) {
                            print(error.toString());
                          }
                          return ErrorText(error: error.toString());
                        },
                        loading: () => const Loader())
                  ],
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader())),
    );
  }
}

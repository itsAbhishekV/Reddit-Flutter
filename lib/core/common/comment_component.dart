import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';

import '../constants/constants.dart';
import '../../models/comment_model.dart';

class CommentComponent extends ConsumerWidget {
  final Comment comment;

  const CommentComponent({super.key, required this.comment});

  void commentUpvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).commentUpvote(comment);
  }

  void commentDownvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).commentDownvote(comment);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Container(
      color: const Color.fromRGBO(18, 18, 18, 1),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profilePic),
                radius: 12,
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                  ),
                  child: Text(
                    'u/${comment.username.replaceAll(" ", "")}',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            comment.text,
            style: const TextStyle(fontSize: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          icon: Icon(
                            Constants.up,
                            size: 20,
                            color:
                                comment.commentUpvotes.contains(user.model!.uid)
                                    ? Colors.deepOrange
                                    : Colors.grey,
                          ),
                          onPressed: () => commentUpvote(ref),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${comment.commentUpvotes.length - comment.commentDownvotes.length == 0 ? '0' : comment.commentUpvotes.length - comment.commentDownvotes.length}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                            onPressed: () => commentDownvote(ref),
                            icon: Icon(
                              Constants.down,
                              size: 20,
                              color: comment.commentDownvotes
                                      .contains(user.model!.uid)
                                  ? Colors.deepOrange
                                  : Colors.grey,
                            )),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.reply_sharp,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Reply',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

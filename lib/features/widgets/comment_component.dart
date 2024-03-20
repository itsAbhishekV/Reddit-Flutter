import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

import '../../core/constants/constants.dart';
import '../../models/comment_model.dart';

class CommentComponent extends ConsumerWidget {
  final Comment comment;

  const CommentComponent({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Container(
      color: const Color.fromRGBO(18, 18, 18, 1),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
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
                          onPressed: () {},
                        ),
                      ),
                      Text(
                        '${comment.commentUpvotes.length - comment.commentDownvotes.length == 0 ? '0' : comment.commentUpvotes.length - comment.commentDownvotes.length}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: VerticalDivider(
                          thickness: 1,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                            onPressed: () {},
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
                    Icons.reply,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Reply',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/comment_model.dart';

class CommentComponent extends ConsumerWidget {
  final Comment comment;

  const CommentComponent({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.reply,
                    size: 18,
                  ),
                ),
                const Text('Reply'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

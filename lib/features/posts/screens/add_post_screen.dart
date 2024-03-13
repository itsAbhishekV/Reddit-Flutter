import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/posts/screens/card/card_component.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardComponent(cardIcon: Icons.image),
        CardComponent(cardIcon: Icons.text_format_outlined),
        CardComponent(cardIcon: Icons.link),
      ],
    );
  }
}

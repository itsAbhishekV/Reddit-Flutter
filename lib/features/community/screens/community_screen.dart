import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

import '../../../core/common/error_text.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) =>
              NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 150,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(child: Image.network(community.banner, fit: BoxFit.cover))
                          ],
                        ),
                      )
                    ];
                  },
                  body: const Text('Displaying Posts')
              ),
          error: (error, stack) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}

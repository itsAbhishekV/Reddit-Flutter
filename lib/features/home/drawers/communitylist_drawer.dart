import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/failures.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context){
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: const Text('Create a Community'),
            leading: const Icon(Icons.add),
            onTap: () => navigateToCreateCommunity(context),
          ),

          ref.watch(UserCommunityProvider)
              .when(
            data: (communities) => Expanded(
              child: ListView.builder(
                itemCount: communities.length,
                itemBuilder: (BuildContext context, int index){
                  final community = communities[index];
                  return ListTile(
                    title: Text('r/${community.name}'),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(community.avatar),
                    ),
                    onTap: (){},
                  );
                },
              ),
            ),
            error: (err, stack) => ErrorText(error: err.toString()),
            loading: () => const Loader(),
          )
        ],
      )),
    );
  }
}

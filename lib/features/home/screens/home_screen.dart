import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_cotroller.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/communitylist_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: (){
                displayDrawer(context);
              },
            );
          },
        ),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: SearchCommunityDelegate(ref));
          }, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: (){},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.model?.profilePic ?? ""),
            ),
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
    );
  }
}

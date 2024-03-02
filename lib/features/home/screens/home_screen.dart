import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_cotroller.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/communitylist_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';
import 'package:reddit_clone/theme/palette.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayCommunitydrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  void displayProfileDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: (){
                displayCommunitydrawer(context);
              },
            );
          },
        ),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: SearchCommunityDelegate(ref));
          }, icon: const Icon(Icons.search)),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: (){
                  displayProfileDrawer(context);
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.model?.profilePic ?? ""),
                  radius: 20,
                ),
              );
            }
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }
}

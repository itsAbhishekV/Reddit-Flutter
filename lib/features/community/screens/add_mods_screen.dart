import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> modsUid = {};
  int ctrl = 0;

  void addUid(String uid) {
    setState(() {
      modsUid.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      modsUid.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, modsUid.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: ref.read(getCommunityByNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = community.members[index];
                return ref.watch(getUserDataProvider(member)).when(
                    data: (user) {
                      if (community.mods.contains(user.uid) && ctrl == 0) {
                        modsUid.add(user.uid);
                      }
                      ctrl++;
                      return CheckboxListTile(
                        value: modsUid.contains(user.uid),
                        onChanged: (bool? val) {
                          if (val!) {
                            addUid(user.uid);
                          } else {
                            removeUid(user.uid);
                          }
                        },
                        title: Text(user.name),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader());
              }),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {

  final communityNameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity(WidgetRef ref){
    ref.read(communityControllerProvider.notifier).createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community'),
        centerTitle: true,
      ),
      body: isLoading ? const Loader() : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Community Name'),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: communityNameController,
              decoration: const InputDecoration(
                hintText: 'r/Community_name',
                filled: true,
                fillColor: Color.fromRGBO(47, 47, 47, 1),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
                ),
              maxLength: 21,
              ),
            const SizedBox(height: 30,),
            ElevatedButton(
                onPressed: () => createCommunity(ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
              ),
                child: const Text('Create Community',
                style: TextStyle(
                  fontSize: 17
                ),),
            )
          ],
        ),
      ),
    );
  }
}

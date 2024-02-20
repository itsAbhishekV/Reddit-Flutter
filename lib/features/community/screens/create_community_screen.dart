import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
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
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(double.infinity, 50),

                ),
                child: const Text('Create Community'),
            )
          ],
        ),
      ),
    );
  }
}

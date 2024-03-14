import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/models/community_model.dart';

import '../../../core/common/loader.dart';
import '../../../core/utils.dart';
import '../../../theme/palette.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;
  File? bannerFile;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost(BuildContext context) {
    if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          community: selectedCommunity ?? communities[0],
          title: titleController.text.trim(),
          description: descriptionController.text.trim());
    } else if (widget.type == 'image' &&
        titleController.text.isNotEmpty &&
        bannerFile != null) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          community: selectedCommunity ?? communities[0],
          title: titleController.text.trim(),
          imageUrl: bannerFile);
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          community: selectedCommunity ?? communities[0],
          title: titleController.text.trim(),
          link: linkController.text.trim());
    } else {
      showSnackBar(context, 'Please enter all the Fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = widget.type == 'image';
    final isTypelink = widget.type == 'link';
    final isTypeText = widget.type == 'text';
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post ${widget.type}',
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                sharePost(context);
              },
              child: const Text(
                'Share',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ))
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter title here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Palette
                              .darkModeAppTheme.textTheme.bodyMedium!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: bannerFile != null
                                ? Image.file(bannerFile!)
                                : const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    ),
                                  ),
                          ),
                        )),
                  if (isTypeText)
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter description here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLines: 5,
                    ),
                  if (isTypelink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter link here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Select Community",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ref.watch(userCommunityProvider).when(
                      data: (data) {
                        communities = data;
                        if (data.isEmpty) {
                          return const SizedBox();
                        }
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton(
                            icon: const Icon(Icons.keyboard_arrow_down_sharp),
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader()),
                ],
              ),
            ),
    );
  }
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/providers/firbase_provider.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/repository/post_repository.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
      postRepository: ref.read(postRepositoryProvider),
      ref: ref,
      storageRepository: ref.read(storageRepositoryProvider));
});

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  return ref.watch(postControllerProvider.notifier).fetchUserPosts(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});
final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).fetchPostComment(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required BuildContext context,
      required Community community,
      required String title,
      required String description}) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
        id: postId,
        title: title,
        communityName: community.name,
        communityProfilePic: community.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.model!.name,
        uid: user.model!.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required Community community,
      required String title,
      required File? imageUrl}) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final imageRes = await _storageRepository.storeFile(
        path: 'posts/${community.name}', id: postId, file: imageUrl);

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
          id: postId,
          title: title,
          communityName: community.name,
          communityProfilePic: community.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.model!.name,
          uid: user.model!.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r);

      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted Successfully!');
        Routemaster.of(context).pop();
      });
    });
  }

  void shareLinkPost(
      {required BuildContext context,
      required Community community,
      required String title,
      required String link}) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
        id: postId,
        title: title,
        communityName: community.name,
        communityProfilePic: community.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.model!.name,
        uid: user.model!.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: link);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    } else {
      return Stream.value([]);
    }
  }

  void deletePost(BuildContext context, Post post) async {
    if (post.type == 'image') {
      if (post.link != null && post.link!.isNotEmpty) {
        final storage = FirebaseStorage.instance;
        final imageRef = storage.ref('posts/${post.communityName}/${post.id}');
        await imageRef.delete();
      }
    }
    final res = await _postRepository.deletePost(post);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Post Deleted Successfully!'));
  }

  void upvote(Post post) async {
    final userId = _ref.watch(userProvider)!.model!.uid;
    _postRepository.upvote(post, userId);
  }

  void downvote(Post post) async {
    final userId = _ref.watch(userProvider)!.model!.uid;
    _postRepository.downvote(post, userId);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment(
      {required BuildContext context,
      required Post post,
      required String text}) async {
    final user = _ref.read(userProvider)!.model!;
    final commentId = const Uuid().v1();
    Comment comment = Comment(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: post.id,
        username: user.name,
        profilePic: user.profilePic);

    final res = await _postRepository.addComment(comment);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Comment shared successfully!');
    });
  }

  Stream<List<Comment>> fetchPostComment(String postId) {
    return _postRepository.getComments(postId);
  }
}

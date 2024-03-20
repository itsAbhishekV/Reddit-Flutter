import 'package:flutter/foundation.dart';

class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;
  final List<String> commentUpvotes;
  final List<String> commentDownvotes;

  Comment(
      {required this.id,
      required this.text,
      required this.createdAt,
      required this.postId,
      required this.username,
      required this.profilePic,
      required this.commentDownvotes,
      required this.commentUpvotes});

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
    List<String>? commentUpvotes,
    List<String>? commentDownvotes,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      commentUpvotes: commentUpvotes ?? this.commentUpvotes,
      commentDownvotes: commentDownvotes ?? this.commentDownvotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'commentUpvotes': commentUpvotes,
      'commentDownvotes': commentDownvotes
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
      commentUpvotes: List<String>.from(map['commentUpvotes']),
      commentDownvotes: List<String>.from(map['commentDownvotes']),
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic, commentUpvotes: $commentUpvotes, commentDownvotes: $commentDownvotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.username == username &&
        other.profilePic == profilePic &&
        listEquals(other.commentUpvotes, commentUpvotes) &&
        listEquals(other.commentDownvotes, commentDownvotes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        commentDownvotes.hashCode ^
        commentUpvotes.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        profilePic.hashCode;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:reddit_clone/core/constants/constants.dart';

class UserState {
  final UserModel? model;
  final String? exceptionMessage;
  final bool isLoading;

  UserState(
      {required this.model,
      required this.exceptionMessage,
      required this.isLoading});

  UserState copyWith(
      {UserModel? model, String? exceptionMessage, bool? isLoading}) {
    return UserState(
        model: model ?? this.model,
        exceptionMessage: exceptionMessage ?? this.exceptionMessage,
        isLoading: isLoading ?? this.isLoading);
  }
}

extension FirebaseUserToUserModel on User {
  UserModel toUserModel() {
    return UserModel(
        name: displayName ?? 'No Name',
        profilePic: photoURL ?? Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: uid,
        isAuthenticated: true,
        karma: 0,
        awards: [
          'awesomeAns',
          'helpful',
          'plusone',
          'rocket',
          'thankyou',
          'til',
          'gold',
          'platinum'
        ]);
  }
}

class UserModel {
  final String name;
  final String profilePic;
  final String banner;
  final String uid;
  final bool isAuthenticated; // if guest or not
  final int karma;
  final List<String> awards;

  UserModel({
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.uid,
    required this.isAuthenticated,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      banner: map['banner'] ?? '',
      uid: map['uid'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
      karma: map['karma']?.toInt() ?? 0,
      awards: List<String>.from(map['awards']),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}

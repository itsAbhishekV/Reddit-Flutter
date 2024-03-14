import 'package:flutter/material.dart';
import 'package:reddit_clone/features/posts/screens/add_post_screen.dart';
import '../../features/feed/feed_screen.dart';

class Constants {
  static const logoPath = 'assets/images/logo.png';
  static const loginEmotePath = 'assets/images/loginEmote.png';
  static const googleLogoPath = 'assets/images/google.png';

  static const bannerDefault =
      'https://e0.pxfuel.com/wallpapers/115/722/desktop-wallpaper-reddit-cartoon-resolution-background-and-cartoon-banner.jpg';
  static const avatarDefault =
      'https://www.redditstatic.com/avatars/avatar_default_02_0079D3.png';

  static const tabWidget = [
    FeedScreen(),
    AddPostScreen(),
  ];

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}

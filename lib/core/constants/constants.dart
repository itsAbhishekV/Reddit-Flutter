import 'package:reddit_clone/features/feeds/feed_screen.dart';
import 'package:reddit_clone/features/posts/screens/add_post_screen.dart';

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
}

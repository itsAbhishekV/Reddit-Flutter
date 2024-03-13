import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class CardComponent extends ConsumerWidget {
  final IconData cardIcon;
  final String type;

  const CardComponent({super.key, required this.cardIcon, required this.type});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;
    final currentTheme = ref.watch(themeNotifierProvider);
    return GestureDetector(
      onTap: () {
        navigateToType(context, type);
      },
      child: SizedBox(
        width: cardHeightWidth,
        height: cardHeightWidth,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: currentTheme.cardTheme.color,
          child: Center(
              child: Icon(
            cardIcon,
            size: 35,
          )),
        ),
      ),
    );
  }
}

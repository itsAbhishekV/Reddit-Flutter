import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/palette.dart';

class CardComponent extends ConsumerWidget {
  final IconData cardIcon;

  const CardComponent({super.key, required this.cardIcon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;
    final currentTheme = ref.watch(themeNotifierProvider);
    return SizedBox(
      width: cardHeightWidth,
      height: cardHeightWidth,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: currentTheme.cardTheme.color,
        child: Center(
            child: Icon(
          cardIcon,
          size: 35,
        )),
      ),
    );
  }
}

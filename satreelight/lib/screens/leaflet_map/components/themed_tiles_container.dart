import 'package:flutter/material.dart';
import 'package:themed/themed.dart';

class ThemedTilesContainer extends StatelessWidget {
  final Widget tilesContainer;
  const ThemedTilesContainer({Key? key, required this.tilesContainer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? ChangeColors(
            brightness: 0.5,
            hue: 1,
            saturation: -0.2,
            child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  ...[-1, 0, 0, 0, 255],
                  ...[0, -1, 0, 0, 255],
                  ...[0, 0, -1, 0, 255],
                  ...[0, 0, 0, 1, 0],
                ]),
                child: tilesContainer))
        : tilesContainer;
  }
}

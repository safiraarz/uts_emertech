import 'package:flutter/material.dart';
import 'color.dart';

class ColorOptions extends StatelessWidget {
  final int randomR;
  final int randomG;
  final int randomB;

  ColorOptions(this.randomR, this.randomG, this.randomB);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ColorOption({'r': randomR, 'g': randomG, 'b': randomB})
      ],
    );
  }
}

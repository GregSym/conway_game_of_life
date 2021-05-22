import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:flutter/material.dart';

List<Color> colourOptions = [
  Colors.purple[600],
  Colors.red[600],
  Colors.blue[600],
  Colors.orange[600]
];

class ColourMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: colourOptions
          .map((colourOption) => ListTile(
                onTap: () => colourConstants.setAliveColor = colourOption,
                title: Icon(
                  Icons.circle,
                  color: colourOption,
                ),
              ))
          .toList(),
    );
  }
}

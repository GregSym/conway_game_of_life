import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:flutter/material.dart';

class MaterialCanvasGoL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gridDelegate =
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 16);
    List cellsRow;
    return Material(
      child: GridView(
        gridDelegate: gridDelegate,
        children: cellsRow
            .map((e) => Container(
                  color: e ? ColorConstants().aliveColor : Colors.white,
                ))
            .toList(),
      ),
      color: ColorConstants().aliveColor,
    );
  }
}

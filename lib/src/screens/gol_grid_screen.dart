import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:conway_game_of_life/src/game_objects/gol_truths.dart';
import 'package:flutter/material.dart';

class MaterialCanvasGoL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoLTruths game = GoLTruths();
    game.initGame = 0;
    var gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: game.crossAxis);
    List<List<bool>> cells = game.truths;
    return Material(
      child: GridView(
        gridDelegate: gridDelegate,
        children: cells.expand((e) => e.map((el) => _cellWidget(el))).toList(),
      ),
      color: ColorConstants().aliveColor,
    );
  }

  Container _cellWidget(bool e) {
    // returns the widget responsible for rendering each cell
    return Container(
      color: e ? ColorConstants().aliveColor : Colors.white,
      child: ListTile(
        onTap: () => e = !e,
      ),
    );
  }
}

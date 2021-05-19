import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:conway_game_of_life/src/game_objects/gol_truths.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialCanvasGoL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<GoLTruths>(
        builder: (context, _goLTruths, _) => !_goLTruths.isReady
            ? CircularProgressIndicator() // in case setup takes some time
            : GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _goLTruths.crossAxis),
                children: _goLTruths.truths
                    .expand(
                        (row) => row.map((cell) => _cellWidget(context, cell)))
                    .toList(),
              ),
      ),
      color: ColorConstants().aliveColor,
    );
  }

  Consumer<GoLTruths> _cellWidget(BuildContext context, bool e) {
    // returns the widget responsible for rendering each cell
    return Consumer<GoLTruths>(
        builder: (context, _goLTruths, _) => Container(
              padding: EdgeInsets.all(1.0),
              color: e ? ColorConstants().aliveColor : Colors.white,
              child: ListTile(
                onTap: () => _goLTruths.toggleCell = CellLocation(
                  row: 0,
                  col: 0,
                ),
              ),
            ));
  }
}

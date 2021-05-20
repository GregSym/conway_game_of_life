import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:conway_game_of_life/src/game_objects/gol_truths.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Iterable<MapEntry<int, T>> enumerate<T>(Iterable<T> items) sync* {
  // https://stackoverflow.com/questions/54898767/enumerate-or-map-through-a-list-with-index-and-value-in-dart
  // a way of sort of doing the thing other languages have by default
  int index = 0;
  for (T item in items) {
    yield MapEntry(index, item);
    index = index + 1;
  }
}

class MaterialCanvasGoL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () =>
                  Provider.of<GoLTruths>(context, listen: false).resetGame(),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow_rounded),
              onPressed: () =>
                  Provider.of<GoLTruths>(context, listen: false).driveUpdate(),
            ),
          ],
        ),
      ),
      body: Material(
        child: Consumer<GoLTruths>(
          builder: (context, _goLTruths, _) => !_goLTruths.isReady
              ? CircularProgressIndicator() // in case setup takes some time
              : GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _goLTruths.crossAxis),
                  children: enumerate(_goLTruths.truths)
                      .expand((row) => row.value
                          .asMap()
                          .map((col, cell) => MapEntry(
                              col, _cellWidget(context, row.key, col, cell)))
                          .values)
                      .toList(),
                ),
        ),
        color: ColorConstants().aliveColor,
      ),
    );
  }

  Consumer<GoLTruths> _cellWidget(
      BuildContext context, int row, int col, bool cell) {
    // returns the widget responsible for rendering each cell
    return Consumer<GoLTruths>(
        builder: (context, _goLTruths, _) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                color: _goLTruths.truths[row][col]
                    ? ColorConstants().aliveColor
                    : Colors.white,
                child: ListTile(
                  onTap: () => _goLTruths.toggleCell = CellLocation(
                    row: row,
                    col: col,
                  ),
                ),
              ),
            ));
  }
}

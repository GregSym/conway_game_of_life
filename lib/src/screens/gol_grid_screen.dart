import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:conway_game_of_life/src/game_objects/gol_truths.dart';
import 'package:conway_game_of_life/src/screens/about_this_app.dart';
import 'package:conway_game_of_life/src/widgets/colour_options.dart';
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
    print("rebuilt");
    Color? aliveColor = Provider.of<ColorConstants>(context).aliveColor;
    bool _expand = true;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () =>
                  Provider.of<GoLTruths>(context, listen: false).resetGame(),
            ),
            (Provider.of<GoLTruths>(context).isRunning)
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                : IconButton(
                    icon: Icon(Icons.play_arrow_rounded),
                    onPressed: () =>
                        Provider.of<GoLTruths>(context, listen: false)
                            .driveUpdate(),
                  ),
            Text(Provider.of<GoLTruths>(context).gameMessage!),
            Text(Provider.of<GoLTruths>(context).totalAlive.toString()),
            PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          value: "Select Colour",
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => ColourMenu()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Select Colour"),
                                Icon(
                                  Icons.circle,
                                  color: ColorConstants().aliveColor,
                                )
                              ],
                            ),
                          )),
                      PopupMenuItem(
                          value: "About this App",
                          child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AboutThisApp()),
                              child: Text("About this App"))),
                    ])
          ],
        ),
      ),
      body: Material(
        child: Consumer<GoLTruths>(
          builder: (context, _goLTruths, _) => !_goLTruths.isReady
              ? CircularProgressIndicator() // in case setup takes some time
              : GestureDetector(
                  // onScaleStart: (ScaleStartDetails scaleStartDetails) =>
                  //     _goLTruths.expandSymmetric(callUpdate: true),
                  onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails) =>
                      // print(
                      //     "scale: ${scaleUpdateDetails.scale}"), // for debugging
                      (scaleUpdateDetails.scale < 1)
                          ? _expand = true
                          : _expand = false,
                  onScaleEnd: (ScaleEndDetails scaleEndDetails) => _expand
                      ? _goLTruths.expandSymmetric(callUpdate: true)
                      : _goLTruths.reduceSymmetric(callUpdate: true),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _goLTruths.crossAxis),
                    children: enumerate(_goLTruths.truths)
                        .expand((row) => row.value
                            .asMap()
                            .map((col, cell) => MapEntry(
                                col, _cellWidget(context, row.key, col, cell)))
                            // col,
                            // CellWidget(
                            //   row: row.key,
                            //   col: col,
                            //   cell: cell,
                            // )))
                            .values)
                        .toList(),
                  ),
                ),
        ),
        color: aliveColor,
      ),
    );
  }

  Widget _cellWidget(BuildContext context, int row, int col, bool cell) {
    const int exclusionRange = 2;

    CellLocation loc = CellLocation(
      row: row,
      col: col,
    );
    if (row < exclusionRange ||
        col < exclusionRange ||
        row >= Provider.of<GoLTruths>(context).truths.length - exclusionRange ||
        col >= Provider.of<GoLTruths>(context).crossAxis - exclusionRange)
      return Container();
    // returns the widget responsible for rendering each cell
    return Consumer<GoLTruths>(
        builder: (context, _goLTruths, _) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                color: _goLTruths.truths[row][col]
                    ? ColorConstants().aliveColor
                    : Colors.white,
                child: ListTile(
                  onTap: () => _goLTruths.toggleCell = loc,
                ),
              ),
            ));
  }
}

class CellWidget extends StatefulWidget {
  /*

  A backup implementation that may perform better in practice 
  - regular debug mode does not illuminate this point

  */
  final int? row;
  final int? col;
  final bool? cell;
  CellWidget({Key? key, this.row, this.col, this.cell}) : super(key: key);

  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  static const int exclusionRange = 2;
  CellLocation? loc;
  @override
  void initState() {
    super.initState();

    loc = CellLocation(
      row: widget.row,
      col: widget.col,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.row! < exclusionRange ||
        widget.col! < exclusionRange ||
        widget.row! >=
            Provider.of<GoLTruths>(context).truths.length - exclusionRange ||
        widget.col! >=
            Provider.of<GoLTruths>(context).crossAxis - exclusionRange)
      return Container();
    // returns the widget responsible for rendering each cell
    return Consumer<GoLTruths>(
        builder: (context, _goLTruths, _) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                color: _goLTruths.truths[widget.row!][widget.col!]
                    ? ColorConstants().aliveColor
                    : Colors.white,
                child: ListTile(
                  onTap: () => _goLTruths.toggleCell = loc!,
                ),
              ),
            ));
  }
}

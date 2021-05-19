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
                  color: Colors.white,
                ))
            .toList(),
      ),
      color: Colors.purple[600],
    );
  }
}

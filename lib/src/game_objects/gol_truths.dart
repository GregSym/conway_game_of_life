import 'package:flutter/foundation.dart';

class GoLTruths with ChangeNotifier {
  List<List<bool>> _truths = [];
  bool _ready = false;

  // starting dimensions
  int _width = 160;
  int _height = 320;

  // getters
  int get crossAxis => _truths[0].length;
  List<List<bool>> get truths => _truths;
  int get totalAlive => _tallyTruths();
  bool get isReady => _ready;

  // setters
  set toggleCell(CellLocation loc) => _toggleCell(loc);

  _toggleCell(CellLocation loc) {
    _truths[loc.row][loc.col] = !_truths[loc.row][loc.col];
    notifyListeners();
  }

  // methods
  initGame() {
    for (int j = 0; j < _height; j++) {
      // set height
      _truths.add([]);
    }
    for (int i = 0; i < _width; i++) {
      // set width
      for (List<bool> row in _truths) {
        row.add(false);
      }
    }
    _ready = true;
    notifyListeners();
  }

  expandWidth() {
    for (List<bool> row in _truths) {
      row.insert(0, false);
      row.add(false);
    }
    notifyListeners();
  }

  expandHeight() {
    _truths.insert(0, []);
    _truths.add([]);
    for (bool _ in _truths[1]) {
      _truths[0].add(false);
      _truths[_truths.length].add(false);
    }
    notifyListeners();
  }

  expandSymmetric() {
    for (List<bool> row in _truths) {
      row.insert(0, false);
      row.add(false);
    }
    _truths.insert(0, []);
    _truths.add([]);
    for (bool _ in _truths[1]) {
      _truths[0].add(false);
      _truths[_truths.length].add(false);
    }
    notifyListeners(); // worried about calling notifyListeners while notifying listeners so rewriting the contents for this one
  }

  _tallyTruths() {
    int total = 0;
    for (List<bool> row in _truths) {
      for (bool cell in row) {
        if (cell) total++;
      }
    }
    return total;
  }
}

class Cell {
  final int id;
  bool status;
  Cell({this.id, this.status});
}

class CellLocation {
  final int row;
  final int col;
  const CellLocation({this.row, this.col});
}

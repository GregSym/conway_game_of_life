import 'dart:async';

import 'package:flutter/foundation.dart';

class GoLTruths with ChangeNotifier {
  List<List<bool>> _cells = [];
  List<List<bool>> _nextIterationCells = [];
  bool _ready = false;
  Timer updateTimer;

  // starting dimensions
  int _width = 10;
  int _height = 10;

  // getters
  int get crossAxis => _cells[0].length;
  List<List<bool>> get truths => _cells;
  int get totalAlive => _tallyTruths();
  bool get isReady => _ready;

  // setters
  set toggleCell(CellLocation loc) => _toggleCell(loc);

  _toggleCell(CellLocation loc) {
    _cells[loc.row][loc.col] = !_cells[loc.row][loc.col];
    notifyListeners();
  }

  // methods
  initGame() {
    for (int j = 0; j < _height; j++) {
      // set height
      _cells.add([]);
    }
    for (int i = 0; i < _width; i++) {
      // set width
      for (List<bool> row in _cells) {
        row.add(false);
      }
    }
    _ready = true;
    notifyListeners();
  }

  resetGame() {
    _cells.clear();
    updateTimer.cancel();
    initGame();
  }

  driveUpdate() {
    updateTimer =
        Timer.periodic(Duration(milliseconds: 500), (timer) => update());
  }

  void update() {
    _updateRows();
    notifyListeners();
  }

  void _updateRows() {
    _nextIterationCells =
        List.from(_cells); // get the last grid of cells to work off of
    for (int i = 1; i < _cells.length - 1; i++) {
      for (int j = 1; j < _cells[0].length - 1; j++) {
        _updateCell(i, j);
      }
    }
    //if (_cells.isNotEmpty) _cells.clear();
    _cells = List.from(
        _nextIterationCells); // update current cells all at once from a new layer
  }

  void _updateCell(int i, int j) {
    int aliveNeighbours = 0;
    bool currentCell = _cells[i][j];
    List<bool> neighbours = [
      _cells[i - 1][j],
      _cells[i - 1][j - 1],
      _cells[i - 1][j + 1],
      _cells[i][j - 1],
      _cells[i][j + 1],
      _cells[i + 1][j],
      _cells[i + 1][j - 1],
      _cells[i + 1][j + 1], // needs to have 8 neighbours
    ];
    for (bool neighbour in neighbours) if (neighbour) aliveNeighbours++;
    if (!currentCell && aliveNeighbours == 3) {
      _nextIterationCells[i][j] = true; // dead comes alive
    } else if (currentCell) {
      if (aliveNeighbours == 2 || aliveNeighbours == 3)
        _nextIterationCells[i][j] = true; // alive stays alive
      else
        _nextIterationCells[i][j] = false; // dead cell condition
    } else {
      _nextIterationCells[i][j] = false; // dead cell condition
    }
  }

  expandWidth() {
    for (List<bool> row in _cells) {
      row.insert(0, false);
      row.add(false);
    }
    notifyListeners();
  }

  expandHeight() {
    _cells.insert(0, []);
    _cells.add([]);
    for (bool _ in _cells[1]) {
      _cells[0].add(false);
      _cells[_cells.length].add(false);
    }
    notifyListeners();
  }

  expandSymmetric() {
    for (List<bool> row in _cells) {
      row.insert(0, false);
      row.add(false);
    }
    _cells.insert(0, []);
    _cells.add([]);
    for (bool _ in _cells[1]) {
      _cells[0].add(false);
      _cells[_cells.length].add(false);
    }
    notifyListeners(); // worried about calling notifyListeners while notifying listeners so rewriting the contents for this one
  }

  _tallyTruths() {
    int total = 0;
    for (List<bool> row in _cells) {
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

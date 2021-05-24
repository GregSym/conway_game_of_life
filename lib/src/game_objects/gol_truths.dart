import 'dart:async';

import 'package:flutter/foundation.dart';

class GoLTruths with ChangeNotifier {
  /*
    Controller for the Game of Life
    - contains the grid of GoL cells
    - TODO: add optemisations for the calculation from instance to instance
    - TODO: add more resizing options (for landscape screens in particular)
  */
  List<List<bool>> _cells = [];
  List<List<bool>> _nextIterationCells = [];
  bool _expansionSymmetricRequired = false;
  String _gameMessage;
  bool _ready = false;
  bool _running = false;
  Timer updateTimer;

  // starting dimensions
  static int _width = 13;
  static int _height = 26;

  // getters
  int get crossAxis => _cells[0].length;
  List<List<bool>> get truths => _cells;
  int get totalAlive => _tallyTruths();
  String get gameMessage => _gameMessage;
  bool get isReady => _ready;
  bool get isRunning => _running;

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
    _nextIterationCells = List.from(
        _cells); // added creation of the next phase cell grid to the init method
    _gameMessage = "Setup the cells!";
    if (_running) _running = false;
    _ready = true;
    notifyListeners();
  }

  resetGame() {
    _cells.clear();
    if (updateTimer != null) updateTimer.cancel();
    initGame();
  }

  driveUpdate() {
    _gameMessage = "Game in progress...";
    _running = true;
    updateTimer =
        Timer.periodic(Duration(milliseconds: 500), (timer) => update());
  }

  void update() {
    if (_expansionSymmetricRequired) {
      expandSymmetric();
      expandSymmetric(); // expand here before doing the cell update if expansion was flagged on last iteration
      _expansionSymmetricRequired = false;
    }
    _updateRows();
    notifyListeners();
  }

  void _updateRows() {
    _nextIterationCells = _cells
        .map((e) => e.map((cell) => false).toList())
        .toList(); // get the last grid of cells to work off of - set all to false?
    for (int i = 1; i < _cells.length - 1; i++) {
      for (int j = 1; j < _cells[0].length - 1; j++) {
        _updateCell(i, j);
      }
    }
    //if (_cells.isNotEmpty) _cells.clear();
    _cells = _nextIterationCells
        .map((e) => e)
        .toList(); // update current cells all at once from a new layer
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
      // if cell is dead and has 3 alive neighbours
      _nextIterationCells[i][j] = true; // dead comes alive
    } else if (currentCell && (aliveNeighbours == 2 || aliveNeighbours == 3)) {
      // if cell is alive and has either 2 or 3 alive neighbours
      _nextIterationCells[i][j] = true; // alive stays alive
    } else {
      _nextIterationCells[i][j] = false; // dead cell condition
    }
    const int growthTrigger = 5;
    if (i <= growthTrigger ||
        j <= growthTrigger ||
        i >= _cells.length - growthTrigger ||
        j >= _cells[1].length - growthTrigger) if (_nextIterationCells[i][j])
      _expansionSymmetricRequired = true; // flag for expansion
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
      _cells[_cells.length - 1].add(false);
    }
    notifyListeners();
  }

  expandSymmetric({bool callUpdate = false}) {
    _cells.insert(0, []);
    _cells.add([]);
    for (bool _ in _cells[1]) {
      _cells[0].add(false);
      _cells[_cells.length - 1].add(false);
    }
    for (List<bool> row in _cells) {
      row.insert(0, false);
      row.add(false);
    }

    if (callUpdate)
      notifyListeners(); // worried about calling notifyListeners while notifying listeners so rewriting the contents for this one
  }

  // SHRINKING FUNCTIONS
  reduceWidth() {
    for (List<bool> row in _cells) {
      row.removeAt(0);
      row.removeLast();
    }
  }

  reduceHeight() {
    _cells.removeAt(0);
    _cells.removeLast();
  }

  reduceSymmetric({bool callUpdate = false}) {
    reduceWidth();
    reduceHeight();
    if (callUpdate) notifyListeners();
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
  // unessecary because of recreated enumerate function
  final int id;
  bool status;
  Cell({this.id, this.status});
}

class CellLocation {
  final int row;
  final int col;
  const CellLocation({this.row, this.col});
}

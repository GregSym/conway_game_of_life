class GoLTruths {
  List<List<bool>> _truths = [];

  // starting dimensions
  int _width = 16;
  int _height = 32;

  get crossAxis => _truths[0].length;
  get truths => _truths;
  get totalAlive => _tallyTruths();

  set initGame(_) => _setup();

  _setup() {
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

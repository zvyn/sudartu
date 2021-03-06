import 'dart:html';
import 'dart:math' show Random;

void main() {
  DivElement root = querySelector('#sudoku_container');
  Sudoku sudoku = new Sudoku(root);
  sudoku.hideCells(81);
}

class Sudoku {
  static final Random _random = new Random();
  int _size = 9;
  int _cageSize = 3;
  TableElement _table = new TableElement();
  List<TableCellElement> _hiddenCells = new List();

  Sudoku(DivElement root) {
    root.children.add(_table);
    List<int> rowValues = new List<int>(9);
    for (int number = 1; number <= _size; number++) {
      rowValues[number - 1] = number;
    }
    rowValues.shuffle(_random);

    List<int> globalShifts = new List();
    List<int> cageShifts = new List(_cageSize);
    for (int element = 0; element < _cageSize; element++) {
      globalShifts.add(element);
      cageShifts[element] = element * _cageSize;
    }
    globalShifts.shuffle(_random);
    cageShifts.shuffle(_random);
    int shift;
    int cageShift;
    for (int rowIndex = 0; rowIndex < _size; rowIndex++) {
      TableRowElement row = _table.addRow();
      row.id = "row-" + rowIndex.toString();
      if (rowIndex % _cageSize == 0) {
        shift = globalShifts.removeLast();
        cageShift = cageShifts[0];
      }
      for (int valueIndex = 0; valueIndex < rowValues.length; valueIndex++) {
        TableCellElement cell = row.addCell();
        cell.id = "cell-" + rowIndex.toString() + "-" + valueIndex.toString();
        cell.classes.add("col-" + valueIndex.toString());
        int index = (valueIndex + shift + cageShift) % _size;
        cell.text = rowValues[index].toString();
      }
      cageShift = cageShifts[(rowIndex + 1) % _cageSize];
    }
  }

  void hideCells(int count) {
    while (_hiddenCells.length < count) {
      int row_index = _random.nextInt(_size - 1);
      int col_index = _random.nextInt(_size - 1);
      var cell = querySelector("#cell-" + row_index.toString() + "-" + col_index.toString());
      cell
      ..contentEditable = "true"
      ..text = ""
      ..classes.add("editable");
      _hiddenCells.add(cell);
    }
  }
}

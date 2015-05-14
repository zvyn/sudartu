import 'dart:html';
import 'dart:math' show Random;

void main() {
  DivElement root = querySelector('#sudoku_container');
  Sudoku sudoku = new Sudoku(root);
  sudoku.hideCells(42);
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
    
    int shift = -1;
    int cageShift;
    for (int rowIndex = 0; rowIndex < _size; rowIndex++) {
      TableRowElement row = _table.addRow();
      row.id = "row-" + rowIndex.toString();
      if (rowIndex % _cageSize == 0) {
        shift++;
        cageShift = 0;
      }
      for (int valueIndex = 0; valueIndex < rowValues.length; valueIndex++) {
        TableCellElement cell = row.addCell();
        cell.id = "cell-" + rowIndex.toString() + "-" + valueIndex.toString();
        cell.classes.add("col-" + valueIndex.toString());
        int index = (valueIndex + shift + cageShift) % _size;
        cell.text = rowValues[index].toString();
      }
      cageShift += _cageSize;
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

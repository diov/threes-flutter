import 'dart:math';

import 'package:tuple/tuple.dart';

enum Direction { left, up, right, down }

class TileMatrix {
  TileMatrix(this.dimension) {
    matrix = List.generate(dimension, (i) => List<int>(4)).toList();
    _initTwoDimensionalArray();
  }

  TileMatrix.fromList(List<List<int>> list) {
    matrix = list;
    dimension = list.length;
  }

  int dimension;

  List<List<int>> matrix;

  List<Tuple3<int, int, int>> moveTitles = List<Tuple3<int, int, int>>();

  _initTwoDimensionalArray() {
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        matrix[i][j] = _generateRandomNumber();
      }
    }
    print(matrix);
  }

  int _generateRandomNumber() {
    var factor = Random().nextDouble();
    if (factor < 3 / 16) {
      return 1;
    } else if (factor < 6 / 16) {
      return 2;
    } else if (factor < 9 / 16) {
      return 3;
    } else {
      return 0;
    }
  }

  dispatch(Direction gesture) {
    print(gesture);
    switch (gesture) {
      case Direction.left:
        for (var i = 0; i < dimension; i++) {
          for (var j = 0; j < dimension; j++) {
            if (j == 0) {
              continue;
            }
            _attemptMoveTile(i, j, i, j - 1);
          }
        }
        break;
      case Direction.right:
        for (var i = 0; i < dimension; i++) {
          for (var j = dimension - 1; j >= 0; j--) {
            if (j == dimension - 1) {
              continue;
            }
            _attemptMoveTile(i, j, i, j + 1);
          }
        }
        break;
      case Direction.up:
        for (var j = 0; j < dimension; j++) {
          for (var i = 0; i < dimension; i++) {
            if (i == 0) {
              continue;
            }
            _attemptMoveTile(i, j, i - 1, j);
          }
        }
        break;
      case Direction.down:
        for (var j = 0; j < dimension; j++) {
          for (var i = dimension - 1; i >= 0; i--) {
            if (i == dimension - 1) {
              continue;
            }
            _attemptMoveTile(i, j, i + 1, j);
          }
        }
        break;
    }
    print(matrix);
  }

  _attemptMoveTile(int i, int j, int nextI, int nextJ) {
    // Empty space
    if (matrix[i][j] == 0) {
      return;
    }

    // Twins
    if (matrix[i][j] == matrix[nextI][nextJ]) {
      // Not actually twins
      if (matrix[i][j] == 1 || matrix[i][j] == 2) {
        return;
      }

      // Okay actually twins
      matrix[i][j] = 0;
      matrix[nextI][nextJ] *= 2;
      moveTitles.add(Tuple3<int, int, int>(i, j, matrix[nextI][nextJ]));
    } else {
      // Move to empty space
      if (matrix[nextI][nextJ] == 0) {
        matrix[nextI][nextJ] = matrix[i][j];
        matrix[i][j] = 0;
        moveTitles.add(Tuple3<int, int, int>(i, j, matrix[nextI][nextJ]));
      } else if ((matrix[i][j] == 1 && matrix[nextI][nextJ] == 2) ||
          (matrix[i][j] == 2 && matrix[nextI][nextJ] == 1)) {
        // 1 + 2 = 3
        matrix[nextI][nextJ] = 3;
        matrix[i][j] = 0;
        moveTitles.add(Tuple3<int, int, int>(i, j, matrix[nextI][nextJ]));
      }
    }
  }
}

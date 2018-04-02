import 'dart:math';

import 'package:threes_game/tile_action.dart';

enum Direction { left, up, right, down }

class TileMatrix {
  TileMatrix(this.dimension) {
    matrix = List.generate(dimension, (i) => List<int>(4)).toList();
    initMatrix();
  }

  final int dimension;

  List<List<int>> matrix;

  List<TileAction> unmovedTiles = List<TileAction>();
  List<TileAction> movedTiles = List<TileAction>();
  List<TileAction> animatedTiles = List<TileAction>();

  initMatrix() {
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
    unmovedTiles.clear();
    movedTiles.clear();
    animatedTiles.clear();
    switch (gesture) {
      case Direction.left:
        for (var i = 0; i < dimension; i++) {
          for (var j = 0; j < dimension; j++) {
            if (j == 0) {
              _addUnmovedAction(i, j, i, j, matrix[i][j]);
              continue;
            }
            _attemptMoveTile(i, j, i, j - 1);
          }
        }
        _generateNewTile(gesture);
        _mergeAnimatedTiles();
        break;
      case Direction.right:
        for (var i = 0; i < dimension; i++) {
          for (var j = dimension - 1; j >= 0; j--) {
            if (j == dimension - 1) {
              _addUnmovedAction(i, j, i, j, matrix[i][j]);
              continue;
            }
            _attemptMoveTile(i, j, i, j + 1);
          }
        }
        _generateNewTile(gesture);
        _mergeAnimatedTiles();
        break;
      case Direction.up:
        for (var j = 0; j < dimension; j++) {
          for (var i = 0; i < dimension; i++) {
            if (i == 0) {
              _addUnmovedAction(i, j, i, j, matrix[i][j]);
              continue;
            }
            _attemptMoveTile(i, j, i - 1, j);
          }
        }
        _generateNewTile(gesture);
        _mergeAnimatedTiles();
        break;
      case Direction.down:
        for (var j = 0; j < dimension; j++) {
          for (var i = dimension - 1; i >= 0; i--) {
            if (i == dimension - 1) {
              _addUnmovedAction(i, j, i, j, matrix[i][j]);
              continue;
            }
            _attemptMoveTile(i, j, i + 1, j);
          }
        }
        _generateNewTile(gesture);
        _mergeAnimatedTiles();
        break;
    }
    print(matrix);
  }

  _attemptMoveTile(int i, int j, int nextI, int nextJ) {
    final currentScore = matrix[i][j];
    // Empty space
    if (matrix[i][j] == 0) {
      _addUnmovedAction(i, j, i, j, currentScore);
      return;
    }

    // Twins
    if (matrix[i][j] == matrix[nextI][nextJ]) {
      // Not actually twins
      if (matrix[i][j] == 1 || matrix[i][j] == 2) {
        _addUnmovedAction(i, j, i, j, currentScore);
        return;
      }

      // Okay actually twins
      matrix[i][j] = 0;
      matrix[nextI][nextJ] *= 2;
      _addMovedTile(i, j, nextI, nextJ, currentScore);
    } else {
      // Move to empty space
      if (matrix[nextI][nextJ] == 0) {
        matrix[nextI][nextJ] = matrix[i][j];
        matrix[i][j] = 0;
        _addMovedTile(i, j, nextI, nextJ, currentScore);
      } else if ((matrix[i][j] == 1 && matrix[nextI][nextJ] == 2) ||
          (matrix[i][j] == 2 && matrix[nextI][nextJ] == 1)) {
        // 1 + 2 = 3
        matrix[nextI][nextJ] = 3;
        matrix[i][j] = 0;
        _addMovedTile(i, j, nextI, nextJ, currentScore);
      } else {
        _addUnmovedAction(i, j, i, j, currentScore);
      }
    }
  }

  _generateNewTile(Direction gesture) {
    if (movedTiles.isEmpty) {
      return;
    }
    final random = Random();
    final randomPosition = random.nextInt(3);
    final score = random.nextInt(2) + 1;
    switch (gesture) {
      case Direction.left:
        _addMovedTile(randomPosition, 4, randomPosition, 3, score);
        matrix[randomPosition][3] = score;
        break;
      case Direction.up:
        _addMovedTile(4, randomPosition, 3, randomPosition, score);
        matrix[3][randomPosition] = score;
        break;
      case Direction.right:
        _addMovedTile(randomPosition, -1, randomPosition, 0, score);
        matrix[randomPosition][0] = score;
        break;
      case Direction.down:
        _addMovedTile(-1, randomPosition, 0, randomPosition, score);
        matrix[0][randomPosition] = score;
        break;
    }
  }

  _mergeAnimatedTiles() {
    animatedTiles.addAll(unmovedTiles);
    animatedTiles.addAll(movedTiles);
  }

  _addUnmovedAction(int fromI, int fromJ, int destI, int destJ, int score) {
    unmovedTiles.add(TileAction(
        fromI: fromI, fromJ: fromJ, destI: destI, destJ: destJ, score: score));
  }

  _addMovedTile(int fromI, int fromJ, int destI, int destJ, int score) {
    movedTiles.add(TileAction(
        fromI: fromI, fromJ: fromJ, destI: destI, destJ: destJ, score: score));
  }
}

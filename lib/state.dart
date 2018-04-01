
import 'dart:math' show Point;
import 'package:threes_game/tile_matrix.dart';

class BoardState {
  List<List<int>> tiles;

  BoardState(this.tiles);

  static BoardState initiatalState() {
    TileMatrix matrix = new TileMatrix(4);
    return new BoardState(matrix.matrix);
  }

  BoardState moveLeft() {
    TileMatrix matrix = new TileMatrix.fromList(tiles);
    matrix.dispatch(Direction.left);
    return new BoardState(matrix.matrix);
  }

  BoardState moveRight() {  
    TileMatrix matrix = new TileMatrix.fromList(tiles);
    matrix.dispatch(Direction.right);
    return new BoardState(matrix.matrix);
  }

  BoardState moveUp() {
    TileMatrix matrix = new TileMatrix.fromList(tiles);
    matrix.dispatch(Direction.up);
    return new BoardState(matrix.matrix);
  }

  BoardState moveDown() {
    TileMatrix matrix = new TileMatrix.fromList(tiles);
    matrix.dispatch(Direction.down);
    return new BoardState(matrix.matrix);
  }
}

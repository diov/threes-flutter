import 'package:flutter/material.dart';
import 'package:threes_game/game_tile.dart';
import 'package:threes_game/theme.dart' as Theme;
import 'package:threes_game/tile_matrix.dart';

class GameGrid extends StatefulWidget {
  @override
  _GameGridState createState() {
    return _GameGridState();
  }
}

class _GameGridState extends State<GameGrid> {
  final tileMatrix = TileMatrix(4);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (DragEndDetails d) {
        if (d.primaryVelocity > 0) {
          dispatch(Direction.right);
        } else {
          dispatch(Direction.left);
        }
      },
      onVerticalDragEnd: (DragEndDetails d) {
        if (d.primaryVelocity > 0) {
          dispatch(Direction.down);
        } else {
          dispatch(Direction.up);
        }
      },
      child: GridView.count(
        primary: false,
        shrinkWrap: true,
        crossAxisCount: 4,
        childAspectRatio: Theme.Ratios.tileAspect,
        padding: EdgeInsets.all(4.0),
        children: _generateGrid(),
      ),
    );
  }

  List<Widget> _generateGrid() {
    return tileMatrix.matrix
        .expand((subList) => subList)
        .toList()
        .map((i) => GameTile(score: i))
        .toList();
  }

  dispatch(Direction direction) {
    setState(() => tileMatrix.dispatch(direction));
  }
}

import 'package:flutter/material.dart';
import 'package:threes_game/theme.dart' as Theme;
import 'package:threes_game/tile.dart';
import 'package:threes_game/tile_matrix.dart';
import 'package:threes_game/redux.dart';
import 'package:threes_game/store.dart';
import 'package:threes_game/state.dart';
import 'package:threes_game/action.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ThreeRedux(
      child: new MaterialApp(
      title: 'Threes powered by Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new Center(
          child: new Container(
            color: Theme.Colors.lightGreen,
            child: new ThreeHomePage(),
          ),
        ),
      ),
    ),
    );
  }
}

class ThreeHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (DragEndDetails d) {
        if (d.primaryVelocity > 0) {
          ThreeRedux.dispatch(context, new ThreeAction.moveRight());
        } else {
          ThreeRedux.dispatch(context, new ThreeAction.moveLeft());
        }
      },
      onVerticalDragEnd: (DragEndDetails d) {
        if (d.primaryVelocity > 0) {
          ThreeRedux.dispatch(context, new ThreeAction.moveDown());
        } else {
          ThreeRedux.dispatch(context, new ThreeAction.moveUp());
        }
      },
      child: new MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _slideController;

  _HomeState() {
    _slideController = new AnimationController(
      duration: new Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    _recycleAnimationControllers();

    StoreUpdate<BoardState, ThreeAction> currentState = ThreeRedux.stateOf(context);
    TileMatrix matrix = new TileMatrix.fromList(currentState.state.tiles);
    List<Widget> tiles = _generateTiles(matrix);

    return new AspectRatio(
      aspectRatio: 1.0,
      child: new Stack(
        children: tiles
      )
    );
  }

  startAnimate() {
    _slideController.forward();
  }

  _recycleAnimationControllers() {
    _slideController?.dispose();
    _slideController = new AnimationController(
      duration: new Duration(milliseconds: 150),
      vsync: this,
    );
  }

  List<Widget> _generateTiles(TileMatrix matrix) {
    List<Widget> tiles = List<Widget>();
    matrix.matrix.asMap().forEach((i, value) {
      value.asMap().forEach((j, item) {
        tiles.add(Tile(
          item,
          4,
          _slideController,
          fromI: i,
          fromJ: j,
          destI: i,
          destJ: j,
        ));
      });
    });
    return tiles;
  }

  dispatch(Direction direction) {
    setState(() {
      matrix.dispatch(direction);
    });
  }
}

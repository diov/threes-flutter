import 'package:flutter/material.dart';
import 'package:threes_game/theme.dart' as Theme;
import 'package:threes_game/tile.dart';
import 'package:threes_game/tile_matrix.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Threes powered by Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            color: Theme.Colors.lightGreen,
            child: MyHomePage(),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<MyHomePage> with TickerProviderStateMixin {
  TileMatrix matrix = TileMatrix(4);
  List<Widget> tiles = List<Widget>();
  AnimationController _slideController;

  _HomeState() {
    _recycleAnimationControllers();
    _generateTiles();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: Theme.Ratios.tileAspect,
      child: GestureDetector(
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
        child: Container(
          color: Theme.Colors.greyGreen,
          child: Stack(
            children: tiles,
          ),
        ),
      ),
    );
  }

  _recycleAnimationControllers() {
    _slideController?.dispose();
    _slideController = new AnimationController(
      duration: new Duration(milliseconds: 150),
      vsync: this,
    );
    _slideController.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        setState(() {
          tiles.clear();
          _generateTiles();
        });
      }
    });
  }

  /// generate tiles based on [TileMatrix]'s matrix data.
  _generateTiles() {
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
  }

  /// dispatch user gesture.
  /// 1. compute matrix move action in [TileMatrix].
  /// 2. display the animation base on [TileMatrix]'s animatedTiles.
  /// 3. display all tiles base on [TileMatrix]'s matrix.
  dispatch(Direction direction) {
    _recycleAnimationControllers();
    tiles.clear();
    setState(() {
      matrix.dispatch(direction);
      matrix.animatedTiles.forEach((action) {
        tiles.add(Tile(
          action.score,
          4,
          _slideController,
          fromI: action.fromI,
          fromJ: action.fromJ,
          destI: action.destI,
          destJ: action.destJ,
        ));
      });
      _slideController.forward();
    });
    print("totalScore: ${matrix.calculateTotalScore()}");
  }
}

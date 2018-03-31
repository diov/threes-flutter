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
    _slideController = new AnimationController(
      duration: new Duration(milliseconds: 1000),
      vsync: this,
    );
    _generateTiles();
  }

  @override
  Widget build(BuildContext context) {
    _recycleAnimationControllers();

    return AspectRatio(
      aspectRatio: 1.0,
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

  dispatch(Direction direction) {
    setState(() {
      matrix.dispatch(direction);
    });
  }
}

//class _GameWidget extends StatelessWidget {
//  const _GameWidget();
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
//        _generateBackground(),
//        GameGrid(),
//      ],
//    );
//  }
//
//  Widget _generateBackground() {
//    return GridView.count(
//      primary: false,
//      shrinkWrap: true,
//      crossAxisCount: 4,
//      childAspectRatio: Theme.Ratios.tileAspect,
//      padding: EdgeInsets.all(4.0),
//      children: _generateBackgroundTile(16),
//    );
//  }
//
//  List<Widget> _generateBackgroundTile(int count) {
//    return Iterable
//        .generate(
//            count,
//            (i) => Container(
//              margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                      color: Theme.Colors.greyGreen),
//                ))
//        .toList();
//  }
//}

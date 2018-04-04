import 'dart:async';

import 'package:flutter/material.dart';
import 'package:threes_game/game_tile.dart';
import 'package:threes_game/platform_channel.dart';
import 'package:threes_game/theme.dart' as Theme;
import 'package:threes_game/tile_matrix.dart';

void main() => runApp(ThreesApp());

class ThreesApp extends StatelessWidget {
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
            child: GamePanel(),
          ),
        ),
      ),
    );
  }
}

class GamePanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GamePanelState();
  }
}

class _GamePanelState extends State<GamePanel> with TickerProviderStateMixin {
  TileMatrix tileMatrix = TileMatrix(4);
  List<Widget> tiles = List<Widget>();
  AnimationController _slideController;

  _GamePanelState() {
    _recycleAnimationController();
    _generateTiles();
    _setupPlatformMessageHandler();
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

  /// dispose existed AnimationController and reset it.
  _recycleAnimationController() {
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
    tileMatrix.matrix.asMap().forEach((i, value) {
      value.asMap().forEach((j, item) {
        tiles.add(GameTile(
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
  /// 3. display all tiles base on [TileMatrix]'s matrix after animation
  /// finished.
  ///
  /// send game score to platform through [PlatformChannel] after every
  /// gesture finished.
  dispatch(Direction direction) {
    _recycleAnimationController();
    tiles.clear();
    setState(() {
      tileMatrix.dispatch(direction);
      tileMatrix.animatedTiles.forEach((action) {
        tiles.add(GameTile(
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
    PlatformChannel.displayGameScore(tileMatrix.calculateTotalScore());
  }

  @override
  void dispose() {
    _slideController?.dispose();
    super.dispose();
  }

  void _setupPlatformMessageHandler() {
    PlatformChannel.messageChannel.setMessageHandler(_handlePlatformMessage);
  }

  Future<String> _handlePlatformMessage(String message) async {
    setState(() {
      tiles.clear();
      tileMatrix.initMatrix();
      _generateTiles();
    });
    return "";
  }
}

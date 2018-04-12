import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:threes_game/theme.dart' as Theme;

class GameTile extends StatefulWidget {
  GameTile(this.score, this.dimension, this.controller,
      {@required this.fromI, @required this.fromJ, this.destI, this.destJ})
      : super(key: Key("$fromI$fromJ"));

  final int score;
  final int fromI;
  final int fromJ;
  final int dimension;
  final int destI;
  final int destJ;
  final AnimationController controller;

  @override
  State<StatefulWidget> createState() {
    return _TileState();
  }
}

class _TileState extends State<GameTile> {
  startAnimate() {
    setState(() {
      widget.controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.dimension - 1;
    final double sizeFactor = 1.toDouble() / widget.dimension.toDouble();
    final fromIPosition = lerpDouble(-1.0, 1.0, widget.fromI.toDouble() / step);
    final fromJPosition = lerpDouble(-1.0, 1.0, widget.fromJ.toDouble() / step);
    final destIPosition = lerpDouble(-1.0, 1.0, widget.destI.toDouble() / step);
    final destJPosition = lerpDouble(-1.0, 1.0, widget.destJ.toDouble() / step);

    Animation<Alignment> alignment = AlignmentTween(
      begin: Alignment(fromJPosition, fromIPosition),
      end: Alignment(destJPosition, destIPosition),
    ).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: widget.controller,
    ));

    return AlignTransition(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: sizeFactor,
        heightFactor: sizeFactor,
        child: _Tile(score: widget.score),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final int score;

  _Tile({@required this.score});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _generateOpacity(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          color: _generateTileBackground(),
        ),
        child: Center(
          child: Text(
            score.toString(),
            style: _generateTextStyle(),
          ),
        ),
      ),
    );
  }

  double _generateOpacity() {
    if (score == 0) {
      return 0.0;
    } else {
      return 1.0;
    }
  }

  TextStyle _generateTextStyle() {
    if (score < 3) {
      return TextStyle(
          color: Colors.white, fontSize: 35.0, fontFamily: "Nunito");
    } else {
      return TextStyle(
          color: Colors.black, fontSize: 35.0, fontFamily: "Nunito");
    }
  }

  Color _generateTileBackground() {
    switch (score) {
      case 1:
        return Theme.Colors.waterMelon;
      case 2:
        return Theme.Colors.pictonBlue;
      default:
        return Colors.white;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:threes_game/theme.dart' as Theme;

class GameTile extends StatelessWidget {
  final int score;

  GameTile({@required this.score});

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

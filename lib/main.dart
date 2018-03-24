import 'package:flutter/material.dart';
import 'package:threes_game/game_grid.dart';
import 'package:threes_game/theme.dart' as Theme;

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
            child: _GameWidget(),
          ),
        ),
      ),
    );
  }
}

class _GameWidget extends StatelessWidget {
  const _GameWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _generateBackground(),
        GameGrid(),
      ],
    );
  }

  Widget _generateBackground() {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: Theme.Ratios.tileAspect,
      padding: EdgeInsets.all(4.0),
      children: _generateBackgroundTile(16),
    );
  }

  List<Widget> _generateBackgroundTile(int count) {
    return Iterable
        .generate(
            count,
            (i) => Container(
              margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Theme.Colors.greyGreen),
                ))
        .toList();
  }
}

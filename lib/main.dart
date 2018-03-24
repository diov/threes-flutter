import 'package:flutter/material.dart';
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
            padding: EdgeInsets.all(10.0),
            color: Theme.Colors.lightGreen,
            child: _HomePageBackground(),
          ),
        ),
      ),
    );
  }
}

class _HomePageBackground extends StatelessWidget {
  const _HomePageBackground();

  @override
  Widget build(BuildContext context) {
    return _generateBackground();
  }

  Widget _generateBackground() {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
      childAspectRatio: 0.7,
      padding: EdgeInsets.all(4.0),
      children: _generateBackgroundTile(16),
    );
  }

  List<Widget> _generateBackgroundTile(int count) {
    return Iterable
        .generate(
            count,
            (i) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      color: Theme.Colors.greyGreen),
                ))
        .toList();
  }
}

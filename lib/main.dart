import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:conway_game_of_life/src/game_objects/gol_truths.dart';
import 'package:flutter/material.dart';

import 'src/screens/gol_grid_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => GoLTruths()..initGame(),
        ),
        ChangeNotifierProvider(
            create: (BuildContext context) => ColorConstants())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: MaterialCanvasGoL(),
      ),
    );
  }
}

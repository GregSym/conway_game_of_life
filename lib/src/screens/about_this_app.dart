import 'package:flutter/material.dart';

class AboutThisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              "About this App:",
            ),
            Text(
                "This is a demonstration of Conway's Game of Life, a mathematical model of cellular automata"),
            Text(
                "Each cell is governed by a set of rules based on its relationship to surrounding cells."),
            Text("The rules may be simplified as follows: "),
            RuleText(
                ruleText:
                    "Any dead cell comes alive when neighbouring 3 alive cells"),
            RuleText(
                ruleText:
                    "Living cells surrounded by either 2 or 3 alive neighbouring cells remain alive"),
            RuleText(
                ruleText:
                    "All other cells will be dead in the next iteration of the Game"),
          ],
        ),
      ),
    );
  }
}

class RuleText extends StatelessWidget {
  const RuleText({
    Key key,
    @required this.ruleText,
  }) : super(key: key);

  final String ruleText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(Icons.east), Text(ruleText)],
    );
  }
}
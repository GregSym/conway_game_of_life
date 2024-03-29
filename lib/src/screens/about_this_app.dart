import 'package:conway_game_of_life/src/constants/color_constants.dart';
import 'package:conway_game_of_life/src/constants/hyperlinks.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; //thanks flutter.dev!

class AboutThisApp extends StatelessWidget {
  /*
  An about this app screen - might be worked into a reactive solution!
  TODO: add more info about John Conway!
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "About this App:",
                textAlign: TextAlign.center,
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0),
              ),
              Text(
                "This is a demonstration of Conway's Game of Life, a mathematical model of cellular automata",
                textAlign: TextAlign.center,
              ),
              Text(
                "Each cell is governed by a set of rules based on its relationship to surrounding cells.",
                textAlign: TextAlign.center,
              ),
              Text(
                "The rules may be simplified as follows: ",
                textAlign: TextAlign.center,
              ),
              RuleText(
                  ruleText:
                      "Any dead cell comes alive when neighbouring 3 alive cells"),
              RuleText(
                  ruleText:
                      "Living cells surrounded by either 2 or 3 alive neighbouring cells remain alive"),
              RuleText(
                  ruleText:
                      "All other cells will be dead in the next iteration of the Game"),
              Text(
                "App Author: Gregory Symington",
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                  onTap: () => launch(hyperLinks.sourceCode),
                  child: Text(
                    "Source code hosted by Github",
                    style: TextStyle(color: colourConstants.hRefColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class RuleText extends StatelessWidget {
  const RuleText({
    Key? key,
    required this.ruleText,
  }) : super(key: key);

  final String ruleText;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.east,
            color: Colors.purple[600],
          ),
          Container(
            width: screenSize.width / 1.2,
            child: Text(
              ruleText,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}

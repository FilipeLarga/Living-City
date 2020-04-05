import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage();

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  int _selectedIndex = 0;

  final List<Color> _colors = [Colors.blue, Colors.red, Colors.yellow];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            color: Colors.lightBlue,
            child: MaterialButton(onPressed: () {
              setState(() {
                _selectedIndex == 2 ? _selectedIndex = 0 : _selectedIndex++;
              });
            }),
          ),
          Expanded(
              child: PageTransitionSwitcher(
            transitionBuilder: (child, animation, animation2) {
              return FadeThroughTransition(
                child: child,
                animation: animation,
                secondaryAnimation: animation2,
              );
            },
            child: Container(
              key: ValueKey(_selectedIndex),
              color: _colors[_selectedIndex],
            ),
          ))
        ],
      ),
    );
  }
}

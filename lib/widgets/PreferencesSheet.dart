import 'package:flutter/material.dart';

class PreferencesSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Travel Preferences',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Stack(children: <Widget>[
            Container(color: Colors.red),
            Center(
              child: AnimatedImage(
                selectedDuration: 2,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              top: 0,
              bottom: 24,
              left: 0,
              right: 100,
              child: Icon(
                Icons.person_pin,
                size: 38,
                color: Colors.red,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              top: 0,
              bottom: 24,
              left: 100,
              right: 0,
              child: Icon(
                Icons.flag,
                size: 38,
                color: Colors.blue,
              ),
            ),
          ]),
        ),
        Text('Duration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        SizedBox(height: 12),
        _DurationSelection(
          context: context,
          durationLimit: 45,
        ),
        SizedBox(height: 18),
        Text(
          'Points of Interest',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Text(
          'Unit',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// class TimeChipSelection extends StatefulWidget {
//   @override
//   _TimeChipSelectionState createState() => _TimeChipSelectionState();
// }

/*class _TimeChipSelectionState extends State<TimeChipSelection> {
  int _selected = 4;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ChoiceChip(
          label: Text(
            'Under 15',
          ),
          selected: _selected == 1,
          pressElevation: 2,
          onSelected: (selected) {
            setState(() {
              _selected = 1;
            });
          },
        ),
        ChoiceChip(
          label: Text(
            'Under 30',
          ),
          selected: _selected == 2,
          pressElevation: 2,
          onSelected: (selected) {
            setState(() {
              _selected = 2;
            });
          },
        ),
        ChoiceChip(
          label: Text(
            'Under 45',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          selected: _selected == 3,
          pressElevation: 2,
          onSelected: (selected) {
            setState(() {
              _selected = 3;
            });
          },
        ),
        ChoiceChip(
          label: Text(
            'Under 60',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          selected: _selected == 4,
          pressElevation: 2,
          onSelected: (selected) {
            setState(() {
              _selected = 4;
            });
          },
        ),
      ],
    );
  }
}*/

/*class PreferencesHeader extends StatelessWidget {
  final String title;
  final Icon icon;

  const PreferencesHeader({Key key, @required this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Duration',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            icon ?? Container()
          ],
        ),
        Container(
          height: 1,
          color: Colors.grey[300],
        )
      ],
    );
  }
}*/

class _DurationSelection extends StatefulWidget {
  final int durationLimit;
  final BuildContext context;

  const _DurationSelection(
      {Key key, @required this.durationLimit, @required this.context})
      : super(key: key);

  @override
  _DurationSelectionState createState() => _DurationSelectionState();
}

class _DurationSelectionState extends State<_DurationSelection> {
  int _selection;
  Color _unselectedColor;

  @override
  void initState() {
    super.initState();
    _selection = (widget.durationLimit.toInt() ~/ 15);
    _unselectedColor = Theme.of(widget.context).primaryColorLight;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () {
              if (_selection != 1) {
                setState(() => _selection = 1);
              }
            },
            child: Container(
              height: 18,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  bottomLeft: const Radius.circular(24),
                ),
                boxShadow: const <BoxShadow>[
                  const BoxShadow(
                      offset: Offset(0.0, 2.0),
                      blurRadius: 1.0,
                      spreadRadius: -1.0,
                      color: Color(0x33000000)),
                  const BoxShadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                      color: Color(0x24000000)),
                  const BoxShadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 3.0,
                      spreadRadius: 0.0,
                      color: Color(0x1F000000)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              if (_selection != 2) {
                setState(() => _selection = 2);
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 170),
              height: 18,
              decoration: BoxDecoration(
                color: _selection >= 2
                    ? Theme.of(context).accentColor
                    : _unselectedColor,
                boxShadow: _selection < 2
                    ? const <BoxShadow>[]
                    : const <BoxShadow>[
                        const BoxShadow(
                            offset: Offset(0.0, 2.0),
                            blurRadius: 1.0,
                            spreadRadius: -1.0,
                            color: Color(0x33000000)),
                        const BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 1.0,
                            spreadRadius: 0.0,
                            color: Color(0x24000000)),
                        const BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 3.0,
                            spreadRadius: 0.0,
                            color: Color(0x1F000000)),
                      ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              if (_selection != 3) {
                setState(() => _selection = 3);
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 170),
              height: 18,
              decoration: BoxDecoration(
                color: _selection >= 3
                    ? Theme.of(context).accentColor
                    : _unselectedColor,
                boxShadow: _selection < 3
                    ? const <BoxShadow>[]
                    : const <BoxShadow>[
                        const BoxShadow(
                            offset: Offset(0.0, 2.0),
                            blurRadius: 1.0,
                            spreadRadius: -1.0,
                            color: Color(0x33000000)),
                        const BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 1.0,
                            spreadRadius: 0.0,
                            color: Color(0x24000000)),
                        const BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 3.0,
                            spreadRadius: 0.0,
                            color: Color(0x1F000000)),
                      ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              if (_selection != 4) {
                setState(() => _selection = 4);
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 170),
              height: 18,
              decoration: BoxDecoration(
                color: _selection >= 4
                    ? Theme.of(context).accentColor
                    : _unselectedColor,
                boxShadow: _selection < 4
                    ? const <BoxShadow>[]
                    : const <BoxShadow>[
                        BoxShadow(
                            offset: Offset(0.0, 2.0),
                            blurRadius: 1.0,
                            spreadRadius: -1.0,
                            color: Color(0x33000000)),
                        BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 1.0,
                            spreadRadius: 0.0,
                            color: Color(0x24000000)),
                        BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 3.0,
                            spreadRadius: 0.0,
                            color: Color(0x1F000000)),
                      ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              if (_selection != 5) {
                setState(() => _selection = 5);
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 170),
              height: 18,
              decoration: BoxDecoration(
                color: _selection >= 5
                    ? Theme.of(context).accentColor
                    : _unselectedColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: _selection < 5
                    ? const <BoxShadow>[]
                    : const <BoxShadow>[
                        BoxShadow(
                            offset: Offset(0.0, 2.0),
                            blurRadius: 1.0,
                            spreadRadius: -1.0,
                            color: Color(0x33000000)),
                        BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 1.0,
                            spreadRadius: 0.0,
                            color: Color(0x24000000)),
                        BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 3.0,
                            spreadRadius: 0.0,
                            color: Color(0x1F000000)),
                      ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedImage extends StatefulWidget {
  final int selectedDuration;
  final int selectedPOIs;

  const AnimatedImage(
      {Key key, @required this.selectedDuration, this.selectedPOIs})
      : super(key: key);

  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(AnimatedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runAnimation();
  }

  void _runAnimation() {
    print('widget duration: ${widget.selectedDuration}');
    if (widget.selectedDuration != null) {
      _animationController.animateTo(widget.selectedDuration / 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('$_animation');

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: SizeTransition(
        axis: Axis.horizontal,
        sizeFactor: _animation,
        child: Image.asset(
          'assets/distance_map.png',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

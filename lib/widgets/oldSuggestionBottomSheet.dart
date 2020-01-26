import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:living_city/widgets/SuggestionItem.dart';

class OldSuggestionBottomSheet extends StatefulWidget {
  final double peekHeight;
  final double maxHeight;

  OldSuggestionBottomSheet({this.peekHeight, this.maxHeight});

  @override
  _OldSuggestionBottomSheetState createState() => _OldSuggestionBottomSheetState();
}

class _OldSuggestionBottomSheetState extends State<OldSuggestionBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _heightAnimation;
  Tween<double> _heightTween;
  Animation<double> _cornerRadiousAnimation;
  Tween<double> _cornerRadiousTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _heightTween =
        Tween<double>(begin: widget.peekHeight, end: widget.maxHeight);

    _cornerRadiousTween = Tween<double>(begin: 22, end: 0);

    _heightAnimation = _heightTween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _cornerRadiousAnimation = _cornerRadiousTween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose(); //<-- and remember to dispose it!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSheet,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding:
                const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
            height: _heightAnimation.value,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const <BoxShadow>[
                  const BoxShadow(
                      offset: const Offset(0.0, 2.0),
                      blurRadius: 4.0,
                      spreadRadius: -1.0,
                      color: const Color(0x33000000)),
                  const BoxShadow(
                      offset: const Offset(0.0, 4.0),
                      blurRadius: 5.0,
                      spreadRadius: 0.0,
                      color: const Color(0x24000000)),
                  const BoxShadow(
                      offset: const Offset(0.0, 1.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      color: const Color(0x1F000000)),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_cornerRadiousAnimation.value),
                    topRight: Radius.circular(_cornerRadiousAnimation.value))),
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 4,
              width: 42,
              decoration: ShapeDecoration(
                  color: Colors.grey[350], shape: const StadiumBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            SuggestionListItem(
              title: 'Calouste Gulbenkian Museum',
              distance: 2.0,
              price: 2.0,
            ),
            /*Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/iscte.jpg',
                      height: 128,
                      width: 128,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("ISCTE - Mostrar distância, lotação, preço, etc..."),
                      ],
                    ),
                  )
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void _toggleSheet() {
    final bool isOpen = _heightAnimation.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -=
        details.primaryDelta / (widget.maxHeight - widget.peekHeight);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;
    final double flingVelocity = details.velocity.pixelsPerSecond.dy /
        widget.maxHeight; //<-- calculate the velocity of the gesture
    if (flingVelocity < 0.0)
      _controller.fling(
          velocity:
              math.max(2.0, -flingVelocity)); //<-- either continue it upwards
    else if (flingVelocity > 0.0)
      _controller.fling(
          velocity:
              math.min(-2.0, -flingVelocity)); //<-- or continue it downwards
    else
      _controller.fling(
          velocity: _controller.value < 0.5
              ? -2.0
              : 2.0); //<-- or just continue to whichever edge is closer
  }
}

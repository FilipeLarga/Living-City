import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExpandingBottomSheet extends StatefulWidget {
  final double peekHeight;
  final double peekCornerRadius;
  final double maxHeight;
  final double maxCornerRadius;
  final ExpandingBottomSheetController controller;
  final Widget child;

  const ExpandingBottomSheet({
    Key key,
    this.peekHeight,
    this.peekCornerRadius,
    @required this.maxHeight,
    @required this.maxCornerRadius,
    @required this.controller,
    @required this.child,
  }) : super(key: key);

  @override
  _ExpandingBottomSheetState createState() => _ExpandingBottomSheetState();
}

class _ExpandingBottomSheetState extends State<ExpandingBottomSheet>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> _heightAnimation;
  Tween<double> _heightTween;
  Animation<double> _radiusAnimation;
  Tween<double> _radiusTween;

  bool _isDragging = false;
  bool _useLinear = false;

  @override
  void initState() {
    super.initState();
    widget.controller.attach(this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _heightTween = Tween(
      begin: widget.peekHeight ?? 0,
      end: widget.maxHeight,
    );
    _radiusTween = Tween(
      begin: widget.peekCornerRadius ?? widget.maxCornerRadius,
      end: widget.maxCornerRadius,
    );

    _heightAnimation = _heightTween.animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut))
        ..addStatusListener((status) {
        if ((status == AnimationStatus.completed || status == AnimationStatus.dismissed) && !_isDragging) {
          _useLinear = false;
        }
      })
        ;

    _radiusAnimation = _radiusTween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutExpo));
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.detach();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            height: _useLinear
                ? _heightTween.evaluate(_animationController)
                : _heightAnimation.value,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_radiusAnimation.value),
                topRight: Radius.circular(_radiusAnimation.value),
              ),
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
            ),
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: Container(
                height: 4,
                width: 38,
                decoration: ShapeDecoration(
                    color: Colors.grey[350], shape: const StadiumBorder()),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _useLinear = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -=
        details.primaryDelta / (widget.maxHeight - (widget.peekHeight ?? 0));
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) {
      return;
    }
    final double flingVelocity = details.velocity.pixelsPerSecond.dy /
        widget.maxHeight; //<-- calculate the velocity of the gesture
    if (flingVelocity < 0.0)
      _animationController.fling(
          velocity:
              math.max(2.0, -flingVelocity)); //<-- either continue it upwards
    else if (flingVelocity > 0.0)
      _animationController.fling(
          velocity:
              math.min(-2.0, -flingVelocity)); //<-- or continue it downwards
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5
              ? -2.0
              : 2.0); //<-- or just continue to whichever edge is closer
  }

  void _animateToPeekThreshold() {
    if (widget.peekHeight != null) {
      double threshold = _heightTween
          .lerp(widget.peekHeight); // ignore: invalid_use_of_protected_member
      _animationController.animateTo(threshold);
    }
  }

  void _animateToMaxThreshold() {
    double threshold = _heightTween
        .lerp(widget.maxHeight); // ignore: invalid_use_of_protected_member
    _animationController.animateTo(
      threshold,
    );
  }

  void _animatedToHidden() {
    _animationController.animateTo(0);
  }
}

class ExpandingBottomSheetController {
  _ExpandingBottomSheetState _expandingBottomSheet;

  void attach(_ExpandingBottomSheetState expandingBottomSheet) {
    assert(_expandingBottomSheet == null,
        "ExpandingBottomSheetController can only have one ExpandingBottomSheet");
    _expandingBottomSheet = expandingBottomSheet;
  }

  void detach() {
    assert(_expandingBottomSheet != null,
        "ExpandingBottomSheetController has no ExpandingBottomSheet to detach");
    _expandingBottomSheet = null;
  }

  void animateToMaxThreshold() {
    _expandingBottomSheet._animateToMaxThreshold();
  }

  void animateToPeek() {
    _expandingBottomSheet._animateToPeekThreshold();
  }

  void animateToHidden() {
    _expandingBottomSheet._animatedToHidden();
  }
}

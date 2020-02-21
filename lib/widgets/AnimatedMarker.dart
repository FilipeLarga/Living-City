import 'package:flutter/material.dart';

class AnimatedMarker extends StatefulWidget {
  final IconData iconData;

  const AnimatedMarker({Key key, @required this.iconData}) : super(key: key);

  @override
  _AnimatedMarkerState createState() => _AnimatedMarkerState();
}

class _AnimatedMarkerState extends State<AnimatedMarker>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _fadeAnimation;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, -0.4),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Icon(
          widget.iconData,
          size: 36,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NormalMarker extends StatelessWidget {
  final IconData iconData;

  const NormalMarker({Key key, @required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -0.4 * 36),
      child: Icon(
        iconData,
        size: 36,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}

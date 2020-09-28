import 'package:flutter/material.dart';

class CircleMarker extends StatelessWidget {
  final Color color;

  const CircleMarker({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
              color: color ?? Theme.of(context).accentColor, width: 2)),
    );
  }
}

class TargetCircleMarker extends StatelessWidget {
  final double spreadsize;
  final Color color;

  const TargetCircleMarker({Key key, this.color, this.spreadsize = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (color ?? Theme.of(context).accentColor)
                      .withOpacity(0.5)),
            ),
            SizedBox(
              height: constraints.maxHeight - spreadsize,
              width: constraints.maxWidth - spreadsize,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color ?? Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PointOfInterestMarker extends StatelessWidget {
  final Color color;
  final Function() onTapCallback;

  const PointOfInterestMarker(
      {Key key, this.color, @required this.onTapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapCallback,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
                color: color ?? Theme.of(context).accentColor, width: 2)),
      ),
    );
  }
}

class TripPOIMarker extends StatelessWidget {
  final Color color;

  const TripPOIMarker({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-2, -12),
      child: Icon(
        Icons.place,
        color: color ?? Theme.of(context).accentColor,
        size: 32,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EmptyListException extends StatelessWidget {
  final String message;
  final Widget child;
  final double imageWidth;

  const EmptyListException(
      {Key key, this.message, this.imageWidth = 192, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 0.8,
          child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 1, minHeight: 1),
                child: Image.asset(
                  'assets/empty_list.png',
                ),
              )),
        ),
        const SizedBox(height: 8),
        child ?? Text(message)
      ],
    );
  }
}

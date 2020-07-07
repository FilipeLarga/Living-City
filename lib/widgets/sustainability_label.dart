import 'package:flutter/material.dart';

class SustainabilityLabel extends StatelessWidget {
  final int sustainability;

  const SustainabilityLabel({Key key, @required this.sustainability})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _calculateColor(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(_calculateText()),
    );
  }

  Color _calculateColor() {
    if (sustainability > 80) {
      return Colors.greenAccent[400];
    } else if (sustainability > 60) {
      return Colors.green;
    } else
      return Colors.red[100];
  }

  String _calculateText() {
    if (sustainability > 80) {
      return 'Very Sustainable';
    } else if (sustainability > 60) {
      return 'Sustainable';
    } else
      return 'Not Sustainable';
  }
}

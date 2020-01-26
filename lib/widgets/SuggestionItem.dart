import 'package:flutter/cupertino.dart';

class SuggestionListItem extends StatelessWidget {
  final String title;
  final double price;
  final double distance;

  SuggestionListItem({
    @required this.title,
    @required this.price,
    @required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final Function() onCenterLocationPress;
  final Function() onShowPOIsPress;

  const MapControls(
      {@required this.onCenterLocationPress, @required this.onShowPOIsPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromRGBO(255, 255, 255, 0.75),
        boxShadow: [
          const CustomBoxShadow(
              color: Colors.grey, blurRadius: 10, blurStyle: BlurStyle.outer),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: onCenterLocationPress,
            child: const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: const Icon(Icons.my_location),
            ),
          ),
          SizedBox(
            height: 16,
            child: Center(
              child: Container(
                height: 1,
                width: 40,
                color: const Color(0xFFD6D6D6),
              ),
            ),
          ),
          GestureDetector(
            onTap: onShowPOIsPress,
            child: const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: const Icon(Icons.place),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(
            color: color,
            offset: offset,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class TripDetailsPage extends StatelessWidget {
  static const routeName = 'journal/trip_details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Container(
        child: Center(
          child: Text('BEEP BOOP'),
        ),
      ),
    );
  }

  LatLng _getCenter(LatLng start, LatLng end) {
    return LatLng((start.latitude - end.latitude).abs(),
        (start.longitude - end.longitude).abs());
  }
}

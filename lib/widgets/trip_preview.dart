import 'package:flutter/material.dart';
import '../data/models/trip_model.dart';
import 'package:flutter_map/flutter_map.dart';

class TripPreview extends StatelessWidget {
  final TripModel trip;

  const TripPreview({Key key, @required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          interactive: false,
          bounds: LatLngBounds.fromPoints(trip.line),
          boundsOptions:
              FitBoundsOptions(padding: EdgeInsets.all(16), maxZoom: 16),
        ),
        layers: [
          TileLayerOptions(
              tileProvider: AssetTileProvider(),
              urlTemplate: 'assets/map/{z}/{x}/{y}.png',
              tms: true),
          PolylineLayerOptions(
            polylineCulling: true,
            polylines: [
              Polyline(points: trip.line, color: Colors.orange, strokeWidth: 3)
            ],
          ),
          MarkerLayerOptions(
            markers: trip.pois
                .map((timedpoi) => Marker(
                      point: timedpoi.poi.coordinates,
                      height: 36,
                      width: 36,
                      builder: (context) =>
                          Icon(Icons.place, color: Colors.deepOrangeAccent),
                    ))
                .toList(),
          ),
        ]);
  }
}

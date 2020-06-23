import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/markers.dart' as marker_widgets;

class LineMap extends StatelessWidget {
  final List<LatLng> line;
  final Color backgroundColor;
  final double padding;

  const LineMap({
    Key key,
    @required this.line,
    this.backgroundColor = const Color(0xffFCFBE7),
    this.padding = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          interactive: false,
          bounds: LatLngBounds.fromPoints(line),
          boundsOptions:
              FitBoundsOptions(padding: EdgeInsets.all(padding), maxZoom: 16),
        ),
        layers: [
          PolylineLayerOptions(
            polylineCulling: true,
            polylines: [
              Polyline(points: line, color: Colors.orange, strokeWidth: 3)
            ],
          ),
        ]);
  }
}

class LineAndMarkersMap extends StatelessWidget {
  final List<LatLng> line;
  final List<LatLng> markers;
  final LatLng target;
  final Color backgroundColor;
  final double padding;

  const LineAndMarkersMap({
    Key key,
    @required this.line,
    @required this.markers,
    @required this.target,
    this.backgroundColor = const Color(0xffFCFBE7),
    this.padding = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          interactive: false,
          bounds: LatLngBounds.fromPoints(line),
          boundsOptions:
              FitBoundsOptions(padding: EdgeInsets.all(padding), maxZoom: 16),
        ),
        layers: [
          PolylineLayerOptions(
            polylineCulling: true,
            polylines: [
              Polyline(points: line, color: Colors.orange, strokeWidth: 3)
            ],
          ),
          MarkerLayerOptions(
              markers: markers.map((LatLng coords) {
            if (coords != target)
              return Marker(
                  height: 10,
                  width: 10,
                  point: coords,
                  builder: (context) {
                    return marker_widgets.CircleMarker(
                      color: Colors.orange,
                    );
                  });
            else
              return Marker(
                  height: 20,
                  width: 20,
                  point: coords,
                  builder: (context) {
                    return marker_widgets.TargetCircleMarker(
                      spreadsize: 10,
                      color: Colors.orange,
                    );
                  });
          }).toList()),
        ]);
  }
}

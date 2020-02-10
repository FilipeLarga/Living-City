import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:living_city/bloc/route_selection_bloc/bloc.dart';
import 'package:living_city/data/models/search_location_model.dart';
import '../bloc/search_location_bloc/bloc.dart';
import '../core/Coordinates.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  MapController mapController;
  AnimationController _animationController;

  final List<Marker> _markers = [];
  List<LatLng> points;

  @override
  void initState() {
    super.initState();
    //loadMarkers();
    //loadPoints();
    _markers.add(Marker(
        point: LatLng(38.748753, -9.153692),
        height: 48,
        width: 48,
        builder: (ctx) => Container()));
    mapController = MapController();
  }

  @override
  void dispose() {
    super.dispose();
    if (_animationController != null) _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SearchLocationBloc, SearchLocationState>(
          listener: (context, state) {
            _searchLocationListener(context, state);
          },
        ),
        BlocListener<RouteSelectionBloc, RouteSelectionState>(
          listener: (context, state) {
            _routeSelectionListener(context, state);
          },
        ),
      ],
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: _handleTap,
          center: lisbon,
          zoom: 15.0,
          minZoom: 15.0,
          maxZoom: 15.0,
          swPanBoundary: swBound,
          nePanBoundary: neBound,
        ),
        layers: [
          TileLayerOptions(
            keepBuffer: 4,
            tileProvider: AssetTileProvider(),
            urlTemplate: "assets/map/{z}/{x}/{y}.png",
            maxZoom: 16,
            tms: true,
            backgroundColor: const Color(0xffFCFBE7),
          ),
          // PolylineLayerOptions(
          //   polylines: [
          //     Polyline(points: points, strokeWidth: 4.0, color: Colors.blue),
          //   ],
          // ),
          MarkerLayerOptions(
            markers: _markers,
          ),
        ],
      ),
    );
  }

  void loadMarkers() {
    _markers.addAll([
      Marker(
        point: lisbon,
        height: 48,
        width: 48,
        builder: (ctx) => Icon(
          Icons.room,
          size: 48,
          key: Key("lisbon"),
          color: Theme.of(context).accentColor,
        ),
      )
    ]);
  }

  void loadPoints() {
    points = <LatLng>[
      LatLng(38.748753, -9.153692),
      LatLng(38.3498, -9.153692),
    ];
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);

    Animation<double> zoomAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(zoomAnimation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.dispose();
      }
    });

    _animationController.forward();
  }

  void _handleTap(LatLng latlng) {
    BlocProvider.of<SearchLocationBloc>(context).add(SearchRequestEvent(
        searchLocation: SearchLocationModel(coordinates: latlng)));
    //ADD HERE ROUTE PROVIDER
  }

  void _searchLocationListener(
      BuildContext context, SearchLocationState state) {
    if (state is ShowingLocationSearchState) {
      setState(() {
        _markers.removeRange(1, _markers.length);
        _markers.add(Marker(
          point: state.searchLocation.coordinates,
          height: 48,
          width: 48,
          builder: (ctx) => Icon(
            Icons.room,
            size: 48,
            color: Theme.of(context).accentColor,
          ),
        ));
        _animatedMapMove(state.searchLocation.coordinates, 15);
      });
    } else if (state is InitialSearchState) {
      setState(() {
        _markers.removeRange(1, _markers.length);
      });
    }
  }

  void _routeSelectionListener(
      BuildContext context, RouteSelectionState state) {
    if (state is SelectingRouteState) {
      setState(() {
        _markers.removeRange(1, _markers.length);
        if (state.loop) {
          _markers.add(Marker(
            point: state.startLocation.coordinates,
            height: 48,
            width: 48,
            builder: (ctx) => Icon(
              Icons.place,
              size: 48,
              color: Theme.of(context).accentColor,
            ),
          ));
          _animatedMapMove(state.startLocation.coordinates, 15);
        } else {
          _markers.add(Marker(
            point: state.startLocation.coordinates,
            height: 48,
            width: 48,
            builder: (ctx) => Icon(
              Icons.place,
              size: 48,
              color: Theme.of(context).accentColor,
            ),
          ));
          _markers.add(Marker(
            point: state.destinationLocation.coordinates,
            height: 48,
            width: 48,
            builder: (ctx) => Icon(
              Icons.flag,
              size: 48,
              color: Theme.of(context).accentColor,
            ),
          ));
        }
      });
    } else if (state is InitialSearchState) {
      setState(() {
        _markers.removeRange(1, _markers.length);
      });
    }
  }
}

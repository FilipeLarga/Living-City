import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../bloc/location/location_bloc.dart';
import 'package:latlong/latlong.dart';
import 'dart:math' as Math;
import '../../../core/distance_helper.dart';
import '../../../bloc/route_request/route_request_bloc.dart';
import '../../../bloc/user_location/user_location_bloc.dart';
import '../../../data/models/trip_model.dart';
import '../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../bloc/points_of_interest/points_of_interest_bloc.dart';
import '../../../widgets/markers.dart' as markers;
import 'map_controls.dart';

class MapView extends StatefulWidget {
  const MapView();

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  MapController _mapController;

  //flutter map is bugged and calls onPositionChanged the first time it builds
  bool _initialMove;

  //flags for map control widget
  bool _isCenteringUser;
  bool _isShowingPOIs;

  List<Marker> _pointsOfInterest = [];
  List<Marker> _locationMarkers = [];
  List<Marker> _pointMarkers = [];
  Marker _userLocation;

  TripModel _tripModel;

  bool _wasTrip = false;

  bool _showRecenter = false;

  @override
  void initState() {
    super.initState();
    _initialMove = true;
    _isCenteringUser = true;

    // _isCenteringUser =
    //     BlocProvider.of<UserLocationBloc>(context).state is UserLocationLoaded;
    _isShowingPOIs = true;
    _mapController = MapController();
    if (BlocProvider.of<PointsOfInterestBloc>(context).state
        is PointsOfInterestLoaded)
      _pointsOfInterest = (BlocProvider.of<PointsOfInterestBloc>(context).state
              as PointsOfInterestLoaded)
          .pois
          .map((poi) => Marker(
                height: 16,
                width: 16,
                point: poi.coordinates,
                builder: (context) => markers.PointOfInterestMarker(
                  onTapCallback: () =>
                      BlocProvider.of<BSNavigationBloc>(context)
                          .add(BSNavigationLocationSelected(address: poi.name)),
                ),
              ))
          .toList();
    if (BlocProvider.of<UserLocationBloc>(context).state is UserLocationLoaded)
      _userLocation = Marker(
        height: 28,
        width: 28,
        point: (BlocProvider.of<UserLocationBloc>(context).state
                as UserLocationLoaded)
            .location,
        builder: (context) => markers.TargetCircleMarker(spreadsize: 14),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserLocationBloc, UserLocationState>(
            listener: (context, state) {
          if (state is UserLocationLoaded) {
            bool isNear;
            if (_tripModel?.line != null) {
              int result = locationIndexOnEdgeOrPath(
                  state.location, _tripModel?.line, false, true, 30);
              isNear = result != -1;
            }
            setState(() {
              _showRecenter = isNear != null ? !isNear : false;
              _userLocation = Marker(
                height: 28,
                width: 28,
                point: state.location,
                builder: (context) =>
                    markers.TargetCircleMarker(spreadsize: 14),
              );
            });
          }
        }),
        BlocListener<RouteRequestBloc, RouteRequestState>(
          listener: (context, state) {
            if (state is RouteRequestLoaded) {
              setState(() {
                _wasTrip = true;
                _isShowingPOIs = false;
                _locationMarkers.clear();
                _pointMarkers.clear();
                _tripModel = state.tripModel;
                _pointMarkers.add(Marker(
                    point: state.tripModel.origin.coordinates,
                    height: 20,
                    width: 20,
                    builder: (context) => markers.TripOriginMarker()));
                _pointMarkers.add(Marker(
                    point: state.tripModel.destination.coordinates,
                    height: 32,
                    width: 32,
                    builder: (context) => markers.TripDestinationMarker()));
                for (int i = 0; i < state.tripModel.pois.length; i++) {
                  _pointMarkers.add(Marker(
                    point: state.tripModel.pois.elementAt(i).poi.coordinates,
                    height: 20,
                    width: 20,
                    builder: (context) => markers.TripPOIMarker(
                      color: const Color(0xFF666666),
                      order: i + 1,
                    ),
                  ));
                }
              });
              _animatedFitBounds(
                  LatLngBounds(state.tripModel.origin.coordinates,
                      state.tripModel.destination.coordinates),
                  options: FitBoundsOptions(
                      maxZoom: 15,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 32,
                          right: 48,
                          left: 48,
                          bottom: 64)));
            } else
              _tripModel = null;
          },
        ),
        BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded)
              _animatedMapMove(state.location?.coordinates ?? state.location,
                      _mapController.zoom)
                  .then((value) => setState(() {
                        _locationMarkers.add(Marker(
                            height: 16,
                            width: 16,
                            point:
                                state.location?.coordinates ?? state.location,
                            builder: (context) => markers.CircleMarker()));
                      }));
          },
        ),
        BlocListener<PointsOfInterestBloc, PointsOfInterestState>(
          listener: (context, state) {
            if (state is PointsOfInterestLoaded) {
              setState(() {
                _pointsOfInterest = state.pois
                    .map((poi) => Marker(
                          height: 16,
                          width: 16,
                          point: poi.coordinates,
                          builder: (context) => markers.PointOfInterestMarker(
                            onTapCallback: () {
                              BlocProvider.of<BSNavigationBloc>(context).add(
                                  BSNavigationLocationSelected(
                                      address: poi.name));
                            },
                          ),
                        ))
                    .toList();
              });
            }
          },
        ),
        BlocListener<BSNavigationBloc, BSNavigationState>(
          listener: (context, state) {
            if (!(state is BSNavigationConfirmingTrip))
              setState(() {
                if (_wasTrip) _tripModel = null;
                _locationMarkers.clear();
                _pointMarkers.clear();
                _wasTrip = false;
              });
            if (state is BSNavigationExplore) {
              setState(() {
                _locationMarkers?.clear();
                _pointMarkers?.clear();
              });
            } else if (state is BSNavigationSelectingLocation) {
              setState(() {
                _locationMarkers.clear();
                _pointMarkers.clear();
                _isShowingPOIs = true;
              });
            } else if (state is BSNavigationShowingLocation) {
              setState(() {
                _locationMarkers.clear();
              });
            } else if (state is BSNavigationPlanningPoints) {
              setState(() {
                _locationMarkers.clear();
                _pointMarkers.clear();
                _isShowingPOIs = true;
              });
              setState(() {
                bool roundtrip = state.origin != null &&
                    state.destination != null &&
                    state.origin.coordinates.latitude ==
                        state.destination.coordinates.latitude &&
                    state.origin.coordinates.longitude ==
                        state.destination.coordinates.longitude;
                if (state.origin != null && !roundtrip)
                  _pointMarkers.add(Marker(
                      height: 16,
                      width: 16,
                      point: state.origin.coordinates,
                      builder: (context) => markers.CircleMarker()));
                if (state.destination != null)
                  _pointMarkers.add(Marker(
                      height: 16,
                      width: 16,
                      point: state.destination.coordinates,
                      builder: (context) => markers.TripDestinationMarker()));
                if (state.origin != null && state.destination != null) {
                  _isShowingPOIs = false;
                  _animatedFitBounds(
                      LatLngBounds(state.origin.coordinates,
                          state.destination.coordinates),
                      options: FitBoundsOptions(
                        maxZoom: 16,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 32,
                            right: 32,
                            left: 32,
                            bottom:
                                (MediaQuery.of(context).size.height + 48) / 2 -
                                    MediaQuery.of(context).padding.top),
                      ));
                }
              });
            }
          },
        ),
      ],
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              minZoom: 11,
              zoom: 14,
              maxZoom: 16,
              center: _getInitialCenter(context),
              onPositionChanged: (_, __) => _onPositionChanged(),
              onTap: _onTap,
            ),
            layers: [
              TileLayerOptions(
                maxZoom: 16,
                minZoom: 11,
                tms: true,
                tileProvider: AssetTileProvider(),
                urlTemplate: "assets/map/{z}/{x}/{y}.png",
              ),
              PolylineLayerOptions(
                polylineCulling: true,
                polylines: _tripModel == null
                    ? []
                    : [
                        Polyline(
                            points: _tripModel.line,
                            color: const Color(0xFF75B1F9),
                            strokeWidth: 3.2)
                      ],
              ),
              if ((_locationMarkers +
                          _pointMarkers +
                          (_isShowingPOIs ? _pointsOfInterest : []))
                      .isNotEmpty ||
                  _tripModel != null)
                MarkerLayerOptions(
                  markers: _pointMarkers +
                      (_isShowingPOIs ? _pointsOfInterest : []) +
                      _locationMarkers +
                      (_userLocation != null ? [_userLocation] : []),
                )
            ],
          ),
          BlocBuilder<BSNavigationBloc, BSNavigationState>(
            builder: (context, state) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: state is BSNavigationSelectingLocation
                    ? MediaQuery.of(context).padding.top + 16
                    : MediaQuery.of(context).padding.top,
                child: AnimatedOpacity(
                  opacity: state is BSNavigationSelectingLocation ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 13.0,
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(6.0, 7.0),
                          ),
                        ]),
                    padding: EdgeInsets.all(10),
                    child: Text('Tap to select on map'),
                  ),
                ),
              );
            },
          ),
          BlocBuilder<BSNavigationBloc, BSNavigationState>(
            builder: (context, state) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: (state is BSNavigationConfirmingTrip && _showRecenter)
                    ? MediaQuery.of(context).padding.top + 16
                    : MediaQuery.of(context).padding.top,
                child: AnimatedOpacity(
                  opacity:
                      (state is BSNavigationConfirmingTrip && _showRecenter)
                          ? 1
                          : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 13.0,
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(6.0, 7.0),
                          ),
                        ]),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.navigation,
                            color: Colors.blue[800], size: 20),
                        const SizedBox(width: 8),
                        Text('Recalculate route',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _onPositionChanged() {
    if (_initialMove) {
      _initialMove = false;
    }
    // } else if (_showControls)
    //   setState(() {
    //     _isCenteringUser = false;
    //   });
  }

  _onTap(LatLng position) {
    BlocProvider.of<BSNavigationBloc>(context)
        .add(BSNavigationMapSelection(position));
  }

  LatLng _getInitialCenter(BuildContext context) {
    // if (_isCenteringUser) {
    //   return (BlocProvider.of<UserLocationBloc>(context).state as UserLocationLoaded)
    //       .location
    //       .coordinates;
    // } else
    return LatLng(38.704, -9.136);
  }

  void _showPOIs(bool show) {
    setState(() {
      _isShowingPOIs = show;
    });
  }

  Future<void> _animatedMapMove(LatLng destLocation, double destZoom) async {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    await controller.forward();
  }

  Future<void> _animatedFitBounds(LatLngBounds bounds,
      {FitBoundsOptions options}) async {
    // Create some tweens. These serve to split up the transition from one location to another.
    final _swLatTween = Tween<double>(
        begin: _mapController.bounds.southWest.latitude,
        end: bounds.southWest.latitude);
    final _swLngTween = Tween<double>(
        begin: _mapController.bounds.southWest.longitude,
        end: bounds.southWest.longitude);
    final _neLatTween = Tween<double>(
        begin: _mapController.bounds.northEast.latitude,
        end: bounds.northEast.latitude);
    final _neLngTween = Tween<double>(
        begin: _mapController.bounds.northEast.longitude,
        end: bounds.northEast.longitude);

    final _paddingTween =
        Tween<EdgeInsets>(begin: EdgeInsets.all(0), end: options.padding);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.fitBounds(
          LatLngBounds(
            LatLng(_swLatTween.evaluate(animation),
                _swLngTween.evaluate(animation)),
            LatLng(_neLatTween.evaluate(animation),
                _neLngTween.evaluate(animation)),
          ),
          options: FitBoundsOptions(
              padding: _paddingTween.evaluate(animation),
              maxZoom: options.maxZoom,
              zoom: options.zoom));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    await controller.forward();
  }

// BlocProvider.of<RouteBloc>(context).add(const ShowLocation());
//             BlocProvider.of<LocationBloc>(context)
//                 .add(LoadLocation(address: 'Avenida das forças armadas'));
}

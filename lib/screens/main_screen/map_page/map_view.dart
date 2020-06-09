import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/location/location_bloc.dart';
import '../../../bloc/route/route_bloc.dart';

class MapView extends StatefulWidget {
  const MapView();

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: MaterialButton(
          color: Colors.pinkAccent,
          onPressed: () {
            BlocProvider.of<RouteBloc>(context).add(const ShowLocation());
            BlocProvider.of<LocationBloc>(context)
                .add(LoadLocation.address('Avenida das forças armadas'));
          },
          child: Text('Rua Alexandre Ferreira'),
        ),
      ),
    );
  }
}

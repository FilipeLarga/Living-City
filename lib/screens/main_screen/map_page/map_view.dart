import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            BlocProvider.of<RouteBloc>(context).add(ShowLocation());
          },
          child: Text('Rua Alexandre Ferreira'),
        ),
      ),
    );
  }
}

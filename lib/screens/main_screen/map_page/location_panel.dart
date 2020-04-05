import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import '../../../bloc/route/route_bloc.dart';
import 'package:latlong/latlong.dart';

class LocationPanel extends StatefulWidget {
  const LocationPanel({
    Key key,
  }) : super(key: key);

  @override
  _LocationPanelState createState() => _LocationPanelState();
}

class _LocationPanelState extends State<LocationPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              Text('Rua Alexandre Ferreira'),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () => BlocProvider.of<RouteBloc>(context).add(
                      AcceptLocation(LocationModel('Ruasdijasd', LatLng(1, 1))),
                    ),
                    child: Text('Origin'),
                  ),
                  MaterialButton(
                    onPressed: () => BlocProvider.of<RouteBloc>(context).add(
                      const CancelLocation(),
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

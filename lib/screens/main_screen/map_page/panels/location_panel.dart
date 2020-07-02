import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/location/location_bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import 'package:latlong/latlong.dart';

class LocationPanel extends StatefulWidget {
  final String address;
  final LatLng coordinates;
  final LocationModel locationModel;

  const LocationPanel({
    Key key,
    this.address,
    this.coordinates,
    this.locationModel,
  }) : super(key: key);

  @override
  _LocationPanelState createState() => _LocationPanelState();
}

class _LocationPanelState extends State<LocationPanel> {
  @override
  void initState() {
    super.initState();
    // This warnings are just false-positives.
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final needsLoading = widget.locationModel == null;

    if (needsLoading && !(locationBloc.state is LocationLoading)) {
      locationBloc.add(LoadLocation(address: widget.address, coordinates: widget.coordinates));
    } else {
      locationBloc.add(ShowPreLoadedLocation(location: widget.locationModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationLoading || state is LocationInactive) {
          return Column(
            children: <Widget>[
              Text('loading'),
            ],
          );
        } else if (state is LocationError) {
          return Text('error');
        } else {
          final location = (state as LocationLoaded).location;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    Text(location.name + location.locality),
                    Wrap(
                      children: <Widget>[
                        Container(
                          child: Text('LocationPanel'),
                        ),
                        MaterialButton(
                          onPressed: () => BlocProvider.of<BSNavigationBloc>(context)
                              .add(BSNavigationCanceled()),
                          child: Text('Cancel'),
                        ),
                        MaterialButton(
                          onPressed: () => BlocProvider.of<BSNavigationBloc>(context)
                              .add(BSNavigationLocationAccepted(location, origin: true)),
                          child: Text('Accept Origin'),
                        ),
                        MaterialButton(
                          onPressed: () => BlocProvider.of<BSNavigationBloc>(context)
                              .add(BSNavigationLocationAccepted(location, origin: false)),
                          child: Text('Accept Destination'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

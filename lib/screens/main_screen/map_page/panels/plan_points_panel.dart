import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/bs_navigation/bs_navigation_bloc.dart';
import 'package:living_city/data/models/location_model.dart';

class PlanPointsPanel extends StatelessWidget {
  final LocationModel origin;
  final LocationModel destination;

  const PlanPointsPanel({Key key, @required this.origin, @required this.destination})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: <Widget>[
          Container(
            child: Text('PlanPointsPanel'),
          ),
          Container(
            child: Text(origin?.name ?? 'No origin'),
          ),
          Container(
            child: Text(destination?.name ?? 'No Destination'),
          ),
          MaterialButton(
            onPressed: () =>
                BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationPointSelected(true)),
            child: Text('Select Origin'),
          ),
          MaterialButton(
            onPressed: () =>
                BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationPointSelected(false)),
            child: Text('Select Destination'),
          ),
          MaterialButton(
            onPressed: () => BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationCanceled()),
            child: Text('Cancel'),
          ),
          MaterialButton(
            onPressed: (origin != null && destination != null)
                ? () => BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationAdvanced())
                : null,
            child: Text('Next'),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/bs_navigation/bs_navigation_bloc.dart';

class PlanInterestsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Wrap(
        children: <Widget>[
          Container(
            child: Text('PlanInterestsPanel'),
          ),
          MaterialButton(
            onPressed: () => BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationCanceled()),
            child: Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () => BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationAdvanced()),
            child: Text('Next'),
          )
        ],
      ),
    );
  }
}

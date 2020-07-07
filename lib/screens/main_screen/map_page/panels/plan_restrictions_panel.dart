import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/bs_navigation/bs_navigation_bloc.dart';

class PlanRestrictionsPanel extends StatelessWidget {
  final int date;
  final int effort;
  final int budget;

  const PlanRestrictionsPanel({Key key, this.date, this.effort, this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Container(
          child: Text('PlanRestrictionsPanel'),
        ),
        MaterialButton(
          onPressed: () =>
              BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationRestrictionAdded(date: 1)),
          child: Text('Add Date'),
        ),
        MaterialButton(
          onPressed: () => BlocProvider.of<BSNavigationBloc>(context)
              .add(BSNavigationRestrictionAdded(effort: 1)),
          child: Text('Add effort'),
        ),
        MaterialButton(
          onPressed: () => BlocProvider.of<BSNavigationBloc>(context)
              .add(BSNavigationRestrictionAdded(budget: 1)),
          child: Text('Add budget'),
        ),
        MaterialButton(
          onPressed: () => BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationCanceled()),
          child: Text('Cancel'),
        ),
        MaterialButton(
          onPressed: (date != null && effort != null && budget != null)
              ? () => BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationAdvanced())
              : null,
          child: Text('Next'),
        )
      ],
    );
  }
}

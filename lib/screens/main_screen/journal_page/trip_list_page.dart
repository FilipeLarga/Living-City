import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/trip_list/trip_list_bloc.dart';
import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/screens/main_screen/journal_page/trip_details_page.dart';

class TripListPage extends StatelessWidget {
  static const routeName = 'journal/trip_list';
  const TripListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: BlocBuilder<TripListBloc, TripListState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: Center(
              child: Column(
                children: <Widget>[
                  StatsDisplay(
                    sumCalories:
                        state is TripListLoaded ? state.sumCalories : 0,
                    sumDistance:
                        state is TripListLoaded ? state.sumDistance : 0,
                    sumPOIsVisited:
                        state is TripListLoaded ? state.sumPOIsVisited : 0,
                  ),
                  MaterialButton(
                      color: Colors.red,
                      child: Text('trip details'),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(TripDetailsPage.routeName,
                              arguments: TripModel(
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                                null,
                              ))),
                  state is TripListLoaded ? Text('LOADED !') : Text('LOADING'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatsDisplay extends StatelessWidget {
  final int sumCalories;
  final int sumPOIsVisited;
  final int sumDistance;

  const StatsDisplay(
      {Key key,
      this.sumCalories = 0,
      this.sumPOIsVisited = 0,
      this.sumDistance = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        StatsItem(
          value: sumPOIsVisited,
          name: 'POIs visited',
        ),
        StatsItem(
          value: sumDistance,
          name: 'Distance',
        ),
        StatsItem(
          value: sumCalories,
          name: 'Calories',
        ),
      ],
    );
  }
}

class StatsItem extends StatelessWidget {
  final int value;
  final String name;

  const StatsItem({Key key, @required this.value, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$value',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text('$name'),
      ],
    );
  }
}

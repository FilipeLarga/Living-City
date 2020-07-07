import 'package:flutter/material.dart';
import '../../../widgets/map_widgets.dart';
import '../../../bloc/trip_details/trip_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripDetailsPage extends StatelessWidget {
  static const routeName = 'journal/trip_details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
              builder: (context, state) {
                return LineMap(
                  line: state.trip.line,
                );
              },
            ),
          ),
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Container(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}

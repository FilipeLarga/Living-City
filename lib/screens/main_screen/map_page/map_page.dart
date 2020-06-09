import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/location/location_bloc.dart';
import 'package:living_city/dependency_injection/injection_container.dart';
import '../../../bloc/route/route_bloc.dart';
import '../../../bloc/bottom_sheet/bottom_sheet_bloc.dart';
import '../../../bloc/search_history/search_history_bloc.dart';

import './map_bottom_sheet.dart';
import './map_view.dart';
import './map_controls.dart';

class MapPage extends StatelessWidget {
  const MapPage();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RouteBloc>(
          create: (BuildContext context) => RouteBloc(sl()),
        ),
        BlocProvider<BottomSheetBloc>(
          create: (BuildContext context) => BottomSheetBloc(),
        ),
        BlocProvider<SearchHistoryBloc>(
          create: (BuildContext context) => SearchHistoryBloc(sl()),
        ),
        BlocProvider<LocationBloc>(
          create: (BuildContext context) => LocationBloc(sl()),
        ),
      ],
      child: Stack(
        children: <Widget>[
          const MapView(),
          const Positioned(
            top: 40,
            right: 8,
            child: const MapControls(
              onCenterLocationPress: _testFunction,
              onShowPOIsPress: _testFunction,
            ),
          ),
          const MapBottomSheet(),
        ],
      ),
    );
  }
}

void _testFunction() {
  print('click');
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/route_request/route_request_bloc.dart';

import './map_bottom_sheet.dart';
import './map_view.dart';
import '../../../bloc/bottom_sheet/bottom_sheet_bloc.dart';
import '../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../bloc/location/location_bloc.dart';
import '../../../bloc/search_history/search_history_bloc.dart';
import '../../../dependency_injection/injection_container.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatelessWidget {
  const MapPage();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BSNavigationBloc>(
            create: (BuildContext context) => BSNavigationBloc(sl(), sl())
              ..add(BSNavigationLoadActiveTrip())),
        BlocProvider<BottomSheetBloc>(
            create: (BuildContext context) => BottomSheetBloc()),
        BlocProvider<SearchHistoryBloc>(
            create: (BuildContext context) => SearchHistoryBloc(sl())),
        BlocProvider<LocationBloc>(
            create: (BuildContext context) => LocationBloc(sl(), sl())),
        BlocProvider<RouteRequestBloc>(
            create: (BuildContext context) => RouteRequestBloc(http.Client()))
      ],
      child: Stack(
        children: <Widget>[
          const MapView(),
          const MapBottomSheet(),
        ],
      ),
    );
  }
}

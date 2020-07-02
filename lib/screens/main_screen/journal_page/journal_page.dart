import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/search_history/search_history_bloc.dart';
import 'package:living_city/bloc/trip_list/trip_list_bloc.dart';
import 'package:living_city/dependency_injection/injection_container.dart';
import 'package:living_city/screens/main_screen/journal_page/trip_list_page.dart';

class JournalPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState navigator = navigatorKey.currentState;
        if (!navigator.canPop()) return true;
        navigator.pop();
        return false;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: TripListPage.routeName,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case TripListPage.routeName:
              builder = (_) => BlocProvider(
                    create: (context) =>
                        TripListBloc(sl())..add(TripListLoad()),
                    child: const TripListPage(),
                  );
              break;
            //  This route is now unnecessary since the navigation is done through the OpenContainer animation that pushes the route automatically
            // case TripDetailsPage.routeName:
            //   builder = (BuildContext _) => BlocProvider<TripDetailsBloc>(
            //         create: (BuildContext context) =>
            //             TripDetailsBloc(settings.arguments),
            //         child: TripDetailsPage(),
            //       );
            //   break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}

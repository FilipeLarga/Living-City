import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:living_city/bloc/route_selection_bloc/bloc.dart';
import 'package:living_city/screens/user_profile.dart';
import 'package:living_city/widgets/SearchLocationOverlay.dart';
import './data/repositories/geolocator_repository.dart';
import './data/provider/geocoding_provider.dart';
import './bloc/search_location_bloc/bloc.dart';
import './data/provider/search_location_provider.dart';
import './data/repositories/search_location_repository.dart';
import './widgets/MapView.dart';
import 'bloc/bloc_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LivingCityApp());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color(0xFF5863AF),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        fontFamily: 'OpenSans',
      ),
      routes: {
        '/': (context) => MainPage(),
        //'/other': (context) => OtherScreen(),
      },
    );
  }
}

class LivingCityApp extends StatefulWidget {
  @override
  _LivingCityAppState createState() => _LivingCityAppState();
}

class _LivingCityAppState extends State<LivingCityApp> {
  final GeolocatorRepository _geolocatorRepository =
      GeolocatorRepository(GeolocatorProvider());
  final SearchLocationRepository _searchLocationRepository =
      SearchLocationRepository(SearchLocationProvider());

  SearchLocationBloc _searchLocationBloc;
  RouteSelectionBloc _routeSelectionBloc;

  @override
  void initState() {
    super.initState();
    _searchLocationBloc = SearchLocationBloc(
        geocodingRepository: _geolocatorRepository,
        searchHistoryRepository: _searchLocationRepository);

    _routeSelectionBloc = RouteSelectionBloc(
        searchHistoryRepository: _searchLocationRepository,
        searchLocationBloc: _searchLocationBloc,
        geolocatorRepository: _geolocatorRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchLocationBloc>(
          create: (context) {
            return _searchLocationBloc..add(LoadHistoryRequestEvent());
          },
        ),
        BlocProvider<RouteSelectionBloc>(
          create: (context) {
            return _routeSelectionBloc;
          },
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          accentColor: Color(0xFF5863AF),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xFFFFFFFF),
          fontFamily: 'OpenSans',
        ),
        home: MainPage(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchLocationBloc.close();
    _routeSelectionBloc.close();
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _bottomNavBarIndex = 0;

  //ExpandingBottomSheetController _expandingBottomSheetController;

  @override
  void initState() {
    super.initState();
    //_expandingBottomSheetController = ExpandingBottomSheetController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //make keyboard not scroll the map
      key: _scaffoldKey,
      body: _bottomNavBarIndex == 0
          ? LayoutBuilder(builder: (context, constraints) {
              return Stack(
                overflow: Overflow.visible, //makes sheet shadow not clip
                children: [
                  //MAP
                  Container(
                    height: constraints.maxHeight,
                    child: MapView(),
                  ),
                  //SEARCH OVERLAY
                  SearchLocationOverlay(),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: ExpandingBottomSheet(
                  //     controller: _expandingBottomSheetController,
                  //     maxCornerRadius: 18,
                  //     maxHeight: 500,
                  //     child: PreferencesSheet(),
                  //   ),
                  // ),
                  // Padding(
                  //   //fab
                  //   padding: EdgeInsets.all(16),
                  //   child: Align(
                  //     alignment: Alignment.topRight,
                  //     child: Column(
                  //       children: <Widget>[
                  //         FloatingActionButton(
                  //           onPressed: () => _expandingBottomSheetController
                  //               .animateToMaxThreshold(), //_animatedMapMove(lisbon, 16),
                  //           child: Icon(Icons.center_focus_strong),
                  //         ),
                  //         FloatingActionButton(
                  //           onPressed: () => _animatedMapMove(lisbon, 15),
                  //           child: Icon(Icons.center_focus_strong),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              );
            })
          : UserProfile(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: const Icon(Icons.gesture),
            title: const Text('Travel'),
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            title: const Text('Journal'),
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            title: const Text("'Profile"),
          )
        ],
        backgroundColor: Colors.white,
        currentIndex: _bottomNavBarIndex,
        onTap: _bottomNavBarOnItemTapped,
        elevation: 24.0,
      ),
    );
  }

  void _bottomNavBarOnItemTapped(int index) {
    setState(() {
      _bottomNavBarIndex = index;
    });
  }
}

/*DraggableScrollableSheet(
              maxChildSize: 1,
              minChildSize: (constraints.maxHeight / 5) / constraints.maxHeight,
              initialChildSize:
                  (constraints.maxHeight / 5) / constraints.maxHeight,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  height: constraints.maxHeight,
                  child: SingleChildScrollView(
                    //physics: ClampingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        Text("1"),
                        Text("2"),
                      ],
                    ),
                  ),
                );
              },
            ),*/

/*DraggableScrollableSheet(
              maxChildSize: 1,
              minChildSize: (constraints.maxHeight / 5) / constraints.maxHeight,
              initialChildSize:
                  (constraints.maxHeight / 5) / constraints.maxHeight,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            offset: const Offset(0.0, 7.0),
                            blurRadius: 8.0,
                            spreadRadius: -4.0,
                            color: const Color(0x33000000)),
                        BoxShadow(
                            offset: const Offset(0.0, 12.0),
                            blurRadius: 17.0,
                            spreadRadius: 2.0,
                            color: const Color(0x24000000)),
                        BoxShadow(
                            offset: const Offset(0.0, 5.0),
                            blurRadius: 22.0,
                            spreadRadius: 4.0,
                            color: const Color(0x1F000000)),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  height: constraints.maxHeight,
                  child: CustomScrollView(
                    //physics: ClampingScrollPhysics(),
                    controller: scrollController,

                    slivers: <Widget>[
                      
                    ],
                  ),
                );
              },
            ),*/

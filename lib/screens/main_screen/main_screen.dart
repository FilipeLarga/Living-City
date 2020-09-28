import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/location/location_bloc.dart';
import 'package:living_city/bloc/points_of_interest/points_of_interest_bloc.dart';
import 'package:living_city/bloc/user_location/user_location_bloc.dart';
import 'package:living_city/dependency_injection/injection_container.dart';
import 'journal_page/journal_page.dart';
import 'map_page/map_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex;

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController.addListener(() {
      if (_pageController.page.round() != _pageIndex) {
        setState(() {
          _pageIndex = _pageController.page.round();
        });
      }
    });
  }

  void _showPage(int index) {
    if (index != _pageIndex) {
      setState(() {
        _pageIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _showPage,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_walk),
            title: const Text('Travel'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            title: const Text('History'),
          )
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LocationBloc(sl(), sl()),
          ),
          BlocProvider(
            create: (context) =>
                PointsOfInterestBloc(sl())..add(PointsOfInterestFetch()),
          ),
          BlocProvider(
            create: (context) => UserLocationBloc(sl()),
          ),
        ],
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [const MapPage(), JournalPage()],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

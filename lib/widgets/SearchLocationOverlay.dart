import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/route_selection_bloc/bloc.dart';
import 'package:living_city/widgets/RouteSelectorBar.dart';
import 'package:living_city/widgets/SearchBar.dart';
import 'package:living_city/widgets/SearchLocationSheet.dart';
import '../bloc/search_location_bloc/bloc.dart';

class SearchLocationOverlay extends StatefulWidget {
  @override
  _SearchLocationOverlayState createState() => _SearchLocationOverlayState();
}

class _SearchLocationOverlayState extends State<SearchLocationOverlay>
    with TickerProviderStateMixin {
  AnimationController _searchBarAnimationController;
  AnimationController _locationSheetAnimationController;
  bool _showFirst;

  @override
  void initState() {
    super.initState();
    _showFirst = true;
    _searchBarAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1,
    );
    _locationSheetAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // _searchBarAnimationController.addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed &&
    //       _locationSheetAnimationController.status ==
    //           AnimationStatus.dismissed) {
    //     BlocProvider.of<SearchLocationBloc>(context)
    //         .add(GoInactiveRequestEvent());
    //   }
    // });

    //   _locationSheetAnimationController.addStatusListener((status) {
    //     if (status == AnimationStatus.dismissed &&
    //         _searchBarAnimationController.status == AnimationStatus.dismissed) {
    //       BlocProvider.of<SearchLocationBloc>(context)
    //           .add(GoInactiveRequestEvent());
    //     }
    //   });
    // }

    _locationSheetAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        BlocProvider.of<SearchLocationBloc>(context).add(DismissedEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarAnimationController.dispose();
    _locationSheetAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SearchLocationBloc, SearchLocationState>(
            listener: (context, state) {
              _searchLocationListener(context, state);
            },
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 12, bottom: 6),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(8)),
                      color: Colors.white,
                      boxShadow: const <BoxShadow>[
                        const BoxShadow(
                            offset: const Offset(0.0, 3.0),
                            blurRadius: 1.0,
                            spreadRadius: -2.0,
                            color: const Color(0x33000000)),
                        const BoxShadow(
                            offset: const Offset(0.0, 2.0),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            color: const Color(0x24000000)),
                        const BoxShadow(
                            offset: const Offset(0.0, 1.0),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                            color: const Color(0x1F000000)),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedCrossFade(
                        crossFadeState: _showFirst
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 300),
                        firstChild: BlocBuilder<SearchLocationBloc,
                            SearchLocationState>(
                          condition: (prevState, currentState) {
                            return !(currentState is ErrorSearchState ||
                                currentState is FinishSearchState);
                          },
                          builder: (context, state) {
                            if (state is UnitializedSearchState)
                              return SearchBar(
                                animationController:
                                    _searchBarAnimationController,
                              );
                            else if (state is InitialSearchState) {
                              return SearchBar(
                                animationController:
                                    _searchBarAnimationController,
                                searchHistoryList: state.searchHistory,
                              );
                            } else if (state is ShowingLocationSearchState) {
                              return SearchBar(
                                animationController:
                                    _searchBarAnimationController,
                                searchLocation: state.searchLocation,
                              );
                            } else if (state is InactiveSearchState) {
                              return Container();
                            } else {
                              //It should never come to this
                              print(
                                  'You Should never see this!! in SearchLocationOverylay');
                              return Container();
                            }
                          },
                        ),
                        secondChild: BlocBuilder<RouteSelectionBloc,
                            RouteSelectionState>(
                          builder: (context, state) {
                            if (state is UnitializedRouteState) {
                              return Container();
                            } else if (state is SelectingRouteState) {
                              return RouteSearchSelector(
                                loop: state.loop,
                                startLocation: state.startLocation,
                                endLocation: state.destinationLocation,
                              );
                            } else {
                              print(
                                  'You Should never see this!! in SearchLocationOverylay');
                              return Container(
                                child: Text('you done goofed'),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<SearchLocationBloc, SearchLocationState>(
                condition: (prevState, currentState) {
                  return !(currentState is ErrorSearchState ||
                      currentState is FinishSearchState);
                },
                builder: (context, state) {
                  if (state is InactiveSearchState) {
                    return Container();
                  } else if (state is ShowingLocationSearchState) {
                    return SearchLocationSheet(
                      animationController: _locationSheetAnimationController,
                      searchLocation: state.searchLocation,
                    );
                  } else {
                    return SearchLocationSheet(
                      animationController: _locationSheetAnimationController,
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }

  void _searchLocationListener(
      BuildContext context, SearchLocationState state) {
    if (state is UnitializedSearchState) {
      _searchBarAnimationController.forward();
    } else if (state is InitialSearchState) {
      _searchBarAnimationController.forward();
      _locationSheetAnimationController.reverse();
    } else if (state is ShowingLocationSearchState) {
      _searchBarAnimationController.forward();
      _locationSheetAnimationController.forward();
    } else if (state is FinishSearchState) {
      _searchBarAnimationController.forward();
      _locationSheetAnimationController.reverse();
    } else {
      setState(() {
        _showFirst = false;
      });
    }
  }
}

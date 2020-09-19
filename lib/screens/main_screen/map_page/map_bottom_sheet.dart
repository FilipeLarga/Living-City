import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/core/shared_axis_page_route.dart';
import 'package:living_city/screens/main_screen/map_page/panels/active_trip_panel.dart';
import 'package:living_city/screens/main_screen/map_page/panels/plan_interests_panel.dart';
import 'package:living_city/screens/main_screen/map_page/panels/plan_points_panel.dart';
import 'package:living_city/screens/main_screen/map_page/panels/plan_restrictions_panel.dart';
import 'package:living_city/screens/main_screen/map_page/panels/trip_confirmation_panel.dart';
import '../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../bloc/bottom_sheet/bottom_sheet_bloc.dart';
import 'panels/location_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'panels/search_panel.dart';

class MapBottomSheet extends StatefulWidget {
  const MapBottomSheet();

  @override
  _MapBottomSheetState createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  final PanelController _panelController = PanelController();
  bool _draggable;
  bool _backdrop;

  bool _wasRestrictions; //Bug fix for keyboard issue on restrictions panel
  // double _panelHeightFactor;

  Widget _panelWidget;

  ScrollController _scrollController;

  double heightLimit;
  double _minHeight;

  @override
  void initState() {
    super.initState();
    /*_draggable = true;
    _backdrop = true;
    _wasRestrictions = false;*/
    _draggable = false;
    _backdrop = false;
    _wasRestrictions = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _panelController.animatePanelToPosition((308.0 / heightLimit).toDouble(),
          duration: Duration(milliseconds: 300), curve: Curves.easeInCubic);
    });
    _minHeight = 88;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BSNavigationBloc, BSNavigationState>(
          listener: (context, state) {
            if (state is BSNavigationActiveTrip) {
              setState(() {
                _panelWidget = ActiveTripPanel();
              });
            } else if (state is BSNavigationExplore) {
              setState(() {
                _panelWidget = SearchPanel(
                    scrollController: _scrollController,
                    openSheet: _openSheet,
                    closeSheet: _closeSheet);
                _panelController
                    .animatePanelToPosition(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInCubic)
                    .then((value) {
                  setState(() {
                    _backdrop = true;
                    _draggable = true;
                  });
                });
              });
            } else if (state is BSNavigationSelectingLocation) {
              setState(() {
                _panelWidget = SearchPanel(
                    scrollController: _scrollController,
                    openSheet: _openSheet,
                    closeSheet: _closeSheet);
                _panelController
                    .animatePanelToPosition(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInCubic)
                    .then((value) {
                  setState(() {
                    _backdrop = true;
                    _draggable = true;
                  });
                });
              });
            } else if (state is BSNavigationShowingLocation) {
              setState(() {
                _draggable = false;
                _backdrop = false;
                _panelController.animatePanelToPosition(
                    (90.0 / heightLimit).toDouble(),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInCubic);
              });
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  _panelWidget = LocationPanel(
                      key: ValueKey(state.address ??
                          state.coordinates ??
                          state.locationModel),
                      address: state.address,
                      coordinates: state.coordinates,
                      locationModel: state.locationModel);
                });
              });
            } else if (state is BSNavigationPlanningPoints) {
              setState(() {
                _draggable = false;
                _backdrop = false;
                _panelController.animatePanelToPosition(
                    (302.0 / heightLimit).toDouble(),
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInCubic);
              });
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  _panelWidget = PlanPointsPanel(
                      origin: state.origin,
                      destination: state.destination,
                      date: state.date);
                });
              });
            } else if (state is BSNavigationPlanningRestrictions) {
              setState(() {
                _draggable = false;
                _backdrop = false;
                _panelWidget = PlanRestrictionsPanel(
                  budget: state.budget,
                  visitTime: state.visitTime,
                  minVisitTime: state.minVisitTime,
                  effort: state.effort,
                  minBudget: state.minBudget,
                  departureDate: state.departureDate,
                );
                if (!_wasRestrictions)
                  _panelController.animatePanelToPosition(
                      (352.0 / heightLimit).toDouble(),
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInCubic);
              });
            } else if (state is BSNavigationPlanningInterests) {
              setState(() {
                _panelWidget = PlanInterestsPanel(
                  activeCategories: List.from(state.categories),
                  activePOIs: List.from(state.pois),
                  date: state.departureHour,
                  origin: state.origin,
                );
                _panelController.animatePanelToPosition(
                    (564 / heightLimit).toDouble(),
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInCubic);
              });
            } else if (state is BSNavigationConfirmingTrip) {
              setState(() {
                _panelWidget = TripConfirmationPanel(
                    tripPlanModel: state.tripPlanModel,
                    scrollController: _scrollController,
                    heightLimit: heightLimit);
                _panelController
                    .animatePanelToPosition(1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInCubic)
                    .then((value) {
                  setState(() {
                    _minHeight = 64;
                    _backdrop = true;
                    _draggable = true;
                  });
                });
              });
            }
            _wasRestrictions = state is BSNavigationPlanningRestrictions;
          },
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          heightLimit =
              constraints.maxHeight - MediaQuery.of(context).padding.top - 16;
          return SlidingUpPanel(
            maxHeight: heightLimit /** _panelHeightFactor*/,
            minHeight: _minHeight,
            color: Colors.white,
            backdropEnabled: _backdrop,
            backdropTapClosesPanel: _backdrop,
            isDraggable: _draggable,
            controller: _panelController,
            padding: EdgeInsets.only(left: 16, right: 16, top: 12),
            borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10)),
            panelBuilder: (ScrollController sc) {
              _scrollController = sc;

              return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    ),
                  ),
                  child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 300),
                      // duration: Duration(seconds: 3),
                      // layoutBuilder: (_activeEntries) {
                      //   return Stack(
                      //     children: _activeEntries
                      //         .map<Widget>((ChildEntry entry) => entry.transition)
                      //         .toList(),
                      //     alignment: Alignment.topCenter,
                      //   );
                      // },
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                          transitionType: SharedAxisTransitionType.vertical,
                        );
                      },
                      child: _panelWidget ??
                          (BlocProvider.of<BSNavigationBloc>(context).state
                                  is BSNavigationActiveTrip
                              ? ActiveTripPanel()
                              : _panelWidget = PlanPointsPanel(
                                  origin: null,
                                  destination: null,
                                  date:
                                      null) /*SearchPanel(
                                  scrollController: _scrollController,
                                  openSheet: _openSheet,
                                  closeSheet: _closeSheet)*/
                          )));
            },
            onPanelClosed: _onPanelClosed,
            onPanelOpened: _onPanelOpened,
            onPanelSlide: _onPanelSlide,
          );
        },
      ),
    );
  }

  // Widget _getPanelWidget(BSNavigationState state) {
  //   if (state is BSNavigationInitial) {
  //     return SearchPanel(
  //       key: ValueKey<int>(1),
  //       openSheet: _openSheet,
  //       closeSheet: _closeSheet,
  //       scrollController: _scrollController,
  //     );
  //   } else if (state is BSNavigationShowingLocation) {
  //     return LocationPanel(
  //       key: ValueKey<int>(2),
  //     );
  //   } else
  //     return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
  //       Align(
  //         alignment: Alignment.topCenter,
  //         child: Container(
  //           height: 200,
  //           color: Colors.orange,
  //         ),
  //       ),
  //     ]);
  // }

  void _openSheet() {
    _panelController.open();
  }

  void _closeSheet() {
    _panelController.close();
  }

  void _onPanelClosed() {
    BlocProvider.of<BottomSheetBloc>(context).add(const SheetClosure());
  }

  void _onPanelOpened() {
    BlocProvider.of<BottomSheetBloc>(context).add(const SheetOpened());
  }

  void _onPanelSlide(double factor) {
    if (factor != 1 && factor != 0)
      BlocProvider.of<BottomSheetBloc>(context).add(SheetMoved(factor: factor));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

// PageTransitionSwitcher(
//                   transitionBuilder: (
//                     Widget child,
//                     Animation<double> animation,
//                     Animation<double> secondaryAnimation,
//                   ) {
//                     return FadeThroughTransition(
//                       animation: animation,
//                       secondaryAnimation: secondaryAnimation,
//                       child: child,
//                     );
//                   },
//                   child: _panelWidget ??
//                       SearchPanel(
//                         key: ValueKey<int>(1),
//                         openSheet: _openSheet,
//                         closeSheet: _closeSheet,
//                         scrollController: _scrollController,
//                       ),
//                 ),

// if (state is RouteLocation) {
//               setState(() {
//                 _backdrop = false;
//                 _draggable = false;
//                 _panelController.animatePanelToPosition(200 / _panelMaxHeight,
//                     duration: Duration(milliseconds: 250),
//                     curve: Curves.easeOut);
//               });
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 setState(() => _panelWidget = _getPanelWidget(state));
//               });
//             } else {
//               setState(() {
//                 _panelWidget = _getPanelWidget(state);
//                 _panelController
//                     .animatePanelToPosition(0,
//                         duration: Duration(milliseconds: 250),
//                         curve: Curves.easeInOutCubic)
//                     .then((_) {
//                   _draggable = true;
//                   _backdrop = true;
//                 });
//               });

}

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/route/route_bloc.dart';
import '../../../bloc/bottom_sheet/bottom_sheet_bloc.dart';
import '../../../bloc/search_history/search_history_bloc.dart';
import './location_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import './search_panel.dart';

class MapBottomSheet extends StatefulWidget {
  const MapBottomSheet();

  @override
  _MapBottomSheetState createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  final PanelController _panelController = PanelController();
  bool _draggable;
  bool _backdrop;
  double _panelMaxHeight;

  Widget _panelWidget;

  ScrollController _scrollController;

  @override
  void initState() {
    _draggable = true;
    _backdrop = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RouteBloc, RouteState>(
      listener: (context, state) {
        if (state is RouteLocation) {
          setState(() {
            _backdrop = false;
            _draggable = false;
            _panelController.animatePanelToPosition(200 / _panelMaxHeight,
                duration: Duration(milliseconds: 250), curve: Curves.easeOut);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _panelWidget = _getPanelWidget(state));
          });
        } else {
          setState(() {
            _panelWidget = _getPanelWidget(state);
            _panelController
                .animatePanelToPosition(0,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic)
                .then((_) {
              _draggable = true;
              _backdrop = true;
            });
          });
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          _panelMaxHeight = constraints.maxHeight - 40;
          return SlidingUpPanel(
            maxHeight: _panelMaxHeight,
            minHeight: 150,
            backdropEnabled: _backdrop,
            backdropTapClosesPanel: _backdrop,
            isDraggable: _draggable,
            controller: _panelController,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(8),
                topRight: const Radius.circular(8)),
            panelBuilder: (ScrollController sc) {
              _scrollController = sc;
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8),
                    topRight: const Radius.circular(8),
                  ),
                ),
                child: PageTransitionSwitcher(
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    );
                  },
                  child: _panelWidget ??
                      SearchPanel(
                        openSheet: _openSheet,
                        closeSheet: _closeSheet,
                        scrollController: _scrollController,
                      ),
                ),
              );
            },
            onPanelClosed: _onPanelClosed,
            onPanelOpened: _onPanelOpened,
            onPanelSlide: _onPanelSlide,
          );
        },
      ),
    );
  }

  Widget _getPanelWidget(RouteState state) {
    if (state is RouteSearch) {
      return SearchPanel(
        openSheet: _openSheet,
        closeSheet: _closeSheet,
        scrollController: _scrollController,
      );
    } else if (state is RouteLocation) {
      return LocationPanel();
    } else
      return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 200,
            color: Colors.orange,
          ),
        ),
      ]);
  }

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
}

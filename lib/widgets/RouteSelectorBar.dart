import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/route_selection_bloc/bloc.dart';
import 'package:living_city/data/models/search_location_model.dart';

class RouteSearchSelector extends StatefulWidget {
  final SearchLocationModel startLocation;
  final SearchLocationModel endLocation;
  final List<SearchLocationModel> searchHistoryList;

  const RouteSearchSelector(
      {Key key,
      @required this.searchHistoryList,
      @required this.startLocation,
      @required this.endLocation})
      : super(key: key);

  @override
  _RouteSearchSelectorState createState() => _RouteSearchSelectorState();
}

class _RouteSearchSelectorState extends State<RouteSearchSelector> {
  final TextEditingController _startTextFieldController =
      TextEditingController();
  final TextEditingController _destinationTextFieldController =
      TextEditingController();

  bool _shouldExpand;
  bool _firstTextfieldSelected;

  @override
  void initState() {
    super.initState();
    _shouldExpand = false;
    _updateTextFields();
  }

  @override
  void didUpdateWidget(RouteSearchSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTextFields();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onTap: () {
                        setState(() {
                          _onEditDestinationTextfield();
                          _shouldExpand = true;
                          _firstTextfieldSelected = true;
                        });
                      },
                      onEditingComplete: _onEditStartTextfield,
                      controller: _startTextFieldController,
                      autofocus: false,
                      textCapitalization: TextCapitalization.words,
                      autocorrect: false,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Origin',
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding:
                            EdgeInsets.only(top: 8, left: 12, right: 12),
                      ),
                    ),
                    // Container(
                    //   color: Colors.red,
                    //   height: 50,
                    // ),
                    Divider(thickness: 1, height: 16, indent: 8, endIndent: 8),
                    TextField(
                      onTap: () {
                        setState(() {
                          _onEditStartTextfield();
                          _shouldExpand = true;
                          _firstTextfieldSelected = false;
                        });
                      },
                      onEditingComplete: _onEditDestinationTextfield,
                      controller: _destinationTextFieldController,
                      autofocus: false,
                      textCapitalization: TextCapitalization.words,
                      autocorrect: false,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Destination',
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.only(left: 12, right: 12),
                      ),
                    ),
                    // Container(
                    //   color: Colors.blue,
                    //   height: 50,
                    // ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: _onSwapTap,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey[100]),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Icon(Icons.swap_vert,
                            color: Theme.of(context).accentColor))
                  ],
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _chooseWidget(),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: const Interval(1, 1, curve: Curves.linear),
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Stack(
                      children: <Widget>[
                        ...previousChildren,
                      ],
                    ),
                  ),
                  if (currentChild != null) currentChild,
                ],
                alignment: Alignment.center,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSelect(SearchLocationModel selected) {
    setState(() {
      _shouldExpand = false;
      FocusScope.of(context).unfocus();
    });
    if (_firstTextfieldSelected) {
      _startTextFieldController.text = selected.title;
      _onEditStartTextfield();
    } else {
      _destinationTextFieldController.text = selected.title;
      _onEditDestinationTextfield();
    }
  }

  void _onCancel() {
    _onEditStartTextfield();
    _onEditDestinationTextfield();
    setState(() {
      _shouldExpand = false;
      FocusScope.of(context).unfocus();
    });
  }

  void _onLoop() {
    _onEditStartTextfield();
    _onEditDestinationTextfield();
    setState(() {
      _shouldExpand = false;
      FocusScope.of(context).unfocus();
      BlocProvider.of<RouteSelectionBloc>(context)
          .add(LoopRouteRequest(origin: _firstTextfieldSelected));
    });
  }

  void _onSelectOnMap() {
    BlocProvider.of<RouteSelectionBloc>(context)
        .add(SelectOnMapRequest(origin: _firstTextfieldSelected));
  }

  Widget _chooseWidget() {
    if (_shouldExpand)
      return ExpandedList(
          firstTextFieldFocused: _firstTextfieldSelected,
          callback: _onSelect,
          list: widget.searchHistoryList,
          cancelCallback: _onCancel,
          loopCallback: _onLoop,
          selectOnMapCallback: _onSelectOnMap);
    else
      return Container();
  }

  void _updateTextFields() {
    _startTextFieldController.text = widget.startLocation?.title ?? '';
    _destinationTextFieldController.text = widget.endLocation?.title ?? '';
  }

  void _onSwapTap() {
    _onEditStartTextfield();
    _onEditDestinationTextfield();
    BlocProvider.of<RouteSelectionBloc>(context).add(SwapRouteRequest());
  }

  void _onEditStartTextfield() {
    if (_startTextFieldController.text.isNotEmpty &&
        (widget.startLocation == null ||
            _startTextFieldController.text != widget.startLocation.title))
      BlocProvider.of<RouteSelectionBloc>(context).add(NewStartLocation(
          startLocation:
              SearchLocationModel(title: _startTextFieldController.text)));
    if (_startTextFieldController.text.isEmpty) {
      BlocProvider.of<RouteSelectionBloc>(context)
          .add(ClearRouteRequest(origin: true));
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _shouldExpand = false;
    });
  }

  void _onEditDestinationTextfield() {
    if (_destinationTextFieldController.text.isNotEmpty &&
        (widget.endLocation == null ||
            _destinationTextFieldController.text != widget.endLocation.title))
      BlocProvider.of<RouteSelectionBloc>(context).add(NewEndLocation(
          endLocation: SearchLocationModel(
              title: _destinationTextFieldController.text)));
    if (_destinationTextFieldController.text.isEmpty) {
      BlocProvider.of<RouteSelectionBloc>(context)
          .add(ClearRouteRequest(origin: false));
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _shouldExpand = false;
    });
  }
}

class LoopItem extends StatelessWidget {
  final Function() loopCallback;

  const LoopItem({Key key, @required this.loopCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loopCallback,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[100]),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child:
                        Icon(Icons.loop, color: Theme.of(context).accentColor))
              ],
            ),
            SizedBox(
              width: 22,
            ),
            Text(
              'Loop',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandedList extends StatelessWidget {
  final bool firstTextFieldFocused;
  final Function(SearchLocationModel) callback;
  final List<SearchLocationModel> list;
  final Function() cancelCallback;
  final Function() loopCallback;
  final Function() selectOnMapCallback;

  const ExpandedList(
      {Key key,
      @required this.firstTextFieldFocused,
      @required this.cancelCallback,
      @required this.callback,
      @required this.list,
      @required this.loopCallback,
      @required this.selectOnMapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Expanded(
        //       child: Divider(
        //         thickness: 1,
        //         endIndent: 8,
        //       ),
        //     ),
        //     GestureDetector(
        //       onTap: cancelCallback,
        //       child: Stack(
        //         children: <Widget>[
        //           Container(
        //             height: 32,
        //             width: 32,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle, color: Colors.grey[100]),
        //           ),
        //           Positioned(
        //               top: 0,
        //               bottom: 0,
        //               left: 0,
        //               right: 0,
        //               child: Icon(Icons.close,
        //                   size: 20, color: Theme.of(context).accentColor))
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Divider(
        //         thickness: 1,
        //         indent: 8,
        //       ),
        //     ),
        //   ],
        // ),
        // Text(firstTextFieldFocused ? 'SET ORIGIN' : 'SET DESTINATION',
        //     style: TextStyle(
        //         fontSize: 12,
        //         color: Theme.of(context).accentColor,
        //         fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(firstTextFieldFocused ? 'SET ORIGIN' : 'SET DESTINATION',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: cancelCallback,
              child: Text('Close',
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).accentColor)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LoopItem(loopCallback: loopCallback),
        const SizedBox(height: 4),
        CurrentLocationItem(),
        const SizedBox(height: 4),
        ChooseOnMapItem(selectOnMapCallback: selectOnMapCallback),
        const SizedBox(height: 8),
        Text('RECENT SEARCHES',
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.separated(
          padding: EdgeInsets.only(bottom: 6),
          shrinkWrap: true,
          itemCount: list.length > 2 ? 2 : list.length,
          separatorBuilder: (ctx, index) => const SizedBox(height: 4),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) => SearchHistoryListItem(
            historySelectedCallback: callback,
            searchLocation: list.elementAt(index),
          ),
        ),
      ],
    );
  }
}

class SearchHistoryListItem extends StatelessWidget {
  final Function(SearchLocationModel) historySelectedCallback;
  final SearchLocationModel searchLocation;

  const SearchHistoryListItem(
      {Key key,
      @required this.historySelectedCallback,
      @required this.searchLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => historySelectedCallback(searchLocation),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[100]),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Icon(Icons.history,
                        color: Theme.of(context).accentColor))
              ],
            ),
            SizedBox(
              width: 22,
            ),
            Text(
              '${searchLocation.title}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentLocationItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => BlocProvider.of<SearchLocationBloc>(context)
      //     .add(SearchUserLocationRequestEvent()),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[100]),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Icon(Icons.location_on,
                        color: Theme.of(context).accentColor))
              ],
            ),
            SizedBox(
              width: 22,
            ),
            Text(
              'Current Location',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseOnMapItem extends StatelessWidget {
  final Function() selectOnMapCallback;

  ChooseOnMapItem({Key key, @required this.selectOnMapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selectOnMapCallback,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[100]),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Icon(Icons.pin_drop,
                        color: Theme.of(context).accentColor))
              ],
            ),
            SizedBox(
              width: 22,
            ),
            Text(
              'Select on Map',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

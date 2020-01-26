import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/route_selection_bloc/bloc.dart';
import 'package:living_city/data/models/search_location_model.dart';

class RouteSearchSelector extends StatefulWidget {
  final bool loop;
  final SearchLocationModel startLocation;
  final SearchLocationModel endLocation;

  const RouteSearchSelector(
      {Key key,
      @required this.loop,
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

  @override
  void initState() {
    super.initState();
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
      padding: const EdgeInsets.only(top: 14, bottom: 14, left: 16, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // InkWell(
          //   borderRadius: BorderRadius.circular(64),
          //   child: Padding(
          //     padding: const EdgeInsets.all(4.0),
          //     child: Icon(
          //       Icons.arrow_back,
          //     ),
          //   ),
          //   onTap: () {},
          // ),
          // SizedBox(width: 8),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: <Widget>[
          //     Icon(Icons.location_searching, size: 18, color: Colors.grey),
          //     RotatedBox(
          //       quarterTurns: 1,
          //       child: Icon(Icons.linear_scale, size: 18, color: Colors.grey),
          //     ),
          //     Icon(Icons.flag, size: 18, color: Colors.grey),
          //   ],
          // ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onEditingComplete: _onEditStartTextfield,
                  controller: _startTextFieldController,
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          gapPadding: 8),
                      hintMaxLines: 1,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      hintText: 'Starting Point'),
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(64),
                onTap: _onLoopTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.loop,
                    color: widget.loop
                        ? Theme.of(context).accentColor
                        : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onEditingComplete: _onEditDestinationTextfield,
                  controller: _destinationTextFieldController,
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  enabled: !widget.loop,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          gapPadding: 8),
                      hintMaxLines: 1,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      hintText: 'Destination'),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(64),
                onTap: !widget.loop ? _onSwapTap : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.swap_vert,
                    color: widget.loop ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              )
            ],
          ),

          // InkWell(
          //   borderRadius: BorderRadius.circular(64),
          //   onTap: () {
          //     setState(() {
          //       _loop = !_loop;
          //     });
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(
          //       Icons.loop,
          //       color: _loop
          //           ? Theme.of(context).accentColor
          //           : Colors.grey[700],
          //     ),
          //   ),
          // ),
          // InkWell(
          //   borderRadius: BorderRadius.circular(64),
          //   onTap: !_loop ? () {} : null,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(
          //       Icons.swap_vert,
          //       color: _loop ? Colors.grey[400] : Colors.grey[700],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void _updateTextFields() {
    _startTextFieldController.text = widget.startLocation?.title;
    _destinationTextFieldController.text = widget.endLocation?.title;
  }

  void _onLoopTap() {
    _onEditStartTextfield();
    _onEditDestinationTextfield();
    BlocProvider.of<RouteSelectionBloc>(context)
        .add(LoopRouteRequest(loop: !widget.loop));
  }

  void _onSwapTap() {
    _onEditStartTextfield();
    _onEditDestinationTextfield();
    BlocProvider.of<RouteSelectionBloc>(context).add(SwapRouteRequest());
  }

  void _onEditStartTextfield() {
    if (_startTextFieldController.text.isNotEmpty)
      BlocProvider.of<RouteSelectionBloc>(context).add(NewStartLocation(
          startLocation:
              SearchLocationModel(title: _startTextFieldController.text)));
    FocusScope.of(context).unfocus();
  }

  void _onEditDestinationTextfield() {
    if (_destinationTextFieldController.text.isNotEmpty)
      BlocProvider.of<RouteSelectionBloc>(context).add(NewEndLocation(
          endLocation: SearchLocationModel(
              title: _destinationTextFieldController.text)));
    FocusScope.of(context).unfocus();
  }
}

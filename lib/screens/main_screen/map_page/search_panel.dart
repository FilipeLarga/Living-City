import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import 'package:living_city/bloc/search_history/search_history_bloc.dart';
import 'package:living_city/data/models/location_model.dart';

class SearchPanel extends StatefulWidget {
  final Function() openSheet;
  final Function() closeSheet;
  final ScrollController scrollController;

  const SearchPanel(
      {Key key,
      @required this.openSheet,
      @required this.closeSheet,
      @required this.scrollController})
      : super(key: key);

  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  FocusNode _myFocusNode;

  bool _ignoretextfield; //this is true when sheet is closed or moving
  bool _focusWhenOpen;
  @override
  void initState() {
    BlocProvider.of<SearchHistoryBloc>(context).add(const FetchHistory());
    _myFocusNode = FocusNode();
    _ignoretextfield = true;
    _focusWhenOpen = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomSheetBloc, BottomSheetState>(
      listener: (context, state) {
        if (state is SheetOpen) {
          setState(() {
            if (_focusWhenOpen) _myFocusNode.requestFocus();
            _ignoretextfield = false;
            _focusWhenOpen = false;
          });
        } else if (state is SheetMoving && state.factor < 0.99) {
          FocusScope.of(context).unfocus();
          setState(() {
            _ignoretextfield = true;
          });
        } else if (state is SheetClosed) {
          FocusScope.of(context).unfocus();
          setState(() {
            _ignoretextfield = true;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  ignoring: !_ignoretextfield,
                  child: GestureDetector(
                    onTap: _openAndFocusKeyboard,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: _ignoretextfield,
                child: TextField(
                  focusNode: _myFocusNode,
                  decoration: InputDecoration(fillColor: Colors.grey),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: widget.scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Colors.purple,
                    child: Center(
                      child: MaterialButton(
                        onPressed: widget.closeSheet,
                        color: Colors.pinkAccent,
                        child: Text('Select on map'),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.purpleAccent,
                    height: 350,
                    child: Center(
                      child: MaterialButton(
                        onPressed: widget.closeSheet,
                        color: Colors.pinkAccent,
                        child: Text('Other Options'),
                      ),
                    ),
                  ),
                  BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
                    builder: (BuildContext context, SearchHistoryState state) {
                      if (state is SearchHistoryLoading) {
                        return Text('loading');
                      } else if (state is SearchHistoryEmpty) {
                        return Text('empty');
                      } else {
                        final List<LocationModel> locations =
                            (state as SearchHistoryLoaded).searchHistory;
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: locations.length ?? 0,
                            itemExtent: 100,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Center(
                                child: Text('${locations[index].address}'),
                              );
                            });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    super.dispose();
  }

  void _openAndFocusKeyboard() {
    setState(() {
      _focusWhenOpen = true;
    });
    widget.openSheet();
  }
}

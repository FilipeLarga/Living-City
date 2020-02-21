import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_location_bloc/bloc.dart';
import '../data/models/search_location_model.dart';

class SearchBar extends StatefulWidget {
  final List<SearchLocationModel> searchHistoryList;
  final SearchLocationModel searchLocation;
  final AnimationController animationController;
  const SearchBar(
      {Key key,
      this.searchHistoryList,
      this.searchLocation,
      @required this.animationController})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  final FocusNode _node = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  List<SearchLocationModel> _searchHistoryList;
  bool _shouldErase;
  bool _shouldExpand;
  bool _typing;

  String _prevText;

  // Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _shouldErase = false;
    _shouldExpand = false;
    // _animation = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
    //     .animate(widget.animationController);
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchHistoryList != null) {
      _searchHistoryList = widget.searchHistoryList;
    }

    if (widget.searchLocation != null) {
      _textEditingController.text = widget.searchLocation.title;
      _prevText = widget.searchLocation.title;
      _shouldExpand = true;
      _typing = false;
      _shouldErase = true;
      FocusScope.of(context).unfocus();
    }
    // if (widget.state is UnitializedSearchState) {
    //   _searchHistoryList = null;
    // } else if (widget.state is InitialSearchState) {
    //   _searchHistoryList = (widget.state as InitialSearchState).searchHistory;
    // } else if (widget.state is ShowingLocationSearchState) {
    //   updateSelected(_searchLocationModel);
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _node.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 18,
        right: 18,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(
                width: 4,
              ),
              GestureDetector(
                child: _shouldErase
                    ? const Icon(
                        Icons.close,
                        color: Colors.black,
                      )
                    : const Icon(Icons.search, color: Colors.black),
                onTap: () {
                  if (_shouldErase) {
                    _stopSearch();
                    BlocProvider.of<SearchLocationBloc>(context)
                        .add(CancelSearchRequestEvent());
                  } else {
                    _search();
                  }
                },
              ),
              const SizedBox(
                width: 22,
              ),
              Expanded(
                child: TextField(
                  onSubmitted: (String name) {
                    _onSelect(SearchLocationModel(
                        title: _textEditingController?.text));
                  },
                  controller: _textEditingController,
                  onTap: () {
                    _search();
                  },
                  autofocus: false,
                  focusNode: _node,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintMaxLines: 1,
                    hintText: 'Search here',
                    border: InputBorder.none,
                  ),
                ),
              ),
              // const SizedBox(
              //   width: 22,
              // ),
              // GestureDetector(
              //   child: const Icon(Icons.my_location, color: Colors.black87),
              //   onTap: () {
              //     BlocProvider.of<SearchLocationBloc>(context)
              //         .add(SearchUserLocationRequestEvent());
              //   },
              // ),
            ],
          ),
          // AnimatedSize(
          //   duration: Duration(milliseconds: 300),
          //   vsync: this,
          //   child: _chooseWidget(),

          // ),
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
          // AnimatedCrossFade(
          //   duration: Duration(milliseconds: 300),
          //   crossFadeState: _shouldExpand
          //       ? CrossFadeState.showSecond
          //       : CrossFadeState.showFirst,
          //   firstChild: Container(),
          //   secondChild: AnimatedSwitcher(
          //     // layoutBuilder: (child, children) {
          //     //   return Stack(
          //     //     overflow: Overflow.visible,
          //     //     alignment: Alignment.center,
          //     //     children: <Widget>[
          //     //       Positioned(key: child.key, top: 0, child: child),
          //     //                           Positioned(key: child.key, top: 0, child: child)

          //     //     ],
          //     //   );
          //     // },
          //     // crossFadeState: _searchHistoryList == null
          //     //     ? CrossFadeState.showFirst
          //     //     : CrossFadeState.showSecond,
          //     // firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          //     // secondCurve:
          //     //     const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
          //     duration: Duration(milliseconds: 2000),
          //     // firstChild: SearchBarLoadingHistory(),
          //     // secondChild: _chooseWidget(),
          //     child: _chooseWidget(),
          //   ),
          //   firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          //   secondCurve: const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
          //   sizeCurve: Curves.fastOutSlowIn,
          // )
        ],
      ),
    );
  }

  void _search() {
    setState(() {
      _typing = true;
      _shouldErase = true;
      _shouldExpand = true;
      if (!FocusScope.of(context).hasFocus)
        FocusScope.of(context).requestFocus(_node);
    });
  }

  void _stopSearch() {
    setState(() {
      _prevText = '';
      _shouldExpand = false;
      _shouldErase = false;
      _textEditingController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  void _onSelect(SearchLocationModel selected) {
    _typing = false;
    _shouldExpand = false;
    FocusScope.of(context).unfocus();
    if (selected.title != _prevText)
      BlocProvider.of<SearchLocationBloc>(context)
          .add(SearchRequestEvent(searchLocation: selected));
    else {
      setState(() {
        _shouldExpand = true;
        _typing = false;
        _shouldErase = true;
      });
    }
  }

  StatelessWidget _chooseWidget() {
    if (!_shouldExpand) {
      return Container();
    } else if (widget.searchLocation != null && !_typing) {
      return RoutePointSelector();
    } else if (_searchHistoryList != null)
      return HistoryList(
        callback: _onSelect,
        list: _searchHistoryList,
      );
    else
      return NoHistory();
  }
}

class SearchBarLoadingHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 4),
        const Center(
          child: const Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
            child: const Text(
              'Loading Recent Locations...',
              style: const TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class RoutePointSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            thickness: 1,
            height: 0,
          ),
          const SizedBox(height: 8),
          Text('PLAN TRIP',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      BlocProvider.of<SearchLocationBloc>(context)
                          .add(AcceptLocationEvent(origin: true));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[100]),
                            ),
                            Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Icon(Icons.trip_origin,
                                    size: 20,
                                    color: Theme.of(context).accentColor))
                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'From',
                            ),
                            Text(
                              'This location',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  child: VerticalDivider(
                    thickness: 1,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      BlocProvider.of<SearchLocationBloc>(context)
                          .add(AcceptLocationEvent(origin: false));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[100]),
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
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'To',
                            ),
                            Text(
                              'This location',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NoHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
        child: const Text(
          'No Recent Locations',
          style:
              const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          maxLines: 1,
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

class HistoryList extends StatelessWidget {
  final Function(SearchLocationModel) callback;
  final List<SearchLocationModel> list;

  const HistoryList({Key key, @required this.callback, @required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(thickness: 1, height: 0),
        const SizedBox(height: 8),
        CurrentLocationItem(),
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
          separatorBuilder: (ctx, index) => Divider(
            thickness: 1,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) => SearchHistoryListItem(
            callback: callback,
            searchLocation: list.elementAt(index),
          ),
        ),
      ],
    );
  }
}

class SearchHistoryListItem extends StatelessWidget {
  final Function(SearchLocationModel) callback;
  final SearchLocationModel searchLocation;

  const SearchHistoryListItem(
      {Key key, @required this.callback, @required this.searchLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(searchLocation),
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

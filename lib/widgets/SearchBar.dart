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

class _SearchBarState extends State<SearchBar> {
  final FocusNode _node = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  List<SearchLocationModel> _searchHistoryList;

  bool _shouldErase;
  bool _shouldExpand;

  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _shouldErase = false;
    _shouldExpand = false;
    print('${widget.animationController.value}');
    _animation = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
        .animate(widget.animationController);
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchHistoryList != null) {
      _searchHistoryList = widget.searchHistoryList;
    }

    if (widget.searchLocation != null) {
      _textEditingController.text = widget.searchLocation.title;
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
              const SizedBox(
                width: 22,
              ),
              GestureDetector(
                child: const Icon(Icons.my_location, color: Colors.black),
                onTap: () {
                  BlocProvider.of<SearchLocationBloc>(context)
                      .add(SearchUserLocationRequestEvent());
                },
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            crossFadeState: _shouldExpand
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Container(),
            secondChild: AnimatedCrossFade(
              crossFadeState: _searchHistoryList == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
              secondCurve:
                  const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
              duration: Duration(milliseconds: 300),
              firstChild: SearchBarLoadingHistory(),
              secondChild: _chooseWidget(),
            ),
            firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
            secondCurve: const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
            sizeCurve: Curves.fastOutSlowIn,
          )
        ],
      ),
    );
  }

  void _search() {
    setState(() {
      _shouldErase = true;
      _shouldExpand = true;
      if (!FocusScope.of(context).hasFocus)
        FocusScope.of(context).requestFocus(_node);
    });
  }

  void _stopSearch() {
    setState(() {
      _shouldExpand = false;
      _shouldErase = false;
      _textEditingController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  void _onSelect(SearchLocationModel selected) {
    _shouldExpand = false;
    FocusScope.of(context).unfocus();
    BlocProvider.of<SearchLocationBloc>(context)
        .add(SearchRequestEvent(searchLocation: selected));
  }

  StatelessWidget _chooseWidget() {
    if (_searchHistoryList != null)
      return SearchBarHistoryList(
        callback: _onSelect,
        list: _searchHistoryList,
      );
    else
      return SearchBarNoHistory();
  }
}

class SearchBarLoadingHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
        child: const Text(
          'Loading Recent Locations...',
          style:
              const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          maxLines: 1,
        ),
      ),
    );
  }
}

class SearchBarNoHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
        child: const Text(
          'No Recent Locations.',
          style:
              const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          maxLines: 1,
        ),
      ),
    );
  }
}

class SearchBarHistoryList extends StatelessWidget {
  final Function(SearchLocationModel) callback;
  final List<SearchLocationModel> list;

  const SearchBarHistoryList(
      {Key key, @required this.callback, @required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 6),
      shrinkWrap: true,
      itemCount: list.length > 3 ? 3 : list.length,
      separatorBuilder: (ctx, index) => Divider(
        thickness: 1,
      ),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) => SearchHistoryListItem(
        callback: callback,
        searchLocation: list.elementAt(index),
      ),
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
            Icon(
              Icons.history,
              color: Colors.grey,
            ),
            SizedBox(
              width: 22,
            ),
            Text(
              '${searchLocation.title}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

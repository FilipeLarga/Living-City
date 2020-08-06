import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import 'package:living_city/bloc/search_history/search_history_bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:shimmer/shimmer.dart';

class SearchPanel extends StatefulWidget {
  static const routeName = 'map/explorer/search';

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
    super.initState();
    if (!(BlocProvider.of<SearchHistoryBloc>(context).state
        is SearchHistoryLoading)) {
      BlocProvider.of<SearchHistoryBloc>(context).add(const FetchHistory());
    }
    _myFocusNode = FocusNode();
    _ignoretextfield = true;
    _focusWhenOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BottomSheetBloc, BottomSheetState>(
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
        ),
      ],
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          controller: widget.scrollController,
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: _PersistentHeader(_ignoretextfield,
                  _openAndFocusKeyboard, _myFocusNode, _onSubmitted),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _OptionsList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RECENT SEARCHES',
                        style: const TextStyle(
                            fontSize: 10,
                            color: const Color(0xFF7F7E7E),
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
              builder: (context, state) {
                if (state is SearchHistoryLoading ||
                    state is SearchHistoryInitial) {
                  return SliverToBoxAdapter(child: const ShimmerList());
                } else if (state is SearchHistoryEmpty) {
                  return SliverToBoxAdapter(child: Text('empty'));
                } else {
                  final List<LocationModel> locations =
                      (state as SearchHistoryLoaded).searchHistory;
                  return SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...locations.map((location) {
                          return SearchHistoryListItem(
                            location: location,
                            onSelect: _onSelect,
                          );
                        }),
                        const SizedBox(height: 24)
                      ],
                    ),
                  );
                }
              },
            )

            // Column(
            //   mainAxisSize: MainAxisSize.max,
            //   children: <Widget>[
            //     Container(
            //       height: 4,
            //       width: 36,
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFE0E0E0),
            //         borderRadius: BorderRadius.circular(16),
            //       ),
            //     ),
            //     const SizedBox(
            //       height: 12,
            //     ),
            //     Stack(
            //       children: <Widget>[
            //         Positioned(
            //           bottom: 0,
            //           top: 0,
            //           left: 0,
            //           right: 0,
            //           child: IgnorePointer(
            //             ignoring: !_ignoretextfield,
            //             child: GestureDetector(
            //               behavior: HitTestBehavior.opaque,
            //               onTap: _openAndFocusKeyboard,
            //               child: Container(),
            //             ),
            //           ),
            //         ),
            //         IgnorePointer(
            //           ignoring: _ignoretextfield,
            //           child: ConstrainedBox(
            //             constraints: BoxConstraints(maxHeight: 48, minHeight: 48),
            //             child: TextField(
            //               textCapitalization: TextCapitalization.words,
            //               autocorrect: false,
            //               maxLines: 1,
            //               focusNode: _myFocusNode,
            //               onSubmitted: _onSubmitted,
            //               decoration: InputDecoration(
            //                 prefixIcon: Icon(
            //                   Icons.search,
            //                   color: const Color(0xFF808080),
            //                 ),
            //                 contentPadding: const EdgeInsets.symmetric(
            //                     vertical: 6.0, horizontal: 16),
            //                 hintText: 'Search here',
            //                 enabledBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: const BorderSide(
            //                       color: Color(0xFFF0F0F0), width: 1.5),
            //                 ),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: BorderSide(
            //                       color: Theme.of(context).cursorColor, width: 1),
            //                 ),
            //                 border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: const BorderSide(
            //                       color: Color(0xFFF0F0F0), width: 1.5),
            //                 ),
            //                 fillColor: Colors.grey,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     const SizedBox(height: 16),
            //     Expanded(
            //       child: SingleChildScrollView(
            //         physics: BouncingScrollPhysics(),
            //         controller: widget.scrollController,
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: <Widget>[
            //             Container(
            //               height: 56,
            //               decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(10),
            //                   color: const Color(0xFFF0F0F0)),
            //               child: Center(
            //                 child: Row(
            //                   children: <Widget>[
            //                     const SizedBox(width: 12),
            //                     Icon(
            //                       Icons.pin_drop,
            //                       color: const Color(0xFF808080),
            //                     ),
            //                     const SizedBox(width: 12),
            //                     Padding(
            //                       padding:
            //                           const EdgeInsets.symmetric(vertical: 12.0),
            //                       child: const Text(
            //                         'Choose on map',
            //                         maxLines: 1,
            //                         overflow: TextOverflow.ellipsis,
            //                         style: const TextStyle(
            //                             fontSize: 12,
            //                             color: const Color(0xFF4D4D4D)),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 8),
            //             Container(
            //               height: 56,
            //               decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(10),
            //                   color: const Color(0xFFF0F0F0)),
            //               child: Center(
            //                 child: Row(
            //                   children: <Widget>[
            //                     const SizedBox(width: 12),
            //                     Icon(
            //                       Icons.history,
            //                       color: const Color(0xFF808080),
            //                     ),
            //                     const SizedBox(width: 12),
            //                     Padding(
            //                       padding:
            //                           const EdgeInsets.symmetric(vertical: 12.0),
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           const Text(
            //                             'Current Location',
            //                             maxLines: 1,
            //                             overflow: TextOverflow.ellipsis,
            //                             style: const TextStyle(
            //                                 fontSize: 12,
            //                                 color: const Color(0xFF4D4D4D)),
            //                           ),
            //                           const Text(
            //                             'Avenida das Forças Armadas',
            //                             maxLines: 1,
            //                             overflow: TextOverflow.ellipsis,
            //                             style: const TextStyle(
            //                                 fontSize: 10,
            //                                 color: const Color(0xFF666666)),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 24),
            //             Align(
            //                 alignment: Alignment.centerLeft,
            //                 child: Text(
            //                   'RECENT SEARCHES',
            //                   style: const TextStyle(
            //                       fontSize: 10,
            //                       color: const Color(0xFF7F7E7E),
            //                       fontWeight: FontWeight.w600),
            //                 )),
            //             const SizedBox(height: 16),
            //             BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
            //               builder:
            //                   (BuildContext context, SearchHistoryState state) {
            //                 if (state is SearchHistoryLoading ||
            //                     state is SearchHistoryInitial) {
            //                   return const ShimmerList();
            //                 } else if (state is SearchHistoryEmpty) {
            //                   return Text('empty');
            //                 } else {
            //                   final List<LocationModel> locations =
            //                       (state as SearchHistoryLoaded).searchHistory;
            //                   return Column(
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: <Widget>[
            //                       ...locations.map((location) {
            //                         return SearchHistoryListItem(
            //                           location: location,
            //                           onSelect: _onSelect,
            //                         );
            //                       }),
            //                       const SizedBox(height: 24)
            //                     ],
            //                   );
            //                 }
            //               },
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
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

  void _onSubmitted(String address) {
    BlocProvider.of<BSNavigationBloc>(context)
        .add(BSNavigationLocationSelected(address: address));
  }

  void _onSelect(LocationModel locationModel) {
    BlocProvider.of<BSNavigationBloc>(context)
        .add(BSNavigationLocationSelected(locationModel: locationModel));
  }
}

class _PersistentHeader extends SliverPersistentHeaderDelegate {
  final bool _ignoretextfield;
  final Function() _openAndFocusKeyboard;
  final FocusNode _myFocusNode;
  final Function(String) _onSubmitted;

  _PersistentHeader(this._ignoretextfield, this._openAndFocusKeyboard,
      this._myFocusNode, this._onSubmitted);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 4,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
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
                    behavior: HitTestBehavior.opaque,
                    onTap: _openAndFocusKeyboard,
                    child: Container(),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: _ignoretextfield,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 48, minHeight: 48),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    maxLines: 1,
                    focusNode: _myFocusNode,
                    onSubmitted: _onSubmitted,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: const Color(0xFF808080),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 16),
                      hintText: 'Search here',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFFF0F0F0), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Theme.of(context).cursorColor, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFFF0F0F0), width: 1.5),
                      ),
                      fillColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _OptionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF0F0F0)),
          child: Center(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                Icon(
                  Icons.pin_drop,
                  color: const Color(0xFF808080),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: const Text(
                    'Choose on map',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: const Color(0xFF4D4D4D)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF0F0F0)),
          child: Center(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                Icon(
                  Icons.history,
                  color: const Color(0xFF808080),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Current Location',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: const Color(0xFF4D4D4D)),
                      ),
                      const Text(
                        'Avenida das Forças Armadas',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: const Color(0xFF666666)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchHistoryListItem extends StatelessWidget {
  final LocationModel location;
  final Function(LocationModel) onSelect;

  const SearchHistoryListItem(
      {Key key, @required this.location, @required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () => onSelect(location),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //color: const Color(0xFFF0F0F0)
          ),
          child: Center(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                Icon(
                  Icons.history,
                  color: const Color(0xFF808080),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        location.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: const Color(0xFF4D4D4D)),
                      ),
                      Text(
                        location.locality,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: const Color(0xFF666666)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: 8,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 12),
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 10,
                            color: Colors.white,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (_, constraints) {
                              return Container(
                                height: 10,
                                color: Colors.white,
                                width: constraints.maxWidth / 2,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/route_selection/bloc.dart';
// import '../data/models/search_location_model.dart';

// class OldSearchBar extends StatefulWidget {
//   final List<SearchLocationModel> searchHistoryList;

//   const OldSearchBar({Key key, @required this.searchHistoryList})
//       : super(key: key);

//   @override
//   _OldSearchBarState createState() => _OldSearchBarState();
// }

// class _OldSearchBarState extends State<OldSearchBar> with TickerProviderStateMixin {
//   final FocusNode _node = FocusNode();
//   final TextEditingController _textEditingController = TextEditingController();
//   bool _shouldErase;
//   bool _shouldExpand;

//   @override
//   void initState() {
//     super.initState();
//     _shouldErase = false;
//     _shouldExpand = false;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _node.dispose();
//     _textEditingController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SearchLocationBloc, SearchLocationState>(
//       listener: (context, state) {
//         if (state is ShowingLocationSearchState) {
//           _textEditingController?.text = state.searchLocation.title;
//         } else if (state is AnimatingState) {
//           _stopSearch();
//         }
//       },
//       child: Material(
//         color: Colors.transparent,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 GestureDetector(
//                   child: _shouldErase
//                       ? const Icon(
//                           Icons.close,
//                           color: Colors.black,
//                         )
//                       : const Icon(Icons.search, color: Colors.black),
//                   onTap: () {
//                     if (_shouldErase) {
//                       _stopSearch();
//                       BlocProvider.of<SearchLocationBloc>(context)
//                           .add(CancelSearchRequestEvent());
//                     } else {
//                       _search();
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   width: 22,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     onSubmitted: (String name) {
//                       _onSelect(SearchLocationModel(
//                           title: _textEditingController?.text));
//                     },
//                     controller: _textEditingController,
//                     onTap: () {
//                       _search();
//                     },
//                     autofocus: false,
//                     focusNode: _node,
//                     textCapitalization: TextCapitalization.words,
//                     autocorrect: false,
//                     maxLines: 1,
//                     decoration: const InputDecoration(
//                       hintMaxLines: 1,
//                       hintText: 'Search here',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 22,
//                 ),
//                 GestureDetector(
//                   child: const Icon(Icons.my_location, color: Colors.black),
//                   onTap: () {
//                     BlocProvider.of<SearchLocationBloc>(context)
//                         .add(SearchUserLocationRequestEvent());
//                   },
//                 ),
//               ],
//             ),
//             AnimatedCrossFade(
//               duration: Duration(milliseconds: 300),
//               crossFadeState: _shouldExpand
//                   ? CrossFadeState.showSecond
//                   : CrossFadeState.showFirst,
//               firstChild: Container(),
//               secondChild: AnimatedCrossFade(
//                 crossFadeState: widget.searchHistoryList == null
//                     ? CrossFadeState.showFirst
//                     : CrossFadeState.showSecond,
//                 firstCurve:
//                     const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
//                 secondCurve:
//                     const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
//                 duration: Duration(milliseconds: 300),
//                 firstChild: SearchBarLoadingHistory(),
//                 secondChild: _chooseWidget(),
//               ),
//               firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
//               secondCurve:
//                   const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
//               sizeCurve: Curves.fastOutSlowIn,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void _search() {
//     setState(() {
//       _shouldErase = true;
//       _shouldExpand = true;
//       if (!FocusScope.of(context).hasFocus)
//         FocusScope.of(context).requestFocus(_node);
//     });
//   }

//   void _stopSearch() {
//     setState(() {
//       _shouldExpand = false;
//       _shouldErase = false;
//       _textEditingController.clear();
//       FocusScope.of(context).unfocus();
//     });
//   }

//   void _onSelect(SearchLocationModel selected) {
//     _shouldExpand = false;
//     FocusScope.of(context).unfocus();
//     BlocProvider.of<SearchLocationBloc>(context)
//         .add(SearchRequestEvent(searchLocation: selected));
//   }

//   StatelessWidget _chooseWidget() {
//     if (widget.searchHistoryList != null)
//       return SearchBarHistoryList(
//         callback: _onSelect,
//         list: widget.searchHistoryList,
//       );
//     else
//       return SearchBarNoHistory();
//   }
// }

// class SearchBarLoadingHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
//         child: Text(
//           'Loading Recent Locations...',
//           style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
//           maxLines: 1,
//         ),
//       ),
//     );
//   }
// }

// class SearchBarNoHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
//         child: Text(
//           'No Recent Locations.',
//           style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
//           maxLines: 1,
//         ),
//       ),
//     );
//   }
// }

// class SearchBarHistoryList extends StatelessWidget {
//   final Function(SearchLocationModel) callback;
//   final List<SearchLocationModel> list;

//   const SearchBarHistoryList(
//       {Key key, @required this.callback, @required this.list})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: EdgeInsets.only(bottom: 6),
//       shrinkWrap: true,
//       itemCount: list.length > 3 ? 3 : list.length,
//       separatorBuilder: (ctx, index) => Divider(
//         thickness: 1,
//       ),
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (ctx, index) => SearchHistoryListItem(
//         callback: callback,
//         searchLocation: list.elementAt(index),
//       ),
//     );
//   }
// }

// class SearchHistoryListItem extends StatelessWidget {
//   final Function(SearchLocationModel) callback;
//   final SearchLocationModel searchLocation;

//   const SearchHistoryListItem(
//       {Key key, @required this.callback, @required this.searchLocation})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => callback(searchLocation),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               Icons.history,
//               color: Colors.grey,
//             ),
//             SizedBox(
//               width: 22,
//             ),
//             Text(
//               '${searchLocation.title}',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

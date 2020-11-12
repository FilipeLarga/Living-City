import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong/latlong.dart';

import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../../bloc/points_of_interest/points_of_interest_bloc.dart';
import '../../../../core/categories.dart';
import '../../../../core/leaf_colors.dart' as leafColors;
import '../../../../data/models/point_of_interest_model.dart';

class PlanInterestsPanel extends StatelessWidget {
  final List<int> activeCategories;
  final List<PointOfInterestModel> activePOIs;
  final int date;
  final LatLng origin;

  const PlanInterestsPanel(
      {Key key,
      @required this.activeCategories,
      @required this.activePOIs,
      @required this.date,
      @required this.origin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(date);
    final pois = (BlocProvider.of<PointsOfInterestBloc>(context).state
            as PointsOfInterestLoaded)
        .pois;
    //Filter for schedule
    final List<PointOfInterestModel> scheduleItems = pois
        .where((element) =>
            date >= element.openingHour && date <= element.closureHour)
        .toList();
    // scheduleItems..sort((a, b) => b.sustainability.compareTo(a.sustainability));
    // print(scheduleItems.length);
    // for (PointOfInterestModel poi in scheduleItems) print(poi.name);

    // for (int i in activeCategories) print(i);

    //Filter for category
    final List<PointOfInterestModel> displayItems = scheduleItems
        .where((element) => activeCategories.contains(element.categoryID))
        .toList()
          ..sort((a, b) => b.sustainability.compareTo(a.sustainability));

    final int price = activePOIs.fold<int>(
        0,
        (previousValue, element) =>
            previousValue.toInt() + element.price.toInt());

    final int visitTime = activePOIs.fold<int>(
        0, (previousValue, element) => previousValue + element.visitTime);

    int sustainability = activePOIs.fold<int>(
        0, (previousValue, element) => previousValue + element.sustainability);
    if (sustainability != 0)
      sustainability = (sustainability / activePOIs.length).round();

    return Container(
      padding: EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Interests',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20, height: 1)),
              Row(
                children: <Widget>[
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 1.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFF0F0F0),
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.euro_symbol),
                      const SizedBox(width: 8),
                      Padding(
                        padding: EdgeInsets.only(left: price == 0 ? 7 : 0),
                        child: Text(
                          price == 0 ? '--' : '$price',
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFF0F0F0),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Padding(
                        padding: EdgeInsets.only(left: visitTime == 0 ? 7 : 0),
                        child: Text(
                          (visitTime == 0 ? '--' : '$visitTime') + '  Min',
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFF0F0F0),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/eco_leaf.png',
                          color: sustainability == 0
                              ? Theme.of(context).iconTheme.color
                              : leafColors.leafColor(sustainability >= 80
                                  ? 3
                                  : sustainability >= 70
                                      ? 2
                                      : sustainability >= 60 ? 1 : 0),
                          height: 24,
                          width: 24),
                      const SizedBox(width: 8),
                      Padding(
                        padding:
                            EdgeInsets.only(left: sustainability == 0 ? 7 : 0),
                        child: Text(
                          (sustainability == 0 ? '--' : '$sustainability') +
                              '  %',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => _selectAllCategories(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: activeCategories.length == categories.length
                          ? Theme.of(context).accentColor
                          : Colors.grey[100],
                    ),
                    child: Text('All',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: activeCategories.length == categories.length
                              ? Colors.white
                              : null,
                        )),
                  ),
                ),
              ),
              ...List<Widget>.generate(
                categories.length,
                (index) => Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => _onTapCategory(index + 1,
                        activeCategories.contains(index + 1), context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (!activeCategories.contains(index + 1) ||
                                activeCategories.length == categories.length)
                            ? Colors.grey[100]
                            : Theme.of(context).accentColor,
                      ),
                      child: Text(categories[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: !(!activeCategories.contains(index + 1) ||
                                    activeCategories.length ==
                                        categories.length)
                                ? Colors.white
                                : null,
                          )),
                    ),
                  ),
                ),
                growable: false,
              ),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: ListView.builder(
                padding: const EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                itemCount: displayItems.length,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        top: 0,
                        bottom: index != displayItems.length - 1 ? 12 : 0),
                    child: PointOfInterestItem(
                      item: displayItems[index],
                      origin: origin,
                      onTap: () => _onTapItem(displayItems[index],
                          activePOIs.contains(displayItems[index]), context),
                      selected: activePOIs.contains(displayItems[index]),
                    ))),
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Material(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: Ink(
                    height: 42,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(2),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                      ),
                      color: Colors.black,
                      onPressed: () =>
                          BlocProvider.of<BSNavigationBloc>(context)
                              .add(BSNavigationCanceled()),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Material(
                  color: Theme.of(context).accentColor,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: InkWell(
                      onTap: () => BlocProvider.of<BSNavigationBloc>(context)
                          .add(BSNavigationAdvanced()),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: Text(activePOIs.length > 0 ? 'NEXT' : 'SKIP',
                                style: TextStyle(
                                    wordSpacing: 1.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onTapCategory(int index, bool active, BuildContext context) {
    if (activeCategories.length == categories.length) {
      BlocProvider.of<BSNavigationBloc>(context)
          .add(BSNavigationInterestAdded(categories: [index]));
    } else {
      if (active) {
        activeCategories.remove(index);
      } else {
        activeCategories.add(index);
      }
      BlocProvider.of<BSNavigationBloc>(context)
          .add(BSNavigationInterestAdded(categories: activeCategories));
    }
  }

  _selectAllCategories(BuildContext context) {
    if (activeCategories.length == categories.length)
      BlocProvider.of<BSNavigationBloc>(context)
          .add(BSNavigationInterestAdded(categories: []));
    else
      BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationInterestAdded(
          categories: categories.map((e) => e.id).toList()));
  }

  _onTapItem(PointOfInterestModel poi, bool active, BuildContext context) {
    if (active) {
      activePOIs.remove(poi);
    } else {
      activePOIs.insert(0, poi);
    }
    BlocProvider.of<BSNavigationBloc>(context).add(BSNavigationInterestAdded(
        categories: activeCategories, pois: activePOIs));
  }
}

// class PointsAnimatedList extends StatefulWidget {
//   final List<PointOfInterestModel> displayItems;

//   const PointsAnimatedList({Key key, @required this.displayItems})
//       : super(key: key);

//   @override
//   _PointsAnimatedListState createState() => _PointsAnimatedListState();
// }

// class _PointsAnimatedListState extends State<PointsAnimatedList> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   ListModel<PointOfInterestModel> _list;

//   @override
//   void initState() {
//     super.initState();
//     _list = ListModel<PointOfInterestModel>(
//       listKey: _listKey,
//       initialItems: widget.displayItems,
//       removedItemBuilder: _buildRemovedItem,
//     );
//   }

//   Widget _buildItem(
//       BuildContext context, int index, Animation<double> animation) {
//     return PointOfInterestItem(
//       // animation: animation,
//       item: _list[index],
//       selected: true, //CHANGE THIS
//       onTap: () {},
//     );
//   }

//   Widget _buildRemovedItem(PointOfInterestModel item, BuildContext context,
//       Animation<double> animation) {
//     return PointOfInterestItem(
//       // animation: animation,
//       item: item,
//       selected: false,
//       // No gesture detector here: we don't want removed items to be interactive.
//     );
//   }

//   @override
//   void didUpdateWidget(PointsAnimatedList oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final oldList = oldWidget.displayItems;
//     final newList = widget.displayItems;

//     print('count: ${newList.length}');

//     if (_list.length != 0) {
//       int removed = 0;
//       for (int i = 0; i < oldList.length; i++) {
//         if (!newList.contains(oldList[i])) {
//           _list.removeAt(i - removed);
//           removed++;
//         }
//       }
//     }

//     print('count _list after remove: ${_list.length}');

//     if (_list.length != 0) {
//       for (int i = 0; i < newList.length; i++) {
//         if (!_list.contains(newList[i])) {
//           for (int j = 0; j < _list.length; j++) {
//             if (_list[j].sustainability < newList[i].sustainability) {
//               _list.insert(j, newList[i]);
//             }
//           }
//         }
//       }
//     } else {
//       for (int i = 0; i < newList.length; i++) _list.insert(i, newList[i]);
//     }
//     print('count _list after insert: ${_list.length}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedList(
//         key: _listKey,
//         initialItemCount: widget.displayItems.length,
//         physics: BouncingScrollPhysics(),
//         itemBuilder: _buildItem);
//   }
// }

class PointOfInterestItem extends StatelessWidget {
  PointOfInterestItem(
      {Key key,
      // @required this.animation,
      this.onTap,
      @required this.origin,
      @required this.item,
      this.selected: false})
      :
        // : assert(animation != null),
        assert(item != null),
        assert(selected != null),
        leafCount = item.sustainability >= 80
            ? 3
            : item.sustainability >= 70 ? 2 : item.sustainability >= 60 ? 1 : 0,
        distance = Distance(roundResult: false)
            .as(LengthUnit.Kilometer, origin, item.coordinates)
            .toStringAsFixed(1),
        super(key: key);

  // final Animation<double> animation;
  final VoidCallback onTap;
  final PointOfInterestModel item;
  final bool selected;
  final LatLng origin;
  final int leafCount;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.5,
              color: selected
                  ? Theme.of(context).accentColor
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categories[item.categoryID - 1].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
                const SizedBox(width: 8),
                for (int i = 0; i < 3 - leafCount; i++)
                  Image.asset('assets/eco_leaf.png',
                      color: Colors.grey[300], height: 24, width: 24),
                for (int i = 0; i < leafCount; i++)
                  Image.asset('assets/eco_leaf.png',
                      color: leafColors.leafColor(leafCount),
                      height: 24,
                      width: 24),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text('Visit Time: ${item.visitTime} min'),
                ),
                Text('$distance Km',
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black)),
                ),
                const SizedBox(width: 6),
                Text(item.price == 0 ? 'Free' : '${item.price.round()} €',
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(2.0),
  //     child: FadeTransition(
  //       opacity: animation,
  //       child: GestureDetector(
  //         behavior: HitTestBehavior.opaque,
  //         onTap: onTap,
  //         child: Container(
  //           child: Center(
  //             child: Text('Sustainability ${item.sustainability}'),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// class _CategoryItem extends StatelessWidget {
//   final int id;
//   final String name;
//   final bool active;
//   final Function(int, bool, BuildContext) callback;

//   const _CategoryItem(
//       {Key key,
//       @required this.id,
//       @required this.name,
//       @required this.active,
//       @required this.callback})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => callback(id, !active, context),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             height: 48,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: active
//                   ? Border.all(width: 2, color: Theme.of(context).accentColor)
//                   : null,
//               color: /*active ? Theme.of(context).accentColor : */ Colors
//                   .grey[100],
//             ),
//             child: Center(
//               child: Text(name,
//                   style: TextStyle(
//                     fontSize: 16,
//                     // color: active ? Colors.white : Colors.black,
//                     fontWeight: active ? FontWeight.w400 : FontWeight.normal,
//                   )),
//             ),
//           ),
//           // Positioned(
//           //   bottom: 10,
//           //   right: 10,
//           //   height: 18,
//           //   width: 18,
//           //   child: AnimatedContainer(
//           //     duration: const Duration(milliseconds: 200),
//           //     height: 0,
//           //     width: 0,
//           //     child: Icon(
//           //       Icons.check_circle,
//           //       color: Theme.of(context).accentColor,
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

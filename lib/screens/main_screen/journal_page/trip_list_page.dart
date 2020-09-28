import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vector_math/vector_math_64.dart' as vectors;

import '../../../bloc/trip_details/trip_details_bloc.dart';
import '../../../bloc/trip_list/trip_list_bloc.dart';
import '../../../core/animated_list_helper.dart';
import '../../../core/example_data.dart';
import '../../../core/leaf_colors.dart' as leafColor;
import '../../../data/models/trip_model.dart';
import '../../../widgets/dashed_line.dart';
import '../../../widgets/exceptions.dart';
import '../../../widgets/map_widgets.dart';
import 'trip_details_page.dart';

class TripListPage extends StatelessWidget {
  static const routeName = 'journal/trip_list';
  const TripListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: BlocBuilder<TripListBloc, TripListState>(
        builder: (context, state) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 18),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Text('Trips',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 24),
                  if (state is TripListLoaded) ...[
                    StatsDisplay(
                      sumCalories: state.sumCalories,
                      sumDistance: state.sumDistance,
                      sumPOIsVisited: state.sumPOIsVisited,
                      avgSustainability: state.avgSustainability,
                    ),
                    const SizedBox(height: 24),
                    if (state.currentTrip != null) ...[
                      ActiveTrip(trip: state.currentTrip),
                      const SizedBox(height: 32),
                    ],
                    Flexible(
                      fit: FlexFit.loose,
                      child: TripList(
                          plannedList: state.plannedTrips,
                          completedList: state.completedTrips),
                    ),
                  ] else
                    Text('LOADING'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatsDisplay extends StatelessWidget {
  final int sumCalories;
  final int sumPOIsVisited;
  final int sumDistance;
  final double avgSustainability;

  const StatsDisplay(
      {Key key,
      @required this.sumCalories,
      @required this.sumPOIsVisited,
      @required this.sumDistance,
      @required this.avgSustainability})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: StatsItem(
              value: sumPOIsVisited.toString(),
              name: 'Atractions',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatsItem(
              value: sumDistance.toString() + ' km',
              name: 'Distance',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatsItem(
              value: avgSustainability.round().toString() + ' %',
              name: 'Sustainable',
            ),
          ),
        ],
      ),
    );
  }
}

class StatsItem extends StatelessWidget {
  final String value;
  final String name;

  const StatsItem({Key key, @required this.value, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Theme.of(context).accentColor),
          ),
          Text('$name', style: TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class ActiveTrip extends StatelessWidget {
  final ProgressionTripModel trip;
  const ActiveTrip({@required this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Active Trip',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16.0 / 7.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: const Color(0xFF000000).withOpacity(0.15),
                    offset: const Offset(4, 4),
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Next',
                              style: TextStyle(color: Colors.grey)),
                          Text(trip.originalTrip.pois[1].poi.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Price',
                                      style: TextStyle(color: Colors.grey)),
                                  Text(
                                      '${trip.originalTrip.pois[1].poi.price} €',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Duration',
                                      style: TextStyle(color: Colors.grey)),
                                  Text(
                                      '${trip.originalTrip.pois[1].poi.visitTime} Minutes',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: LineAndMarkersMap(
                      markers: trip.originalTrip.pois
                          .map((e) => e.poi.coordinates)
                          .toList(),
                      line: trip.originalTrip.line,
                      target: trip.originalTrip.pois[1].poi.coordinates,
                      padding: 18,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TripList extends StatefulWidget {
  final List<TripModel> plannedList;
  final List<ProgressionTripModel> completedList;

  const TripList(
      {Key key, @required this.plannedList, @required this.completedList})
      : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  int _selection;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<TripModel> _list;
  int _initialCount;
  bool _isEmpty;

  @override
  void initState() {
    super.initState();
    _selection = 0;
    _list = ListModel<TripModel>(
      listKey: _listKey,
      initialItems: List.from(widget.plannedList),
      removedItemBuilder: _buildRemovedItem,
    );
    _isEmpty = _list.length == 0;
    _initialCount = _list.length;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TripListTab(
            strings: ['Planned', 'Completed'],
            selected: _selection,
            onTap: (value) => _onTabChanged(value),
          ),
          const SizedBox(height: 16),
          Flexible(
            fit: FlexFit.loose,
            child: AnimatedList(
              key: _listKey,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              initialItemCount: _initialCount,
              itemBuilder: (context, index, animation) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: OpenContainer(
                    closedElevation: 0,
                    tappable: true,
                    closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    transitionType: ContainerTransitionType.fade,
                    openBuilder: (context, VoidCallback _) =>
                        BlocProvider<TripDetailsBloc>(
                      create: (BuildContext context) =>
                          TripDetailsBloc(_list[index]),
                      child: TripDetailsPage(),
                    ),
                    closedBuilder: (context, VoidCallback _) => TripListItem(
                      animation: animation,
                      item: _list[index],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
              child: Visibility(
            visible: _isEmpty,
            child: EmptyListException(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('No trip records found',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                      _selection == 0
                          ? 'Plan a trip to start travelling'
                          : 'Complete a trip to share it with friends',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  if (_selection == 0) ...[
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 84.0),
                      child: Material(
                        color: Theme.of(context).accentColor,
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                  child: Text('PLAN TRIP',
                                      style: TextStyle(
                                          wordSpacing: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15))),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  _onTabChanged(int i) async {
    var wasEmpty = _list.length == 0;
    if (i != _selection) {
      setState(() {
        _selection = i;
        _list.removeAll();
      });
      if (!wasEmpty) await Future.delayed(Duration(milliseconds: 330));

      if (_selection == 1) {
        setState(() {
          var trips = List.from(widget.completedList);
          _isEmpty = trips.isEmpty;
          for (ProgressionTripModel trip in trips) {
            _list.insert(_list.length, trip.originalTrip);
          }
        });
      } else if (_selection == 0) {
        setState(() {
          var trips = List.from(widget.plannedList);
          _isEmpty = trips.isEmpty;
          for (TripModel trip in trips) {
            _list.insert(_list.length, trip);
          }
        });
      }
    }
  }

  Widget _buildRemovedItem(
      TripModel trip, BuildContext context, Animation<double> animation) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TripListItem(
        animation: animation,
        item: trip,
      ),
    );
  }
}

class TripListTab extends StatefulWidget {
  final List<String> strings;
  final int selected;
  final ValueChanged<int> onTap;

  const TripListTab(
      {Key key,
      @required this.selected,
      @required this.onTap,
      @required this.strings})
      : super(key: key);
  @override
  _TripListTabState createState() => _TripListTabState();
}

class _TripListTabState extends State<TripListTab> {
  List<GlobalKey> keys;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    keys = List.generate(widget.strings.length, (_) => GlobalKey(),
        growable: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (this.mounted)
        setState(() {
          _ready = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(children: <Widget>[
          for (int i = 0; i < widget.strings.length; i++) ...[
            GestureDetector(
              onTap: () => widget.onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.strings[i],
                    key: keys[i],
                    style: TextStyle(
                        color: widget.selected == i
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            if (i != widget.strings.length - 1) const SizedBox(width: 12),
          ],
        ]),
        SizedBox(height: _ready ? 5 : 10),
        if (_ready)
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            transform: Matrix4.identity()
              ..translate(vectors.Vector3(_calculateDistance(), 0, 0)),
            height: 5,
            width: _calculateWidth(),
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(64),
            ),
          )
      ],
    );
  }

  double _calculateWidth() {
    final RenderBox renderBox =
        (keys[widget.selected].currentContext.findRenderObject() as RenderBox);
    final double originWidth = renderBox.size.width;
    return originWidth * 0.4;
  }

  double _calculateDistance() {
    final double originX =
        (keys[0].currentContext.findRenderObject() as RenderBox)
            .localToGlobal(Offset(0, 0))
            .dx;
    final RenderBox destinationRenderBox =
        (keys[widget.selected].currentContext.findRenderObject() as RenderBox);
    final double destinationX =
        destinationRenderBox.localToGlobal(Offset(0, 0)).dx;
    final double differenceX = destinationX - originX;
    final double destinationWidth = destinationRenderBox.size.width;
    return differenceX + (destinationWidth / 2) - (_calculateWidth() / 2);
  }
}

class TripListItem extends StatelessWidget {
  const TripListItem({
    Key key,
    @required this.animation,
    @required this.item,
  })  : assert(animation != null),
        assert(item != null),
        super(key: key);

  final Animation<double> animation;
  final TripModel item;

  @override
  Widget build(BuildContext context) {
    int leafCount = trip.sustainability >= 80
        ? 3
        : trip.sustainability >= 70 ? 2 : trip.sustainability >= 60 ? 1 : 0;
    return FadeTransition(
      opacity: animation,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                          _formatMonthAndDay(
                              DateTime.fromMillisecondsSinceEpoch(
                                  trip.startTime)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text(
                          _formatHour(DateTime.fromMillisecondsSinceEpoch(
                              trip.startTime)),
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  Spacer(),
                  for (int i = 0; i < 3 - leafCount; i++)
                    Image.asset('assets/eco_leaf.png',
                        color: Colors.grey[300], height: 24, width: 24),
                  for (int i = 0; i < leafCount; i++)
                    Image.asset('assets/eco_leaf.png',
                        color: leafColor.leafColor(leafCount),
                        height: 24,
                        width: 24),
                ],
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).accentColor),
                          ),
                          Expanded(
                            child: CustomPaint(
                              painter: DashedLinePainter(
                                color: Colors.orange,
                                minHeight: 4,
                                minSpace: 4,
                                dashWidth: 1,
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      //makes text overflow work
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(trip.pois[0].poi.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          Text(
                              '+' +
                                  (trip.pois.length - 2).toString() +
                                  ' Attractions',
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 12),
                          Text(trip.pois.last.poi.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  _formatMonthAndDay(DateTime date) => Jiffy(date).format("MMMM do");
  _formatHour(DateTime date) => DateFormat('Hm').format(date);
}

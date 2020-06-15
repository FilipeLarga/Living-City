import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:living_city/bloc/trip_list/trip_list_bloc.dart';
import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/screens/main_screen/journal_page/trip_details_page.dart';
import 'package:vector_math/vector_math_64.dart' as vectors;
import '../../../core/animated_list_helper.dart';
import '../../../widgets/trip_preview.dart';

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
                      OngoingTrip(trip: state.currentTrip),
                      const SizedBox(height: 24),
                    ],
                    Flexible(
                      fit: FlexFit.loose,
                      child: TripList(
                          plannedList: state.plannedTrips,
                          completedList: state.completedTrips),
                    ),
                  ] else
                    Text('LOADING'),
                  /*ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.trips.length,
                          itemBuilder: (context, i) {
                            return StatsDisplay(
                              sumCalories: state.trips[i].calories,
                              sumDistance: state.trips[i].distance,
                              sumPOIsVisited: state.trips[i].pois.length,
                              avgSustainability:
                                  state.trips[i].sustainability.toDouble(),
                            );
                          })*/
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
              value: avgSustainability.toString() + ' %',
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
                color: const Color(0xFFEBA947)),
          ),
          Text('$name', style: TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class OngoingTrip extends StatelessWidget {
  final TripModel trip;
  const OngoingTrip({@required this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Ongoing Trip',
            style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: const Color(0xFF000000).withOpacity(0.15),
                    offset: const Offset(4, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TripPreview(
                  trip: trip,
                ),
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
  final List<TripModel> completedList;

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

  @override
  void initState() {
    super.initState();
    _selection = 0;
    _list = ListModel<TripModel>(
      listKey: _listKey,
      initialItems: List.from(widget.plannedList),
      removedItemBuilder: _buildRemovedItem,
    );
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
            selected: _selection,
            onTap: (value) => _onTabChanged(value),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16.0 / 12,
            child: AnimatedList(
              key: _listKey,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              initialItemCount: _initialCount,
              itemBuilder: (context, index, animation) {
                return TripListItem(
                  animation: animation,
                  item: _list[index],
                  rightPadding: 16,
                  onTap: () => Navigator.of(context).pushNamed(
                      TripDetailsPage.routeName,
                      arguments: _list[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _onTabChanged(int i) {
    if (i != _selection) {
      setState(() {
        _selection = i;
      });
      if (_selection == 1) {
        _list.removeAll();
        var trips = List.from(widget.completedList);
        for (TripModel trip in trips) {
          _list.insert(_list.length, trip);
        }
      } else {
        _list.removeAll();
        var trips = List.from(widget.plannedList);
        for (TripModel trip in trips) {
          _list.insert(_list.length, trip);
        }
      }
    }
  }

  Widget _buildRemovedItem(
      TripModel trip, BuildContext context, Animation<double> animation) {
    return TripListItem(
      animation: animation,
      item: trip,
      rightPadding: 16,
    );
  }
}

class TripListTab extends StatefulWidget {
  final int selected;
  final ValueChanged<int> onTap;

  const TripListTab({Key key, @required this.selected, @required this.onTap})
      : super(key: key);
  @override
  _TripListTabState createState() => _TripListTabState();
}

class _TripListTabState extends State<TripListTab>
    with SingleTickerProviderStateMixin {
  GlobalKey _originKey = GlobalKey();
  GlobalKey _destinationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () => widget.onTap(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Planned',
                style: TextStyle(
                    color: widget.selected == 0 ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                key: _originKey,
                duration: Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                transform: Matrix4.translation(vectors.Vector3(
                    widget.selected == 0 ? 0 : _calculateDistance(), 0, 0)),
                height: 6,
                width: 6,
                decoration: new BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => widget.onTap(1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Completed',
                style: TextStyle(
                    color: widget.selected == 1 ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              const SizedBox(height: 4),
              Container(
                key: _destinationKey,
                height: 6,
                width: 6,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  double _calculateDistance() {
    return (_destinationKey.currentContext.findRenderObject() as RenderBox)
            .localToGlobal(Offset(0, 0))
            .dx -
        (_originKey.currentContext.findRenderObject() as RenderBox)
            .localToGlobal(Offset(0, 0))
            .dx;
  }
}

class TripListItem extends StatelessWidget {
  const TripListItem({
    Key key,
    @required this.animation,
    this.onTap,
    @required this.item,
    @required this.rightPadding,
  })  : assert(animation != null),
        assert(item != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final TripModel item;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: rightPadding),
        child: FadeTransition(
          opacity: animation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 9.0 / 14.0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: TripPreview(
                  trip: item,
                ),
              ),
            ),
          ),
        ));
  }
}

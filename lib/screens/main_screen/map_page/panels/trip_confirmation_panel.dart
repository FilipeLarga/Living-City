import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:living_city/core/categories.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/leaf_colors.dart' as leafColor;

import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../../bloc/location/location_bloc.dart';
import '../../../../bloc/route_request/route_request_bloc.dart';
import '../../../../data/models/location_model.dart';
import '../../../../data/models/trip_plan_model.dart';
import '../../../../data/models/point_of_interest_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TripConfirmationPanel extends StatefulWidget {
  final TripPlanModel tripPlanModel;
  final ScrollController scrollController;
  final double heightLimit;

  const TripConfirmationPanel({
    @required this.tripPlanModel,
    @required this.scrollController,
    @required this.heightLimit,
  });

  @override
  _TripConfirmationPanelState createState() => _TripConfirmationPanelState();
}

class _TripConfirmationPanelState extends State<TripConfirmationPanel> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RouteRequestBloc>(context)
        .add(SendRouteRequest(widget.tripPlanModel));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.white,
        height: widget.heightLimit - 24,
        width: double.infinity,
        child: BlocBuilder<RouteRequestBloc, RouteRequestState>(
          builder: (context, state) {
            if (state is RouteRequestLoading || state is RouteRequestInitial) {
              return Padding(
                padding: const EdgeInsets.only(right: 64.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[50],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4)),
                    height: 25,
                    width: double.infinity,
                  ),
                ),
              );
            } else if (state is RouteRequestConnectionError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 128),
                  FractionallySizedBox(
                    widthFactor: 0.55,
                    child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: 1, minHeight: 1),
                          child: Image.asset(
                            'assets/error_trip.png',
                          ),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Text('Looks like you\'re offline',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Please connect to the internet and try again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 84.0),
                    child: Material(
                      color: Theme.of(context).accentColor,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(8),
                      child: Center(
                        child: InkWell(
                          onTap: () =>
                              BlocProvider.of<RouteRequestBloc>(context)
                                  .add(SendRouteRequest(widget.tripPlanModel)),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                                child: Text('Try Again',
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
                  const SizedBox(height: 8),
                  FlatButton(
                      onPressed: () =>
                          BlocProvider.of<BSNavigationBloc>(context)
                              .add(BSNavigationTripCancelled()),
                      child: Text('Cancel',
                          style: TextStyle(
                              wordSpacing: 1.2,
                              color: Theme.of(context).accentColor,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))),
                ],
              );
            } else if (state is RouteRequestTripError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 184),
                  FractionallySizedBox(
                    widthFactor: 0.55,
                    child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: 1, minHeight: 1),
                          child: Image.asset(
                            'assets/error_trip.png',
                          ),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Text('Sorry, we couldn\'t find a trip',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Please try again with a different configuration',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      )),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 84.0),
                    child: Material(
                      color: Theme.of(context).accentColor,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(8),
                      child: Center(
                        child: InkWell(
                          onTap: () =>
                              BlocProvider.of<BSNavigationBloc>(context)
                                  .add(BSNavigationTripCancelled()),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                                child: Text('Try Again',
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
                ],
              );
            } else if (state is RouteRequestLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 4,
                    width: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text('Trip Overview',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 1)),
                  const SizedBox(height: 18),
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
                              Text(
                                '${state.tripModel.price}',
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
                              Text(_formatDuration(
                                      (state.tripModel.durationTime / 60000)
                                          .round())
                                  /*_formatDuration(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            state.tripModel.durationTime)
                                        .minute),*/
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
                                  color: leafColor.leafColor(state
                                              .tripModel.sustainability >=
                                          80
                                      ? 3
                                      : state.tripModel.sustainability >= 70
                                          ? 2
                                          : state.tripModel.sustainability >= 60
                                              ? 1
                                              : 0),
                                  height: 24,
                                  width: 24),
                              const SizedBox(width: 8),
                              Text(
                                (state.tripModel.sustainability).toString() +
                                    '  %',
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.all(0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.tripModel.pois.length + 2,
                      itemBuilder: (context, index) => TimelineTile(
                        alignment: TimelineAlign.start,
                        isFirst: index == 0,
                        isLast: index == state.tripModel.pois.length + 2 - 1,
                        indicatorStyle: IndicatorStyle(
                            drawGap: true,
                            width: 12,
                            height: 12,
                            color: Theme.of(context).accentColor,
                            padding: EdgeInsets.only(right: 12),
                            indicatorXY: 0),
                        beforeLineStyle:
                            LineStyle(color: Colors.grey[200], thickness: 2),
                        endChild: Transform.translate(
                          offset: Offset(0, -4.5),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: index ==
                                          state.tripModel.pois.length + 2 - 1
                                      ? 0
                                      : 32),
                              child: index == 0 ||
                                      index ==
                                          state.tripModel.pois.length + 2 - 1
                                  ? TripOverviewLocationItem(
                                      location: index == 0
                                          ? state.tripModel.origin
                                          : state.tripModel.destination,
                                      origin: index == 0,
                                      time: index == 0
                                          ? state.tripModel.startTime
                                          : state.tripModel.endTime)
                                  : TripOverviewPOIItem(
                                      poi: state.tripModel.pois[index - 1])),
                        ),
                      ),
                    ),
                    //   itemBuilder: (context, index) => Padding(
                    //       padding: EdgeInsets.only(
                    //           top: 0,
                    //           bottom:
                    //               index != state.tripModel.pois.length + 2 - 1
                    //                   ? 12
                    //                   : 0),
                    //       child: index == 0
                    //           ? TripOverviewItem(
                    //               origin: state.tripModel.origin,
                    //               time: state.tripModel.startTime,
                    //             )
                    //           : index == state.tripModel.pois.length + 2 - 1
                    //               ? TripOverviewItem(
                    //                   destination: state.tripModel.destination,
                    //                   time: state.tripModel.endTime,
                    //                 )
                    //               : TripOverviewItem(
                    //                   poi: state.tripModel.pois[index - 1],
                    //                 )),
                    // ),
                  ),
                  const SizedBox(height: 32),
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
                              onTap: () =>
                                  BlocProvider.of<BSNavigationBloc>(context)
                                      .add(BSNavigationAdvanced()),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                    child: Text('CONFIRM',
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
              );
            } else
              return Text('error');
          },
        ),
      ),
    );
  }
}

_formatDuration(int duration) {
  if (duration < 60)
    return '$duration Minutes';
  else if (duration == 60)
    return '${(duration / 60).truncate()} Hour';
  else if (duration % 60 == 0)
    return '${(duration / 60).truncate()} Hours';
  else if (duration > 120)
    return '${(duration / 60).truncate()} H ${(duration % 60).toInt()} Min';
  else
    return '${(duration / 60).truncate()} H ${(duration % 60).toInt()} Min';
}

class TripOverviewPOIItem extends StatelessWidget {
  final TimedPointOfInterestModel poi;

  const TripOverviewPOIItem({Key key, @required this.poi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Text('${poi.poi.name}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        textBaseline: TextBaseline.alphabetic))),
            const SizedBox(width: 8),
            Text(
                _formatDatetoHourMinutes(
                    DateTime.fromMillisecondsSinceEpoch(poi.timestamp)),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(categories
                  .where((element) => element.id == poi.poi.categoryID)
                  .first
                  .name),
            ),
            const SizedBox(width: 8),
            Text('${poi.poi.visitTime} Min'),
          ],
        ),
      ],
    );
  }
}

class TripOverviewLocationItem extends StatelessWidget {
  final LocationModel location;
  final int time;
  final bool origin;

  const TripOverviewLocationItem(
      {Key key,
      @required this.location,
      @required this.time,
      @required this.origin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Text('${location.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600))),
            const SizedBox(width: 8),
            Text(
              _formatDatetoHourMinutes(
                  DateTime.fromMillisecondsSinceEpoch(time)),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(origin ? 'Departure' : 'Arrival'),
      ],
    );
  }
}

_formatDatetoHourMinutes(DateTime date) => Jiffy(date).format("HH:mm");

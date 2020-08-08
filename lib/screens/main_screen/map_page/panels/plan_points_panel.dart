import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/bs_navigation/bs_navigation_bloc.dart';
import 'package:living_city/data/models/location_model.dart';

class PlanPointsPanel extends StatelessWidget {
  final LocationModel origin;
  final LocationModel destination;

  const PlanPointsPanel(
      {Key key, @required this.origin, @required this.destination})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Start your trip',
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
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 1.5),
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
            height: 24,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, top: 2, bottom: 2),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).accentColor),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          child: Container(
                            width: 1,
                            color: Colors.orange,
                          ),
                          // child: CustomPaint(
                          //   painter: DashedLinePainter(
                          //     color: Colors.orange,
                          //     minHeight: 4,
                          //     minSpace: 4,
                          //     dashWidth: 1,
                          //   ),
                          // ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).accentColor),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    //makes text overflow work
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () =>
                              BlocProvider.of<BSNavigationBloc>(context)
                                  .add(BSNavigationPointSelected(true)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 42,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(
                              //   width: 1.5,
                              //   // color: Color(0xFFF0F0F0),
                              // ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                origin?.name ?? 'Select Origin',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: origin?.name != null
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          indent: 16,
                          height: 6,
                          endIndent: 16,
                        ),
                        GestureDetector(
                          onTap: () =>
                              BlocProvider.of<BSNavigationBloc>(context)
                                  .add(BSNavigationPointSelected(false)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 42,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(
                              //   width: 1.5,
                              //   color: Color(0xFFF0F0F0),
                              // ),
                            ),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  destination?.name ?? 'Select Destination',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: destination?.name != null
                                          ? Colors.black
                                          : Colors.grey),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                  color: Theme.of(context).accentColor.withOpacity(
                      (origin != null && destination != null) ? 1 : 0.6),
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: InkWell(
                      onTap: (origin != null && destination != null)
                          ? () => BlocProvider.of<BSNavigationBloc>(context)
                              .add(BSNavigationAdvanced())
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: Text('NEXT',
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
}

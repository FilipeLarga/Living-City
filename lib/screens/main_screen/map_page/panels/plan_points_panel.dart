import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/cupertino.dart';
import 'package:living_city/widgets/CustomDialog.dart';
import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../../data/models/location_model.dart';

class PlanPointsPanel extends StatelessWidget {
  final LocationModel origin;
  final LocationModel destination;
  final int date;

  const PlanPointsPanel(
      {Key key,
      @required this.origin,
      @required this.destination,
      @required this.date})
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Departure Date', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showDateDialog(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _formatDateComplete(DateTime.fromMillisecondsSinceEpoch(
                            date ??
                                DateTime.now()
                                    .millisecondsSinceEpoch /*date*/)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(
                        Icons.date_range,
                        color: Colors.grey[700],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Locations', style: TextStyle(fontSize: 14)),
              // const SizedBox(height: 8),
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
            ],
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
                        height: 42,
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

  _showDateDialog(BuildContext context) async {
    final date = await showDialog<DateTime>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: EdgeInsets.only(left: 40.0, right: 40, bottom: 124),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
            padding: const EdgeInsets.all(16), child: CustomDateDialog()),
      ),
    );
    if (date != null)
      BlocProvider.of<BSNavigationBloc>(context).add(
          BSNavigationDepartureTimeAdded(
              date: date.millisecondsSinceEpoch >
                      DateTime.now().millisecondsSinceEpoch
                  ? date.millisecondsSinceEpoch
                  : DateTime.now().millisecondsSinceEpoch));
  }
}

_formatDateComplete(DateTime date) => Jiffy(date).format("MMMM do, h:mm a");
_formatDateShort(DateTime date) => Jiffy(date).format("MMMM do");

class CustomDateDialog extends StatefulWidget {
  @override
  _CustomDateDialogState createState() => _CustomDateDialogState();
}

class _CustomDateDialogState extends State<CustomDateDialog> {
  PageController _controller = PageController(viewportFraction: 1);
  DateTime _initialDate;
  DateTime _selecteDate;

  final DateTime _minimumDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool _useInitial;

  @override
  void initState() {
    super.initState();
    _initialDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        ((DateTime.now().minute / 5).ceil() * 5));
    _selecteDate = _initialDate;
    _useInitial = true;
    _controller.addListener(() {
      _controller.addListener(() => setState(() {
            if (_controller.page.floor() == 0) {
              _useInitial = true;
              _selecteDate = _initialDate;
            } else {
              _useInitial = false;
              _selecteDate = _minimumDate;
            }
          }));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Date',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 32),
        Container(
          height: 256,
          child: CupertinoDatePicker(
            key: ValueKey(_useInitial),
            minuteInterval: 5,
            onDateTimeChanged: (date) => setState(() => _selecteDate = date),
            initialDateTime: _useInitial ? _initialDate : _minimumDate,
            minimumDate: _useInitial ? _initialDate : _minimumDate,
            maximumDate: _initialDate.add(const Duration(days: 5)),
            mode: CupertinoDatePickerMode.time,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left),
              color: Colors.grey[700],
              onPressed: () => _controller.page != 0
                  ? _controller.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linearToEaseOut)
                  : null,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  height: 56,
                  child: ListView.custom(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    physics: const PageScrollPhysics(),
                    itemExtent: constraints.maxWidth,
                    childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) => Center(
                          child: Text(
                              index == 0
                                  ? 'Today'
                                  : index == 1
                                      ? 'Tomorrow'
                                      : _formatDateShort(DateTime.now()
                                          .add(Duration(days: index))),
                              style: TextStyle(fontSize: 16))),
                      childCount: 6,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              color: Colors.grey[700],
              onPressed: () => _controller.page != 5
                  ? _controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linearToEaseOut)
                  : null,
            )
          ],
        ),
        const SizedBox(height: 48),
        Material(
          color: Theme.of(context).accentColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop(
                  context,
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now()
                        .add(Duration(days: _controller.page.floor()))
                        .day,
                    _selecteDate.hour,
                    _selecteDate.minute,
                  )),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 48,
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
      ],
    );
  }
}

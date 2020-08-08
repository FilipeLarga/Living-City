import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../../widgets/CustomDialog.dart';

class PlanRestrictionsPanel extends StatelessWidget {
  final int date;
  final int effort;
  final int budget;

  const PlanRestrictionsPanel({Key key, this.date, this.effort, this.budget})
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
              Text('Trip details',
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
            height: 24,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date', style: TextStyle(fontSize: 14)),
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
                        _formatDateComplete(
                            DateTime.fromMillisecondsSinceEpoch(date)),
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
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Effort', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showEffortDialog(context),
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
                              effort == 1
                                  ? 'Easy'
                                  : effort == 2 ? 'Medium' : 'Hard',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Icon(
                              Icons.landscape,
                              color: Colors.grey[700],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 28,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Budget', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onSubmitted: (string) {
                                BlocProvider.of<BSNavigationBloc>(context).add(
                                    BSNavigationRestrictionAdded(
                                        budget: int.tryParse(string) ?? 0));
                              },
                              maxLength: 3,
                              decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              controller: TextEditingController()
                                ..text = budget.toString(),
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Icon(
                            Icons.euro_symbol,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      onTap: () => BlocProvider.of<BSNavigationBloc>(context)
                          .add(BSNavigationAdvanced()),
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

  _showEffortDialog(BuildContext context) async {
    int selection = 0;
    if (Platform.isAndroid) {
      selection = await showModalBottomSheet<int>(
        context: context,
        isDismissible: false,
        isScrollControlled: false,
        enableDrag: false,
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text('Effort',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
                child: Text('Please select the effort best suited for you')),
            Divider(
              // indent: 16,
              // endIndent: 16,
              // color: Colors.black,
              color: Colors.grey[800],
            ),
            InkWell(
              onTap: () => Navigator.pop(context, 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Easy',
                  style: TextStyle(fontSize: 16),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context, 2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Medium',
                  style: TextStyle(fontSize: 16),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context, 3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hard',
                  style: TextStyle(fontSize: 16),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      selection = await showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text('Effort'),
          message: Text('Please select the effort best suited for you'),
          // message: ,
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Easy'),
              onPressed: () => Navigator.pop(context, 1),
            ),
            CupertinoActionSheetAction(
              child: const Text('Medium'),
              onPressed: () => Navigator.pop(context, 2),
            ),
            CupertinoActionSheetAction(
              child: const Text('Hard'),
              onPressed: () => Navigator.pop(context, 3),
            ),
          ],
        ),
      );
    }
    BlocProvider.of<BSNavigationBloc>(context)
        .add(BSNavigationRestrictionAdded(effort: selection));
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
          BSNavigationRestrictionAdded(
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
    print(_useInitial);
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

// class BudgetDialog extends StatefulWidget {
//   final int initial;

//   const BudgetDialog({Key key, @required this.initial}) : super(key: key);

//   @override
//   _BudgetDialogState createState() => _BudgetDialogState();
// }

// class _BudgetDialogState extends State<BudgetDialog> {
//   double value;
//   int selected;

//   @override
//   void initState() {
//     super.initState();
//     value = widget.initial.toDouble();
//   }

// @override
//   Widget build(BuildContext context) {
//     return CupertinoPicker(
//         onSelectedItemChanged: (selected) => setState(() => selected = selected),
//         itemExtent: 42,
//         children: [
//           Text
//         ],
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text('${value.toInt()} €'),
//         Slider.adaptive(
//           value: value,
//           onChanged: (v) => setState(() => value = v),
//           min: 0,
//           max: 200,
//         ),
//       ],
//     );
//   }
// }

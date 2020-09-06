// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
// import 'package:flutter/cupertino.dart';

// class CalendarPopupView extends StatefulWidget {
//   const CalendarPopupView(
//       {Key key,
//       this.onApplyClick,
//       this.onCancelClick,
//       this.barrierDismissible = true,
//       this.minimumDate,
//       this.maximumDate})
//       : super(key: key);

//   final DateTime minimumDate;
//   final DateTime maximumDate;
//   final bool barrierDismissible;
//   final Function(DateTime, DateTime) onApplyClick;
//   final Function onCancelClick;

//   @override
//   _CalendarPopupViewState createState() => _CalendarPopupViewState();
// }

// class _CalendarPopupViewState extends State<CalendarPopupView>
//     with TickerProviderStateMixin {
//   int _counter;
//   DateTime _departureDate;
//   DateTime _arrivalDate;
//   DateTime _tripDate;

//   @override
//   void initState() {
//     _counter = 0;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFFFFF),
//               borderRadius: const BorderRadius.all(Radius.circular(24.0)),
//               boxShadow: <BoxShadow>[
//                 BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     offset: const Offset(4, 4),
//                     blurRadius: 8.0),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Text(
//                             'Departure',
//                             textAlign: TextAlign.left,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w100,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             _counter > 0
//                                 ? DateFormat('HH:mm').format(_departureDate)
//                                 : '--/-- ',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: 74,
//                       width: 1,
//                       color: Theme.of(context).dividerColor,
//                     ),
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Text(
//                             'Arrival',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w100,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             _counter > 1
//                                 ? DateFormat('HH:mm').format(_arrivalDate)
//                                 : '--/-- ',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 const Divider(
//                   height: 1,
//                 ),
//                 _chooseWidget(),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 16, right: 16, bottom: 16, top: 16),
//                   child: Container(
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).accentColor,
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(24.0)),
//                       boxShadow: <BoxShadow>[
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.6),
//                           blurRadius: 8,
//                           offset: const Offset(4, 4),
//                         ),
//                       ],
//                     ),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(24.0)),
//                         highlightColor: Colors.transparent,
//                         onTap: () {
//                           if (_counter == 0) {
//                             _applyDeparture();
//                           } else if (_counter == 1) {
//                             _applyArrival();
//                           } else {
//                             _applyCalendar();
//                           }
//                           // try {
//                           //   setState(() {
//                           //     if (_counter >= 2) Navigator.pop(context);
//                           //     _counter++;
//                           //   });
//                           // } catch (_) {}
//                         },
//                         child: Center(
//                           child: Text(
//                             'Apply',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 18,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _applyDeparture() {
//     if (_departureDate == null || _departureDate.isBefore(DateTime.now())) {
//       setState(() {
//         _departureDate = DateTime.now();
//         _counter++;
//       });
//     } else {
//       setState(() {
//         _counter++;
//       });
//     }
//   }

//   _applyArrival() {
//     if (_arrivalDate == null) {
//       setState(() {
//         _arrivalDate = DateTime.now().add(Duration(hours: 1));
//         _counter++;
//       });
//     } else {
//       setState(() {
//         _counter++;
//       });
//     }
//   }

//   _applyCalendar() {
//     Navigator.pop(context);
//   }

//   _updateDepartureTime(DateTime date) {
//     setState(() {
//       _departureDate = date;
//     });
//   }

//   _updateArrivalTime(DateTime date) {
//     setState(() {
//       _arrivalDate = date;
//     });
//   }

//   Widget _chooseWidget() {
//     if (_counter == 0) {
//       return CustomTimePicker(
//         minTime: DateTime.now(),
//         onChanged: _updateDepartureTime,
//         title: 'Departure Time',
//         key: ValueKey(_counter),
//       );
//     } else if (_counter == 1) {
//       return CustomTimePicker(
//         onChanged: _updateArrivalTime,
//         key: ValueKey(_counter),
//         title: 'Arrival Time',
//         minTime: _departureDate.add(Duration(minutes: 55)),
//       );
//     } else {
//       return CustomCalendarView(
//         initialSelectedDate: DateTime.now(),
//       );
//     }
//   }
// }

// class CustomTimePicker extends StatefulWidget {
//   final String title;
//   final DateTime minTime;
//   final Function(DateTime) onChanged;

//   const CustomTimePicker(
//       {Key key,
//       @required this.title,
//       @required this.minTime,
//       @required this.onChanged})
//       : super(key: key);

//   @override
//   _CustomTimePickerState createState() => _CustomTimePickerState();
// }

// class _CustomTimePickerState extends State<CustomTimePicker> {
//   int _hourCount;
//   int _minuteCount;
//   bool _firstHour;
//   bool _lastHour;

//   FixedExtentScrollController _hourScrollCtrl;
//   FixedExtentScrollController _minuteScrollCtrl;

//   @override
//   void initState() {
//     _hourScrollCtrl = FixedExtentScrollController();
//     _minuteScrollCtrl = FixedExtentScrollController();
//     _lastHour = false;
//     _firstHour = true;
//     _determineHoursAndMinutes();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       var auxDate = DateTime.now();
//       widget.onChanged(DateTime(
//           auxDate.year,
//           auxDate.month,
//           auxDate.day,
//           24 - _hourCount + 0,
//           _firstHour
//               ? 60 - _minuteCount * 5 + 0 * 5
//               : _lastHour ? 0 : 60 - 12 * 5 + 0 * 5));
//     });

//     super.initState();
//   }

//   void _determineHoursAndMinutes() {
//     _firstHour = true;
//     if (widget.minTime.minute > 55) {
//       _hourCount = 24 - 1 - widget.minTime.hour;
//       _minuteCount = 12;
//     } else {
//       _hourCount = 24 - widget.minTime.hour;
//       _minuteCount = 0;
//       for (int i = widget.minTime.minute; i < 56; i++) {
//         if (i % 5 == 0) _minuteCount++;
//       }
//     }
//   }

//   int _chooseMinuteChildCount() {
//     return _firstHour ? _minuteCount : _lastHour ? 1 : 12;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         const SizedBox(height: 32),
//         Center(
//           child: Text(
//             '${widget.title}',
//             style: TextStyle(
//                 fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 48.0),
//           child: Container(
//             height: 210,
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: CupertinoPicker.builder(
//                       diameterRatio: 1.5,
//                       childCount: _hourCount,
//                       itemExtent: 36,
//                       scrollController: _hourScrollCtrl,
//                       squeeze: 1.3,
//                       backgroundColor: Colors.white,
//                       onSelectedItemChanged: (index) {
//                         if (index > 0) {
//                           setState(() {
//                             _firstHour = false;
//                             if (index == _hourCount - 1) {
//                               _lastHour = true;
//                               _minuteScrollCtrl.jumpToItem(0);
//                             } else {
//                               _lastHour = false;
//                               // _minuteScrollCtrl.jumpToItem(0);
//                             }
//                           });
//                         } else {
//                           setState(() {
//                             _firstHour = true;
//                             _lastHour = false;
//                           });
//                         }
//                         var auxDate = DateTime.now();

//                         widget.onChanged(DateTime(
//                             auxDate.year,
//                             auxDate.month,
//                             auxDate.day,
//                             24 - _hourCount + _hourScrollCtrl.selectedItem,
//                             _firstHour
//                                 ? 60 -
//                                     _minuteCount * 5 +
//                                     _minuteScrollCtrl.selectedItem * 5
//                                 : _lastHour
//                                     ? 0
//                                     : 60 -
//                                         12 * 5 +
//                                         _minuteScrollCtrl.selectedItem * 5));
//                       },
//                       itemBuilder: (context, index) {
//                         return Container(
//                           height: 36,
//                           alignment: Alignment.center,
//                           child: Row(
//                             children: <Widget>[
//                               new Expanded(
//                                   child: Text(
//                                 '${24 - _hourCount + index}',
//                                 style: TextStyle(
//                                     color: Theme.of(context).accentColor,
//                                     fontSize: 20),
//                                 textAlign: TextAlign.center,
//                                 softWrap: false,
//                                 overflow: TextOverflow.fade,
//                               ))
//                             ],
//                           ),
//                         );
//                       }),
//                 ),
//                 const SizedBox(width: 48),
//                 Expanded(
//                   child: CupertinoPicker.builder(
//                       key: ValueKey(_lastHour),
//                       diameterRatio: 1.5,
//                       scrollController: _minuteScrollCtrl,
//                       childCount: _chooseMinuteChildCount(),
//                       itemExtent: 36,
//                       squeeze: 1.3,
//                       backgroundColor: Colors.white,
//                       onSelectedItemChanged: (_) {
//                         var auxDate = DateTime.now();
//                         widget.onChanged(DateTime(
//                             auxDate.year,
//                             auxDate.month,
//                             auxDate.day,
//                             24 - _hourCount + _hourScrollCtrl.selectedItem,
//                             _firstHour
//                                 ? 60 -
//                                     _minuteCount * 5 +
//                                     _minuteScrollCtrl.selectedItem * 5
//                                 : _lastHour
//                                     ? 0
//                                     : 60 -
//                                         12 * 5 +
//                                         _minuteScrollCtrl.selectedItem * 5));
//                       },
//                       itemBuilder: (context, index) {
//                         return Container(
//                           height: 36,
//                           alignment: Alignment.center,
//                           child: Row(
//                             children: <Widget>[
//                               new Expanded(
//                                   child: Text(
//                                 _firstHour
//                                     ? '${60 - _minuteCount * 5 + index * 5}'
//                                     : _lastHour
//                                         ? '0'
//                                         : '${60 - 12 * 5 + index * 5}',
//                                 style: TextStyle(
//                                     color: Theme.of(context).accentColor,
//                                     fontSize: 20),
//                                 textAlign: TextAlign.center,
//                                 softWrap: false,
//                                 overflow: TextOverflow.fade,
//                               ))
//                             ],
//                           ),
//                         );
//                       }),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class CustomCalendarView extends StatefulWidget {
//   const CustomCalendarView({Key key, this.initialSelectedDate})
//       : super(key: key);

//   final DateTime initialSelectedDate;

//   @override
//   _CustomCalendarViewState createState() => _CustomCalendarViewState();
// }

// class _CustomCalendarViewState extends State<CustomCalendarView> {
//   List<DateTime> dateList = <DateTime>[];
//   DateTime currentMonthDate = DateTime.now();
//   DateTime selectedDate;

//   @override
//   void initState() {
//     selectedDate = widget.initialSelectedDate;
//     setListOfDate(currentMonthDate);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // Sets the days
//   void setListOfDate(DateTime monthDate) {
//     dateList.clear();
//     final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
//     int previousMothDay = 0;
//     if (newDate.weekday < 7) {
//       previousMothDay = newDate.weekday;
//       for (int i = 1; i <= previousMothDay; i++) {
//         dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
//       }
//     }
//     for (int i = 0; i < (42 - previousMothDay); i++) {
//       dateList.add(newDate.add(Duration(days: i + 1)));
//     }
//     // if (dateList[dateList.length - 7].month != monthDate.month) {
//     //   dateList.removeRange(dateList.length - 7, dateList.length);
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding:
//                 const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
//             child: Row(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(24.0)),
//                     ),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(24.0)),
//                         onTap: () {
//                           setState(() {
//                             currentMonthDate = DateTime(currentMonthDate.year,
//                                 currentMonthDate.month, 0);
//                             setListOfDate(currentMonthDate);
//                           });
//                         },
//                         child: Icon(
//                           Icons.keyboard_arrow_left,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       DateFormat('MMMM').format(currentMonthDate),
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: 38,
//                     width: 38,
//                     decoration: BoxDecoration(
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(24.0)),
//                     ),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(24.0)),
//                         onTap: () {
//                           setState(() {
//                             currentMonthDate = DateTime(currentMonthDate.year,
//                                 currentMonthDate.month + 2, 0);
//                             setListOfDate(currentMonthDate);
//                           });
//                         },
//                         child: Icon(
//                           Icons.keyboard_arrow_right,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 4),
//             child: Row(
//               children: getDaysNameUI(),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8, left: 8),
//             child: Column(
//               children: getDaysNoUI(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> getDaysNameUI() {
//     final List<Widget> listUI = <Widget>[];
//     for (int i = 0; i < 7; i++) {
//       listUI.add(
//         Expanded(
//           child: Center(
//             child: Text(
//               DateFormat('EEE').format(dateList[i]),
//               style:
//                   TextStyle(fontSize: 16, color: Theme.of(context).accentColor),
//             ),
//           ),
//         ),
//       );
//     }
//     return listUI;
//   }

//   List<Widget> getDaysNoUI() {
//     final List<Widget> noList = <Widget>[];
//     int count = 0;
//     //iterate every week
//     for (int i = 0; i < dateList.length / 7; i++) {
//       final List<Widget> listUI = <Widget>[];
//       //iterate every day of the week
//       for (int i = 0; i < 7; i++) {
//         final DateTime date = dateList[count];
//         listUI.add(
//           Expanded(
//             child: AspectRatio(
//               aspectRatio: 1.0,
//               child: Container(
//                 child: Stack(
//                   children: <Widget>[
//                     // Padding(
//                     //   padding: const EdgeInsets.only(top: 3, bottom: 3),
//                     //   child: Material(
//                     //     color: Colors.transparent,
//                     //     child: Padding(
//                     //       padding: EdgeInsets.only(
//                     //           top: 2,
//                     //           bottom: 2,
//                     //           left: getIsItSelectedDate(date) ? 4 : 0,
//                     //           right: getIsItSelectedDate(date) ? 4 : 0),
//                     //       child: Container(
//                     //         decoration: BoxDecoration(
//                     //           color:  getIsItStartAndEndDate(date)
//                     //                   ? Theme.of(context)
//                     //                       .accentColor
//                     //                       .withOpacity(0.4)
//                     //                   : Colors.transparent
//                     //               : Colors.transparent,
//                     //           borderRadius: BorderRadius.only(
//                     //             bottomLeft: isStartDateRadius(date)
//                     //                 ? const Radius.circular(24.0)
//                     //                 : const Radius.circular(0.0),
//                     //             topLeft: isStartDateRadius(date)
//                     //                 ? const Radius.circular(24.0)
//                     //                 : const Radius.circular(0.0),
//                     //             topRight: isEndDateRadius(date)
//                     //                 ? const Radius.circular(24.0)
//                     //                 : const Radius.circular(0.0),
//                     //             bottomRight: isEndDateRadius(date)
//                     //                 ? const Radius.circular(24.0)
//                     //                 : const Radius.circular(0.0),
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(32.0)),
//                         onTap: () {
//                           onDateClick(date);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(2),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: getIsItSelectedDate(date)
//                                   ? Theme.of(context).accentColor
//                                   : Colors.transparent,
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(32.0)),
//                               border: Border.all(
//                                 color: getIsItSelectedDate(date)
//                                     ? Colors.white
//                                     : Colors.transparent,
//                                 width: 3,
//                               ),
//                               boxShadow: getIsItSelectedDate(date)
//                                   ? <BoxShadow>[
//                                       BoxShadow(
//                                           color: Colors.grey.withOpacity(0.6),
//                                           blurRadius: 4,
//                                           offset: const Offset(0, 0)),
//                                     ]
//                                   : null,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '${date.day}',
//                                 style: TextStyle(
//                                     color: getIsItSelectedDate(date)
//                                         ? Colors.white
//                                         : isInValidRange(date)
//                                             ? Theme.of(context).accentColor
//                                             : Colors.grey.withOpacity(0.8),
//                                     fontSize: isInValidRange(date)
//                                         ? MediaQuery.of(context).size.width >
//                                                 360
//                                             ? 17
//                                             : 16
//                                         : 14,
//                                     fontWeight: getIsItSelectedDate(date)
//                                         ? FontWeight.bold
//                                         : FontWeight.normal),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 4,
//                       right: 0,
//                       left: 0,
//                       child: Container(
//                         height: 6,
//                         width: 6,
//                         decoration: BoxDecoration(
//                             color: DateTime.now().day == date.day &&
//                                     DateTime.now().month == date.month &&
//                                     DateTime.now().year == date.year &&
//                                     (DateTime.now().day != selectedDate.day ||
//                                         DateTime.now().month !=
//                                             selectedDate.month)
//                                 ? Theme.of(context).accentColor
//                                 : Colors.transparent,
//                             shape: BoxShape.circle),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//         count += 1;
//       }
//       noList.add(Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: listUI,
//       ));
//     }
//     return noList;
//   }

//   bool getIsItSelectedDate(DateTime date) {
//     if (selectedDate != null &&
//         selectedDate.day == date.day &&
//         selectedDate.month == date.month &&
//         selectedDate.year == date.year) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   // bool isStartDateRadius(DateTime date) {
//   //   if (selectedDate != null &&
//   //       selectedDate.day == date.day &&
//   //       selectedDate.month == date.month) {
//   //     return true;
//   //   } else if (date.weekday == 1) {
//   //     return true;
//   //   } else {
//   //     return false;
//   //   }
//   // }

//   // bool isEndDateRadius(DateTime date) {
//   //   if (endDate != null &&
//   //       endDate.day == date.day &&
//   //       endDate.month == date.month) {
//   //     return true;
//   //   } else if (date.weekday == 7) {
//   //     return true;
//   //   } else {
//   //     return false;
//   //   }
//   // }

//   bool isInValidRange(DateTime date) {
//     if ((date.isAfter(widget.initialSelectedDate) &&
//             date.isBefore(widget.initialSelectedDate.add(Duration(days: 6)))) ||
//         (date.day == widget.initialSelectedDate.day &&
//             date.month == widget.initialSelectedDate.month)) {
//       return true;
//     }
//     return false;
//   }

//   void onDateClick(DateTime date) {
//     if (isInValidRange(date)) {
//       setState(() {
//         selectedDate = date;
//       });
//     }
//   }
// }

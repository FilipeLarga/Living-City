// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:living_city/widgets/CustomCalendar.dart';

// class UserProfile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'Trip Settings',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.start,
//             ),
//             SizedBox(height: 32),
//             FlatButton(
//                 onPressed: () => showDialog<dynamic>(
//                       context: context,
//                       builder: (BuildContext context) => CalendarPopupView(
//                         barrierDismissible: true,
//                         minimumDate: DateTime.now(),
//                         maximumDate:
//                             DateTime.now().add(const Duration(days: 5)),
//                         onApplyClick: (DateTime startData, DateTime endData) {},
//                         onCancelClick: () {},
//                       ),
//                     ),
//                 child: Text('Here')),
//             DurationPicker(),
//             SizedBox(height: 24),
//             EffortPicker(),
//             SizedBox(height: 24),
//             InterestPicker(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DurationPicker extends StatefulWidget {
//   @override
//   _DurationPickerState createState() => _DurationPickerState();
// }

// class _DurationPickerState extends State<DurationPicker> {
//   var _selectedRange = RangeValues(4, 6);
//   bool _sameValues = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(.4),
//               blurRadius: 20.0, // soften the shadow
//               spreadRadius: 0.0,
//               offset: Offset(0, 1))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text('Duration Limit',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               )),
//           SizedBox(
//             height: 16,
//           ),
//           AnimatedSwitcher(
//               duration: Duration(milliseconds: 200),
//               transitionBuilder: (Widget child, Animation<double> animation) {
//                 if (child.key == ValueKey(_sameValues)) {
//                   final offsetAnimation = Tween<Offset>(
//                           begin: Offset(0.0, -0.1), end: Offset(0.0, 0.0))
//                       .animate(animation);
//                   return SlideTransition(
//                       position: offsetAnimation,
//                       child: FadeTransition(child: child, opacity: animation));
//                 } else {
//                   return Container();
//                 }
//               },
//               child: !_sameValues
//                   ? Row(
//                       key: ValueKey(false),
//                       crossAxisAlignment: CrossAxisAlignment.baseline,
//                       textBaseline: TextBaseline.alphabetic,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text('${_selectedRange.start.toInt()}',
//                             style: TextStyle(
//                                 color: Theme.of(context).accentColor,
//                                 fontSize: 26,
//                                 fontWeight: FontWeight.bold)),
//                         Text(' h',
//                             style: TextStyle(
//                                 color: Theme.of(context).accentColor,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold)),
//                         SizedBox(
//                           width: 16,
//                         ),
//                         Text('-',
//                             style: TextStyle(
//                                 color: Theme.of(context).accentColor,
//                                 fontSize: 26,
//                                 fontWeight: FontWeight.bold)),
//                         SizedBox(
//                           width: 16,
//                         ),
//                         Text('${_selectedRange.end.toInt()}',
//                             style: TextStyle(
//                                 color: Theme.of(context).accentColor,
//                                 fontSize: 26,
//                                 fontWeight: FontWeight.bold)),
//                         Text(' h',
//                             style: TextStyle(
//                                 color: Theme.of(context).accentColor,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold)),
//                       ],
//                     )
//                   : Row(
//                       key: ValueKey(true),
//                       crossAxisAlignment: CrossAxisAlignment.baseline,
//                       textBaseline: TextBaseline.alphabetic,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text('${_selectedRange.start.toInt()} ',
//                             style: TextStyle(
//                                 color: Theme.of(context).accentColor,
//                                 fontSize: 26,
//                                 fontWeight: FontWeight.bold)),
//                         Text(
//                             _selectedRange.start.toInt() == 1
//                                 ? 'Hour'
//                                 : 'Hours',
//                             style: TextStyle(
//                                 color: Theme.of(context).accentColor,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold)),
//                       ],
//                     )),
//           SizedBox(
//             height: 8,
//           ),
//           RangeSlider(
//             activeColor: Theme.of(context).accentColor,
//             values: _selectedRange,
//             onChanged: (RangeValues newRange) {
//               setState(() {
//                 _selectedRange = newRange;
//                 _sameValues = newRange.start == newRange.end;
//               });
//             },
//             divisions: 9,
//             min: 1,
//             max: 10,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class EffortPicker extends StatefulWidget {
//   @override
//   _EffortPickerState createState() => _EffortPickerState();
// }

// class _EffortPickerState extends State<EffortPicker>
//     with SingleTickerProviderStateMixin {
//   int effortLevel = 1;
//   String effortString = 'Easy';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(.4),
//               blurRadius: 20.0, // soften the shadow
//               spreadRadius: 0.0,
//               offset: Offset(0, 1))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text('Effort Level',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               )),
//           SizedBox(height: 16),
//           Center(
//             child: AnimatedSwitcher(
//               duration: Duration(milliseconds: 200),
//               transitionBuilder: (Widget child, Animation<double> animation) {
//                 if (child.key == ValueKey(effortString)) {
//                   final offsetAnimation = Tween<Offset>(
//                           begin: Offset(0.0, -0.1), end: Offset(0.0, 0.0))
//                       .animate(animation);
//                   return SlideTransition(
//                       position: offsetAnimation,
//                       child: FadeTransition(child: child, opacity: animation));
//                 } else {
//                   return Container();
//                 }
//               },
//               child: Text(effortString,
//                   key: ValueKey<String>(effortString),
//                   style: TextStyle(
//                       color: Theme.of(context).accentColor,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold)),
//             ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: EffortSlider(
//               onChanged: (int newValue) {
//                 setState(() {
//                   effortLevel = newValue;
//                   if (newValue == 1)
//                     effortString = "Easy";
//                   else if (newValue == 2)
//                     effortString = "Moderate";
//                   else
//                     effortString = "Hard";
//                 });
//               },
//               selection: effortLevel,
//               unselectedColor:
//                   Theme.of(context).colorScheme.primary.withOpacity(0.24),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class EffortSlider extends StatelessWidget {
//   final ValueChanged<int> onChanged;
//   final int selection;
//   final Color unselectedColor;

//   const EffortSlider(
//       {Key key,
//       @required this.onChanged,
//       @required this.selection,
//       @required this.unselectedColor})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Expanded(
//           child: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               if (selection != 1) onChanged(1);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Container(
//                 height: 18,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).accentColor,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: const Radius.circular(24),
//                     bottomLeft: const Radius.circular(24),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               if (selection != 2) onChanged(2);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 170),
//                 height: 18,
//                 decoration: BoxDecoration(
//                   color: selection >= 2
//                       ? Theme.of(context).accentColor
//                       : unselectedColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               if (selection != 3) onChanged(3);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 170),
//                 height: 18,
//                 decoration: BoxDecoration(
//                     color: selection >= 3
//                         ? Theme.of(context).accentColor
//                         : unselectedColor,
//                     borderRadius: const BorderRadius.only(
//                       topRight: const Radius.circular(24),
//                       bottomRight: const Radius.circular(24),
//                     )),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // class EffortSelectionOld extends StatefulWidget {
// //   final ValueChanged<int> onChanged;

// //   const EffortSelectionOld({
// //     Key key,
// //     @required this.onChanged,
// //   }) : super(key: key);

// //   @override
// //   _EffortSelectionOldState createState() => _EffortSelectionOldState();
// // }

// // class _EffortSelectionOldState extends State<EffortSelectionOld> {
// //   int _selection;
// //   var _unselectedColor;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.max,
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: <Widget>[
// //         Expanded(
// //           child: InkWell(
// //             onTap: () {},
// //             child: Container(
// //               height: 18,
// //               decoration: BoxDecoration(
// //                 color: Theme.of(context).accentColor,
// //                 borderRadius: const BorderRadius.only(
// //                   topLeft: const Radius.circular(24),
// //                   bottomLeft: const Radius.circular(24),
// //                 ),
// //                 boxShadow: const <BoxShadow>[
// //                   const BoxShadow(
// //                       offset: Offset(0.0, 2.0),
// //                       blurRadius: 1.0,
// //                       spreadRadius: -1.0,
// //                       color: Color(0x33000000)),
// //                   const BoxShadow(
// //                       offset: Offset(0.0, 1.0),
// //                       blurRadius: 1.0,
// //                       spreadRadius: 0.0,
// //                       color: Color(0x24000000)),
// //                   const BoxShadow(
// //                       offset: Offset(0.0, 1.0),
// //                       blurRadius: 3.0,
// //                       spreadRadius: 0.0,
// //                       color: Color(0x1F000000)),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(
// //           width: 8,
// //         ),
// //         Expanded(
// //           child: InkWell(
// //             onTap: () {
// //               if (_selection != 2) {
// //                 setState(() => _selection = 2);
// //               }
// //             },
// //             child: AnimatedContainer(
// //               duration: Duration(milliseconds: 170),
// //               height: 18,
// //               decoration: BoxDecoration(
// //                 color: _selection >= 2
// //                     ? Theme.of(context).accentColor
// //                     : _unselectedColor,
// //                 boxShadow: _selection < 2
// //                     ? const <BoxShadow>[]
// //                     : const <BoxShadow>[
// //                         const BoxShadow(
// //                             offset: Offset(0.0, 2.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: -1.0,
// //                             color: Color(0x33000000)),
// //                         const BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x24000000)),
// //                         const BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 3.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x1F000000)),
// //                       ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(
// //           width: 8,
// //         ),
// //         Expanded(
// //           child: InkWell(
// //             onTap: () {
// //               if (_selection != 3) {
// //                 setState(() => _selection = 3);
// //               }
// //             },
// //             child: AnimatedContainer(
// //               duration: Duration(milliseconds: 170),
// //               height: 18,
// //               decoration: BoxDecoration(
// //                 color: _selection >= 3
// //                     ? Theme.of(context).accentColor
// //                     : _unselectedColor,
// //                 boxShadow: _selection < 3
// //                     ? const <BoxShadow>[]
// //                     : const <BoxShadow>[
// //                         const BoxShadow(
// //                             offset: Offset(0.0, 2.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: -1.0,
// //                             color: Color(0x33000000)),
// //                         const BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x24000000)),
// //                         const BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 3.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x1F000000)),
// //                       ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(
// //           width: 8,
// //         ),
// //         Expanded(
// //           child: InkWell(
// //             onTap: () {
// //               if (_selection != 4) {
// //                 setState(() => _selection = 4);
// //               }
// //             },
// //             child: AnimatedContainer(
// //               duration: Duration(milliseconds: 170),
// //               height: 18,
// //               decoration: BoxDecoration(
// //                 color: _selection >= 4
// //                     ? Theme.of(context).accentColor
// //                     : _unselectedColor,
// //                 boxShadow: _selection < 4
// //                     ? const <BoxShadow>[]
// //                     : const <BoxShadow>[
// //                         BoxShadow(
// //                             offset: Offset(0.0, 2.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: -1.0,
// //                             color: Color(0x33000000)),
// //                         BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x24000000)),
// //                         BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 3.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x1F000000)),
// //                       ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(
// //           width: 8,
// //         ),
// //         Expanded(
// //           child: InkWell(
// //             onTap: () {
// //               if (_selection != 5) {
// //                 setState(() => _selection = 5);
// //               }
// //             },
// //             child: AnimatedContainer(
// //               duration: Duration(milliseconds: 170),
// //               height: 18,
// //               decoration: BoxDecoration(
// //                 color: _selection >= 5
// //                     ? Theme.of(context).accentColor
// //                     : _unselectedColor,
// //                 borderRadius: BorderRadius.only(
// //                   topRight: Radius.circular(24),
// //                   bottomRight: Radius.circular(24),
// //                 ),
// //                 boxShadow: _selection < 5
// //                     ? const <BoxShadow>[]
// //                     : const <BoxShadow>[
// //                         BoxShadow(
// //                             offset: Offset(0.0, 2.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: -1.0,
// //                             color: Color(0x33000000)),
// //                         BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 1.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x24000000)),
// //                         BoxShadow(
// //                             offset: Offset(0.0, 1.0),
// //                             blurRadius: 3.0,
// //                             spreadRadius: 0.0,
// //                             color: Color(0x1F000000)),
// //                       ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// class InterestPicker extends StatefulWidget {
//   @override
//   _InterestPickerState createState() => _InterestPickerState();
// }

// class _InterestPickerState extends State<InterestPicker> {
//   int count = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(.4),
//               blurRadius: 20.0, // soften the shadow
//               spreadRadius: 0.0,
//               offset: Offset(0, 1))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             textBaseline: TextBaseline.alphabetic,
//             crossAxisAlignment: CrossAxisAlignment.baseline,
//             children: <Widget>[
//               Text('Interests ',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   )),
//               Text('($count/8)',
//                   style: TextStyle(
//                     fontSize: 16,
//                   )),
//               Expanded(child: Container()),
//               Text('Select All',
//                   style: TextStyle(
//                       fontSize: 14, color: Theme.of(context).accentColor)),
//               SizedBox(width: 8),
//             ],
//           ),
//           SizedBox(
//             height: 16,
//           ),
//           // Row(
//           //   mainAxisSize: MainAxisSize.max,
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: <Widget>[
//           //     InterestItem(
//           //       backgroundColor: Color(0xFFE7F8FD),
//           //       imgName: 'church_icon',
//           //       name: 'Churches',
//           //     ),
//           //     InterestItem(
//           //       backgroundColor: Color(0xFFFAEDDE),
//           //       imgName: 'local_store_icon',
//           //       name: 'Local Stores',
//           //     ),
//           //     InterestItem(
//           //       backgroundColor: Color(0xFFe6fae6),
//           //       imgName: 'monument_icon',
//           //       name: 'Monuments',
//           //     ),
//           //   ],
//           // ),
//           // SizedBox(
//           //   height: 24,
//           // ),
//           // Row(
//           //   mainAxisSize: MainAxisSize.max,
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: <Widget>[
//           //     Expanded(
//           //       child: InterestItem(
//           //         backgroundColor: Color(0xFFf7e3f4),
//           //         imgName: 'tasquinha_icon',
//           //         name: 'Tasquinhas',
//           //       ),
//           //     ),
//           //     SizedBox(
//           //       width: 32,
//           //     ),
//           //     Expanded(
//           //       child: InterestItem(
//           //         backgroundColor: Color(0xFFE7F8FD),
//           //         imgName: 'restaurant_icon',
//           //         name: 'Restaurants',
//           //       ),
//           //     ),
//           //     SizedBox(
//           //       width: 32,
//           //     ),
//           //     Expanded(
//           //       child: InterestItem(
//           //         backgroundColor: Color(0xFFf7e3f4),
//           //         imgName: 'museum_icon',
//           //         name: 'Museums',
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           ListView(
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             children: <Widget>[
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'church_icon',
//                 name: 'Churches',
//               ),
//               SizedBox(height: 16),
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'local_store_icon',
//                 name: 'Local Stores',
//               ),
//               SizedBox(height: 16),
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'monument_icon',
//                 name: 'Monuments',
//               ),
//               SizedBox(height: 16),
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'tasquinha_icon',
//                 name: 'Tasquinhas',
//               ),
//               SizedBox(height: 16),
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'restaurant_icon',
//                 name: 'Restaurants',
//               ),
//               SizedBox(height: 16),
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'museum_icon',
//                 name: 'Museums',
//               ),
//               SizedBox(height: 16),
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'viewpoint_icon',
//                 name: 'Viewpoints',
//               ),
//               SizedBox(height: 16),
//               InterestItem(
//                 onChanged: (bool changed) {
//                   setState(() {
//                     if (changed)
//                       count++;
//                     else
//                       count--;
//                   });
//                 },
//                 imgName: 'museum_icon',
//                 name: 'Museums',
//               ),
//             ],
//           ),
//           // GridView.count(
//           //   physics: NeverScrollableScrollPhysics(),
//           //   crossAxisCount: 3,
//           //   shrinkWrap: true,
//           //   children: <Widget>[
//           // InterestItem(
//           //   backgroundColor: Color(0xFFE7F8FD),
//           //   imgName: 'church_icon',
//           //   name: 'Churches',
//           // ),
//           // InterestItem(
//           //   backgroundColor: Color(0xFFFAEDDE),
//           //   imgName: 'local_store_icon',
//           //   name: 'Local Stores',
//           // ),
//           // InterestItem(
//           //   backgroundColor: Color(0xFFe6fae6),
//           //   imgName: 'monument_icon',
//           //   name: 'Monuments',
//           // ),
//           // InterestItem(
//           //   backgroundColor: Color(0xFFf7e3f4),
//           //   imgName: 'tasquinha_icon',
//           //   name: 'Tasquinhas',
//           // ),
//           // InterestItem(
//           //   backgroundColor: Color(0xFFE7F8FD),
//           //   imgName: 'restaurant_icon',
//           //   name: 'Restaurants',
//           // ),
//           // InterestItem(
//           //   backgroundColor: Color(0xFFf7e3f4),
//           //   imgName: 'museum_icon',
//           //   name: 'Museums',
//           // ),
//           // InterestItem(
//           //   backgroundColor: Color(0xFFE7F8FD),
//           //   imgName: 'viewpoint_icon',
//           //   name: 'Viewpoints',
//           // ),
//           // InterestItem(
//           //   backgroundColor: Color(0xFFe6fae6),
//           //   imgName: 'museum_icon',
//           //   name: 'Museums',
//           // ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class InterestItem extends StatefulWidget {
//   final String name;
//   final String imgName;
//   final ValueChanged<bool> onChanged;
//   // final Color backgroundColor;

//   const InterestItem(
//       {Key key,
//       @required this.name,
//       @required this.imgName,
//       @required this.onChanged})
//       : super(key: key);

//   @override
//   _InterestItemState createState() => _InterestItemState();
// }

// class _InterestItemState extends State<InterestItem>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   Animation _animation;
//   bool selected = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: 400),
//         reverseDuration: Duration(milliseconds: 250));
//     _animation = CurvedAnimation(
//         parent: _controller,
//         curve: Curves.elasticOut,
//         reverseCurve: Curves.fastOutSlowIn);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         selected = !selected;
//         widget.onChanged(selected);
//         if (_controller.isCompleted || _controller.isAnimating) {
//           _controller.reverse();
//         } else {
//           _controller.forward();
//         }
//       },
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Stack(
//             overflow: Overflow.visible,
//             alignment: Alignment.center,
//             children: <Widget>[
//               Container(
//                 height: 64,
//                 width: 64,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFE7F8FD),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               Image.asset(
//                 'assets/category_icons/${widget.imgName}.png',
//                 height: 48,
//                 width: 48,
//               ),
//               Positioned(
//                 bottom: -6,
//                 right: -6,
//                 child: ScaleTransition(
//                   scale: _animation,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Icon(
//                       Icons.check_circle,
//                       color: Theme.of(context).accentColor,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             width: 24,
//           ),
//           Text(
//             widget.name,
//             style: TextStyle(fontSize: 14),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class UnitPicker extends StatefulWidget {
//   @override
//   _UnitPickerState createState() => _UnitPickerState();
// }

// class _UnitPickerState extends State<UnitPicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text('Unit',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF454357))),
//           Spacer(),
//           Text(
//             'Miles',
//             textAlign: TextAlign.center,
//             style:
//                 TextStyle(fontSize: 14, color: Theme.of(context).accentColor),
//           ),
//           SizedBox(
//             width: 16,
//           ),
//           Icon(
//             Icons.chevron_right,
//             color: Theme.of(context).accentColor,
//           )
//         ],
//       ),
//     );
//   }
// }

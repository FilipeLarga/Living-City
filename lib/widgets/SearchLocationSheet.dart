import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_location_bloc/bloc.dart';
import '../data/models/search_location_model.dart';

class SearchLocationSheet extends StatefulWidget {
  final SearchLocationModel searchLocation;
  final AnimationController animationController;

  const SearchLocationSheet({
    Key key,
    @required this.animationController,
    this.searchLocation,
  }) : super(key: key);

  @override
  _SearchLocationSheetState createState() => _SearchLocationSheetState();
}

class _SearchLocationSheetState extends State<SearchLocationSheet> {
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(widget.animationController);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 32,
          left: 12,
          right: 12,
        ),
        child: Theme(
          data: Theme.of(context)
              .copyWith(highlightColor: Theme.of(context).primaryColorLight),
          child: FloatingActionButton.extended(
            onPressed: _acceptTrip,
            backgroundColor: Colors.white,
            icon: Icon(Icons.gesture, color: Theme.of(context).accentColor),
            elevation: 4,
            splashColor: Theme.of(context).primaryColorLight,
            highlightElevation: 6,
            label: Text(
              'Plan Trip',
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  _acceptTrip() {
    BlocProvider.of<SearchLocationBloc>(context).add(AcceptLocationEvent());
  }
}

// class _SuccessOptions extends StatelessWidget {
//   final Function() acceptTrip;

//   const _SuccessOptions({Key key, this.acceptTrip}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context)
//           .copyWith(highlightColor: Theme.of(context).primaryColorLight),
//       child: FloatingActionButton.extended(
//         onPressed: acceptTrip,
//         backgroundColor: Colors.white,
//         icon: Icon(Icons.gesture, color: Theme.of(context).accentColor),
//         elevation: 4,
//         splashColor: Theme.of(context).primaryColorLight,
//         highlightElevation: 6,
//         label: Text(
//           'Plan Trip',
//           style: TextStyle(
//               color: Theme.of(context).accentColor,
//               fontSize: 16,
//               fontWeight: FontWeight.w700),
//         ),
//       ),
//     );
//   }
// }

// class _ErrorMessage extends StatelessWidget {
//   final Exception exception;

//   const _ErrorMessage({Key key, this.exception}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
//       decoration: const BoxDecoration(
//         borderRadius: const BorderRadius.all(const Radius.circular(8)),
//         color: Colors.white,
//         boxShadow: const <BoxShadow>[
//           const BoxShadow(
//               offset: const Offset(0.0, 3.0),
//               blurRadius: 1.0,
//               spreadRadius: -2.0,
//               color: const Color(0x33000000)),
//           const BoxShadow(
//               offset: const Offset(0.0, 2.0),
//               blurRadius: 2.0,
//               spreadRadius: 0.0,
//               color: const Color(0x24000000)),
//           const BoxShadow(
//               offset: const Offset(0.0, 1.0),
//               blurRadius: 5.0,
//               spreadRadius: 0.0,
//               color: const Color(0x1F000000)),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             'Something Went Wrong!',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           _chooseWidget(),
//         ],
//       ),
//     );
//   }

//   Widget _chooseWidget() {
//     if (exception is OutOfBoundsException) {
//       return Text(
//         'This Location is Out Of Bounds',
//         style: TextStyle(
//             color: Colors.red, fontStyle: FontStyle.normal, fontSize: 15),
//       );
//     } else if (exception is NoConnectionException) {
//       return Text(
//         'Please check your internet connection',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             color: Colors.red, fontStyle: FontStyle.normal, fontSize: 15),
//       );
//     } else
//       return Container();
//   }
// }

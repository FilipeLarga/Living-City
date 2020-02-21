import 'package:flutter/material.dart';
import '../bloc/route_selection_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectOnMapBar extends StatelessWidget {
  final String locationTitle;

  const SelectOnMapBar({Key key, this.locationTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 18,
          right: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: TextField(
                controller: _createTextFieldController(),
                readOnly: true,
                autofocus: false,
                textCapitalization: TextCapitalization.words,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintMaxLines: 1,
                  hintText: 'Select on Map',
                  border: InputBorder.none,
                ),
              ),
            ),
            _confirmButton(context),
            SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<RouteSelectionBloc>(context)
                      .add(CancelSelectOnMapRequest());
                },
                child: Text('CANCEL',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                        letterSpacing: 0.6)),
              ),
            ),
            // const SizedBox(
            //   width: 22,
            // ),
            // GestureDetector(
            //   child: const Icon(Icons.my_location, color: Colors.black87),
            //   onTap: () {
            //     BlocProvider.of<SearchLocationBloc>(context)
            //         .add(SearchUserLocationRequestEvent());
            //   },
            // ),
          ],
        ));
  }

  Widget _confirmButton(BuildContext context) {
    if (_shouldDisplayOkButton())
      return GestureDetector(
        onTap: () {
          BlocProvider.of<RouteSelectionBloc>(context)
              .add(ConfirmSelectOnMapRequest());
        },
        child: Text('OK',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
                letterSpacing: 0.6)),
      );
    else
      return const SizedBox(width: 0, height: 0);
  }

  bool _shouldDisplayOkButton() {
    return (locationTitle != null && locationTitle.isNotEmpty);
  }

  TextEditingController _createTextFieldController() {
    if (_shouldDisplayOkButton())
      return TextEditingController(
        text: locationTitle,
      );
    else {
      return TextEditingController();
    }
  }
}

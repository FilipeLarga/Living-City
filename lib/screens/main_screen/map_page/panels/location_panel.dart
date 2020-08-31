import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../../bloc/location/location_bloc.dart';
import '../../../../data/models/location_model.dart';

class LocationPanel extends StatefulWidget {
  final String address;
  final LatLng coordinates;
  final LocationModel locationModel;

  const LocationPanel({
    Key key,
    this.address,
    this.coordinates,
    this.locationModel,
  }) : super(key: key);

  @override
  _LocationPanelState createState() => _LocationPanelState();
}

class _LocationPanelState extends State<LocationPanel> {
  LocationModel location;
  bool origin;

  @override
  void initState() {
    super.initState();
    print('initState');

    origin = (BlocProvider.of<BSNavigationBloc>(context).state
            as BSNavigationShowingLocation)
        .origin;

    // This warnings are just false-positives.
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final needsLoading = widget.locationModel == null;

    if (needsLoading /* && !(locationBloc.state is LocationLoading)*/) {
      locationBloc.add(LoadLocation(
          address: widget.address, coordinates: widget.coordinates));
    } else {
      locationBloc.add(ShowPreLoadedLocation(location: widget.locationModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(origin ? 'Origin' : 'Destination'),
                const SizedBox(height: 4),
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    if (state is LocationLoading || state is LocationInactive) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 64.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            color: Colors.white,
                            height: 25,
                            width: double.infinity,
                          ),
                        ),
                      );
                    } else if (state is LocationError) {
                      return Text('error');
                    } else {
                      location = (state as LocationLoaded).location;
                      return Text(
                        location.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
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
                        onTap: () => location != null
                            ? BlocProvider.of<BSNavigationBloc>(context).add(
                                BSNavigationLocationAccepted(location,
                                    origin: origin))
                            : null,
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
                                      fontSize: 15))),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<LocationBloc, LocationState>(
  //     builder: (context, state) {
  //       if (state is LocationLoading || state is LocationInactive) {
  //         return Column(
  //           children: <Widget>[
  //             Text('loading'),
  //           ],
  //         );
  //       } else if (state is LocationError) {
  //         return Text('error');
  //       } else {
  //         final location = (state as LocationLoaded).location;
  //         return Column(
  //           mainAxisSize: MainAxisSize.max,
  //           children: <Widget>[
  //             Container(
  //               color: Colors.blue,
  //               child: Column(
  //                 children: <Widget>[
  //                   Text(location.name + location.locality),
  //                   Wrap(
  //                     children: <Widget>[
  //                       Container(
  //                         child: Text('LocationPanel'),
  //                       ),
  //                       MaterialButton(
  //                         onPressed: () =>
  //                             BlocProvider.of<BSNavigationBloc>(context)
  //                                 .add(BSNavigationCanceled()),
  //                         child: Text('Cancel'),
  //                       ),
  //                       MaterialButton(
  //                         onPressed: () =>
  //                             BlocProvider.of<BSNavigationBloc>(context).add(
  //                                 BSNavigationLocationAccepted(location,
  //                                     origin: true)),
  //                         child: Text('Accept Origin'),
  //                       ),
  //                       MaterialButton(
  //                         onPressed: () =>
  //                             BlocProvider.of<BSNavigationBloc>(context).add(
  //                                 BSNavigationLocationAccepted(location,
  //                                     origin: false)),
  //                         child: Text('Accept Destination'),
  //                       )
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }
}

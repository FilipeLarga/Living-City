import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:living_city/bloc/bs_navigation/bs_navigation_bloc.dart';
import 'package:living_city/bloc/route_request/route_request_bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';
import 'package:http/http.dart' as http;
import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/data/models/trip_plan_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong/latlong.dart';
import 'package:living_city/core/example_data.dart' as example;
import 'package:living_city/dependency_injection/injection_container.dart'
    as di;

class MockClient extends Mock implements http.Client {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init(); //dependencies injection

  group('BSNavigationBloc', () {
    BSNavigationBloc _bsNavigationBloc;

    setUp(() {
      _bsNavigationBloc = BSNavigationBloc(di.sl(), di.sl());
    });

    test('Initial state is BSNavigationPlanningPoints', () {
      expect(_bsNavigationBloc.state, const BSNavigationPlanningPoints());
    });

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test the process of adding an origin location',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationPointSelected(true))
        ..add(BSNavigationLocationSelected(coordinates: LatLng(1, 2)))
        ..add(BSNavigationLocationAccepted(LocationModel(LatLng(1, 2)),
            origin: true)),
      expect: [
        isA<BSNavigationSelectingLocation>(),
        isA<BSNavigationShowingLocation>(),
        isA<BSNavigationPlanningPoints>(),
      ],
      verify: (cubit) {
        final LocationModel origin =
            (cubit.state as BSNavigationPlanningPoints).origin;
        expect(origin.coordinates.latitude, 1);
        expect(origin.coordinates.longitude, 2);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test the process of adding destination location',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationPointSelected(false))
        ..add(BSNavigationLocationSelected(coordinates: LatLng(1, 2)))
        ..add(BSNavigationLocationAccepted(LocationModel(LatLng(1, 2)),
            origin: true)),
      expect: [
        isA<BSNavigationSelectingLocation>(),
        isA<BSNavigationShowingLocation>(),
        isA<BSNavigationPlanningPoints>(),
      ],
      verify: (cubit) {
        final LocationModel origin =
            (cubit.state as BSNavigationPlanningPoints).origin;
        expect(origin.coordinates.latitude, 1);
        expect(origin.coordinates.longitude, 2);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test advancing from the Start Trip panel to the Interests panel',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit..add(BSNavigationAdvanced()),
      expect: [
        isA<BSNavigationPlanningInterests>(),
      ],
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test going back to the Start Trip panel from the Interests panel',
      build: () => _bsNavigationBloc,
      act: (cubit) =>
          cubit..add(BSNavigationAdvanced())..add(BSNavigationCanceled()),
      skip: 1,
      expect: [
        isA<BSNavigationPlanningPoints>(),
      ],
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test adding POIs to the list of interests.',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationInterestAdded(
            pois: [example.pois[0], example.pois[1]])),
      skip: 1,
      expect: [
        isA<BSNavigationPlanningInterests>(),
      ],
      verify: (cubit) {
        final state = (cubit.state as BSNavigationPlanningInterests);
        expect(state.pois.elementAt(0).id, example.pois[0].id);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test the calculation of the total price of the POIs',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationInterestAdded(
            pois: [example.pois[0], example.pois[1]])),
      verify: (cubit) {
        final state = (cubit.state as BSNavigationPlanningInterests);
        expect(
            List<PointOfInterestModel>.from(state.pois).fold<double>(
                0.0, (previousValue, element) => previousValue + element.price),
            example.pois[0].price + example.pois[1].price);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test the calculation of the total visit time of the POIs',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationInterestAdded(
            pois: [example.pois[0], example.pois[1]])),
      verify: (cubit) {
        final state = (cubit.state as BSNavigationPlanningInterests);
        expect(
            List<PointOfInterestModel>.from(state.pois).fold<double>(
                    0.0,
                    (previousValue, element) =>
                        previousValue + element.sustainability) /
                2,
            (example.pois[0].sustainability + example.pois[1].sustainability) /
                2);
      },
    );
    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test the calculation of the average sustainability of the POIs',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationInterestAdded(
            pois: [example.pois[0], example.pois[1]])),
      verify: (cubit) {
        final state = (cubit.state as BSNavigationPlanningInterests);
        expect(
            List<PointOfInterestModel>.from(state.pois).fold(0,
                (previousValue, element) => previousValue + element.visitTime),
            example.pois[0].visitTime + example.pois[1].visitTime);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test advancing from the Interests panel to the Restrictions panel',
      build: () => _bsNavigationBloc,
      act: (cubit) =>
          cubit..add(BSNavigationAdvanced())..add(BSNavigationAdvanced()),
      skip: 1,
      expect: [
        isA<BSNavigationPlanningRestrictions>(),
      ],
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test going back to the Interests panel from the Restrictions panel',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationCanceled()),
      skip: 2,
      expect: [
        isA<BSNavigationPlanningInterests>(),
      ],
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test changing budget restriction',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationRestrictionAdded(budget: 100)),
      skip: 2,
      expect: [
        isA<BSNavigationPlanningRestrictions>(),
      ],
      verify: (cubit) {
        expect((cubit.state as BSNavigationPlanningRestrictions).budget, 100);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test changing visitation time restriction',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationRestrictionAdded(visitTime: 360)),
      skip: 2,
      expect: [
        isA<BSNavigationPlanningRestrictions>(),
      ],
      verify: (cubit) {
        expect(
            (cubit.state as BSNavigationPlanningRestrictions).visitTime, 360);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test changing effort restriction',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationRestrictionAdded(effort: 2)),
      skip: 2,
      expect: [
        isA<BSNavigationPlanningRestrictions>(),
      ],
      verify: (cubit) {
        expect((cubit.state as BSNavigationPlanningRestrictions).effort, 2);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test creating a trip from a specific location, to another specific location, with two POIs added as interests, with a high effort level, 100 euros as budget and 2 hours as visitation time',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationPointSelected(true))
        ..add(BSNavigationLocationSelected(
            coordinates: LatLng(38.7139092, -9.1334762)))
        ..add(BSNavigationLocationAccepted(
            LocationModel(LatLng(38.7139092, -9.1334762),
                name: 'Rua Alexandre Ferreira'),
            origin: true))
        ..add(BSNavigationPointSelected(false))
        ..add(BSNavigationLocationSelected(
            coordinates: LatLng(38.70861933474137, -9.140110592695562)))
        ..add(BSNavigationLocationAccepted(
            LocationModel(LatLng(38.70861933474137, -9.140110592695562),
                name: 'Avenida das Forças Armadas'),
            origin: false))
        ..add(BSNavigationAdvanced())
        ..add(
            BSNavigationInterestAdded(pois: [example.pois[0], example.pois[1]]))
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationRestrictionAdded(budget: 100))
        ..add(BSNavigationRestrictionAdded(visitTime: 120))
        ..add(BSNavigationRestrictionAdded(effort: 2))
        ..add(BSNavigationAdvanced()),
      verify: (cubit) {
        expect(cubit.state, isA<BSNavigationConfirmingTrip>());
        final state = cubit.state as BSNavigationConfirmingTrip;

        //Test origin
        expect(state.tripPlanModel.origin.name, 'Rua Alexandre Ferreira');
        expect(state.tripPlanModel.origin.coordinates.latitude, 38.7139092);
        expect(state.tripPlanModel.origin.coordinates.longitude, -9.1334762);

        //Test destination
        expect(
            state.tripPlanModel.destination.name, 'Avenida das Forças Armadas');
        expect(state.tripPlanModel.destination.coordinates.latitude,
            38.70861933474137);
        expect(state.tripPlanModel.destination.coordinates.longitude,
            -9.140110592695562);

        //Test interest POIs
        expect(state.tripPlanModel.pois[0].id, example.pois[0].id);
        expect(state.tripPlanModel.pois[1].id, example.pois[1].id);

        //Test budged
        expect(state.tripPlanModel.budget, 100);

        //Test visitation time
        expect(state.tripPlanModel.visitTime, 120);

        //Test effort
        expect(state.tripPlanModel.effort, 2);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test creating a trip from a specific location, ending in the same location, with no POIs added as interests, with a medium effort level, 50 euros as budget and 1 hour as visitation time',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationPointSelected(true))
        ..add(BSNavigationLocationSelected(
            coordinates: LatLng(38.7139092, -9.1334762)))
        ..add(BSNavigationLocationAccepted(
            LocationModel(LatLng(38.7139092, -9.1334762),
                name: 'Rua Alexandre Ferreira'),
            origin: true))
        ..add(BSNavigationPointSelected(false))
        ..add(BSNavigationLocationSelected(
            coordinates: LatLng(38.7139092, -9.1334762)))
        ..add(BSNavigationLocationAccepted(
            LocationModel(LatLng(38.7139092, -9.1334762),
                name: 'Rua Alexandre Ferreira'),
            origin: false))
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationRestrictionAdded(budget: 50))
        ..add(BSNavigationRestrictionAdded(visitTime: 60))
        ..add(BSNavigationRestrictionAdded(effort: 1))
        ..add(BSNavigationAdvanced()),
      verify: (cubit) {
        expect(cubit.state, isA<BSNavigationConfirmingTrip>());
        final state = cubit.state as BSNavigationConfirmingTrip;

        //Test origin
        expect(state.tripPlanModel.origin.name, 'Rua Alexandre Ferreira');
        expect(state.tripPlanModel.origin.coordinates.latitude, 38.7139092);
        expect(state.tripPlanModel.origin.coordinates.longitude, -9.1334762);

        //Test destination
        expect(state.tripPlanModel.destination.name, 'Rua Alexandre Ferreira');
        expect(
            state.tripPlanModel.destination.coordinates.latitude, 38.7139092);
        expect(
            state.tripPlanModel.destination.coordinates.longitude, -9.1334762);

        //Test interest POIs
        expect(state.tripPlanModel.pois, isEmpty);

        //Test budged
        expect(state.tripPlanModel.budget, 50);

        //Test visitation time
        expect(state.tripPlanModel.visitTime, 60);

        //Test effort
        expect(state.tripPlanModel.effort, 1);
      },
    );

    blocTest<BSNavigationBloc, BSNavigationState>(
      'Test creating a trip from a specific location, to another specific location, with one POI added as interests, with the default minimum restrictions',
      build: () => _bsNavigationBloc,
      act: (cubit) => cubit
        ..add(BSNavigationPointSelected(true))
        ..add(BSNavigationLocationSelected(
            coordinates: LatLng(38.7139092, -9.1334762)))
        ..add(BSNavigationLocationAccepted(
            LocationModel(LatLng(38.7139092, -9.1334762),
                name: 'Rua Alexandre Ferreira'),
            origin: true))
        ..add(BSNavigationPointSelected(false))
        ..add(BSNavigationLocationSelected(
            coordinates: LatLng(38.70861933474137, -9.140110592695562)))
        ..add(BSNavigationLocationAccepted(
            LocationModel(LatLng(38.70861933474137, -9.140110592695562),
                name: 'Avenida das Forças Armadas'),
            origin: false))
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationInterestAdded(pois: [example.pois[0]]))
        ..add(BSNavigationAdvanced())
        ..add(BSNavigationAdvanced()),
      verify: (cubit) {
        expect(cubit.state, isA<BSNavigationConfirmingTrip>());
        final state = cubit.state as BSNavigationConfirmingTrip;

        //Test origin
        expect(state.tripPlanModel.origin.name, 'Rua Alexandre Ferreira');
        expect(state.tripPlanModel.origin.coordinates.latitude, 38.7139092);
        expect(state.tripPlanModel.origin.coordinates.longitude, -9.1334762);

        //Test destination
        expect(
            state.tripPlanModel.destination.name, 'Avenida das Forças Armadas');
        expect(state.tripPlanModel.destination.coordinates.latitude,
            38.70861933474137);
        expect(state.tripPlanModel.destination.coordinates.longitude,
            -9.140110592695562);

        //Test interest POIs
        expect(state.tripPlanModel.pois[0].id, example.pois[0].id);

        //Test budged
        expect(state.tripPlanModel.budget, example.pois[0].price);

        //Test visitation time
        expect(state.tripPlanModel.visitTime, example.pois[0].visitTime);

        //Test effort
        expect(state.tripPlanModel.effort, 2);
      },
    );

    blocTest<RouteRequestBloc, RouteRequestState>(
      'Test successful response from the ROUTE microservice',
      build: () {
        final client = MockClient();
        when(client.get('placeholder'))
            .thenAnswer((_) async => http.Response(example.cenario2, 200));
        return RouteRequestBloc(client);
      },
      act: (cubit) {
        cubit..add(SendRouteRequest(TripPlanModel()));
      },
      expect: [isA<RouteRequestLoading>(), isA<RouteRequestLoaded>()],
      verify: (cubit) {
        final state = cubit.state as RouteRequestLoaded;
        expect(state.tripModel, isA<TripModel>());
      },
    );

    blocTest<RouteRequestBloc, RouteRequestState>(
      'Test error response from the ROUTE microservice: not able to create a trip with these constraints',
      build: () {
        final client = MockClient();
        when(client.get('placeholder'))
            .thenAnswer((_) async => http.Response('Bad Constraints', 204));
        return RouteRequestBloc(client);
      },
      act: (cubit) {
        cubit..add(SendRouteRequest(TripPlanModel()));
      },
      expect: [isA<RouteRequestLoading>(), isA<RouteRequestTripError>()],
    );

    blocTest<RouteRequestBloc, RouteRequestState>(
      'Test error due to no internet connection',
      build: () {
        final client = MockClient();
        when(client.get('placeholder')).thenThrow(Exception());
        return RouteRequestBloc(client);
      },
      act: (cubit) {
        cubit..add(SendRouteRequest(TripPlanModel()));
      },
      expect: [isA<RouteRequestLoading>(), isA<RouteRequestConnectionError>()],
    );
  });
}

// blocTest(
//     'emits [1] when CounterEvent.increment is added', //Description of the test case
//     build: () => CounterBloc(), //Initialize bloc (state is 0)
//     act: (bloc) => bloc.add(CounterEvent.increment), //Add increment event to bloc
//     expect: [1], //Assert that bloc state is 1
// );

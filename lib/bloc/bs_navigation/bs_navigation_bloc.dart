import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';

import '../../core/categories.dart';
import '../../data/models/location_model.dart';
import '../../data/models/point_of_interest_model.dart';
import '../../data/models/trip_model.dart';
import '../../data/models/trip_plan_model.dart';
import '../../data/repositories/trip_repository.dart';

part 'bs_navigation_event.dart';
part 'bs_navigation_state.dart';

class BSNavigationBloc extends Bloc<BSNavigationEvent, BSNavigationState> {
  final TripRepository _tripRepository;
  final TripPlanModel _tripPlanModel;

  bool _originSelected;

  BSNavigationBloc(
    this._tripRepository,
  )   : this._tripPlanModel = TripPlanModel(),
        super(const BSNavigationExplore());

  @override
  Stream<BSNavigationState> mapEventToState(
    BSNavigationEvent event,
  ) async* {
    if (event is BSNavigationLoadActiveTrip)
      yield* _handleLoadActiveTrip();
    else if (event is BSNavigationLocationSelected)
      yield* _handleLocationSelected(event);
    else if (event is BSNavigationMapSelection)
      yield* _handleMapSelection(event);
    else if (event is BSNavigationLocationAccepted)
      yield* _handleLocationAccepted(event);
    else if (event is BSNavigationPlanStarted)
      yield* _handlePlanningStarted();
    else if (event is BSNavigationPointSelected)
      yield* _handlePointSelected(event);
    else if (event is BSNavigationAdvanced)
      yield* _handleAdvanced();
    else if (event is BSNavigationRestrictionAdded)
      yield* _handleRestrictionAdded(event);
    else if (event is BSNavigationInterestAdded)
      yield* _handleInterestAdded(event);
    else if (event is BSNavigationCanceled) yield* _handleCanceled();
  }

  Stream<BSNavigationState> _handleLoadActiveTrip() async* {
    final trip = await _tripRepository.getCurrentTrip();
    if (trip != null) yield BSNavigationActiveTrip(trip);
  }

  Stream<BSNavigationState> _handleLocationSelected(
      BSNavigationLocationSelected event) async* {
    if (state is BSNavigationExplore || state is BSNavigationSelectingLocation)
      yield BSNavigationShowingLocation(
          address: event.address,
          coordinates: event.coordinates,
          locationModel: event.locationModel,
          origin: _originSelected ?? true);
  }

  Stream<BSNavigationState> _handleMapSelection(
      BSNavigationMapSelection event) async* {
    if (state is BSNavigationExplore ||
        state is BSNavigationSelectingLocation ||
        state is BSNavigationShowingLocation)
      yield BSNavigationShowingLocation(
          coordinates: event.coordinates, origin: _originSelected ?? true);
  }

  Stream<BSNavigationState> _handleLocationAccepted(
      BSNavigationLocationAccepted event) async* {
    if (state is BSNavigationShowingLocation) {
      if (event.origin != null) {
        if (event.origin)
          _tripPlanModel.origin = event.location;
        else
          _tripPlanModel.destination = event.location;
      } else {
        if (_originSelected == null) _originSelected = true;
        if (_originSelected)
          _tripPlanModel.origin = event.location;
        else
          _tripPlanModel.destination = event.location;
      }
      _originSelected = null;
      yield BSNavigationPlanningPoints(
          origin: _tripPlanModel.origin,
          destination: _tripPlanModel.destination);
    }
  }

  Stream<BSNavigationState> _handlePlanningStarted() async* {
    if (state is BSNavigationExplore) {
      _originSelected = null;
      yield BSNavigationPlanningPoints();
    }
  }

  Stream<BSNavigationState> _handleCanceled() async* {
    if (state is BSNavigationSelectingLocation) {
      _originSelected = null;
      yield BSNavigationPlanningPoints(
          origin: _tripPlanModel.origin,
          destination: _tripPlanModel.destination);
    } else if (state is BSNavigationShowingLocation) {
      if (_originSelected == null)
        yield BSNavigationExplore();
      else
        yield BSNavigationSelectingLocation(_originSelected);
    } else if (state is BSNavigationPlanningPoints) {
      _originSelected = null;
      _tripPlanModel.clear();
      yield BSNavigationExplore();
    } else if (state is BSNavigationPlanningRestrictions) {
      _originSelected = null;
      _tripPlanModel.clearRestrictions();
      yield BSNavigationPlanningPoints(
          origin: _tripPlanModel.origin,
          destination: _tripPlanModel.destination);
    } else if (state is BSNavigationPlanningInterests) {
      _tripPlanModel.clearInterests();
      yield BSNavigationPlanningRestrictions(
          budget: _tripPlanModel.budget,
          date: _tripPlanModel.date,
          effort: _tripPlanModel.effort);
    }
  }

  Stream<BSNavigationState> _handlePointSelected(
      BSNavigationPointSelected event) async* {
    _originSelected = event.origin;
    if (state is BSNavigationPlanningPoints) {
      yield BSNavigationSelectingLocation(event.origin);
    }
  }

  Stream<BSNavigationState> _handleAdvanced() async* {
    if (state is BSNavigationPlanningPoints) {
      _tripPlanModel.budget = 50;
      _tripPlanModel.effort = 2;
      _tripPlanModel.date = DateTime.now().millisecondsSinceEpoch;
      yield BSNavigationPlanningRestrictions(
          budget: _tripPlanModel.budget,
          date: _tripPlanModel.date,
          effort: _tripPlanModel.effort);
    } else {
      if (state is BSNavigationPlanningRestrictions)
        yield BSNavigationPlanningInterests(
            categories: List.generate(categories.length, (index) => index));
      else if (state is BSNavigationPlanningInterests) print('done');
    }
  }

  Stream<BSNavigationState> _handleRestrictionAdded(
      BSNavigationRestrictionAdded event) async* {
    if (state is BSNavigationPlanningRestrictions) {
      if (event.budget != null) _tripPlanModel.budget = event.budget;
      if (event.date != null) _tripPlanModel.date = event.date;
      if (event.effort != null) _tripPlanModel.effort = event.effort;
      yield BSNavigationPlanningRestrictions(
          budget: _tripPlanModel.budget,
          date: _tripPlanModel.date,
          effort: _tripPlanModel.effort);
    }
  }

  Stream<BSNavigationState> _handleInterestAdded(
      BSNavigationInterestAdded event) async* {
    if (state is BSNavigationPlanningInterests) {
      if (event.categories != null)
        _tripPlanModel.categories = event.categories;
      if (event.pois != null) _tripPlanModel.pois = event.pois;
      yield BSNavigationPlanningInterests(
          categories: _tripPlanModel.categories);
    }
  }
}

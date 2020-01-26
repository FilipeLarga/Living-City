import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:living_city/data/repositories/user_preferences_repository.dart';
import './bloc.dart';

class UserPreferencesBloc
    extends Bloc<UserPreferencesEvent, UserPreferencesState> {
  final UserPreferencesRepository repository;

  UserPreferencesBloc({@required this.repository});

  @override
  UserPreferencesState get initialState => LoadingUserPreferencesState();

  @override
  Stream<UserPreferencesState> mapEventToState(
    UserPreferencesEvent event,
  ) async* {
    // TODO: Add Logic
  }
}

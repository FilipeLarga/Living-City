import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_sheet_event.dart';
part 'bottom_sheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  BottomSheetBloc() : super(const SheetClosed());

  @override
  Stream<BottomSheetState> mapEventToState(
    BottomSheetEvent event,
  ) async* {
    if (event is SheetMoved) {
      yield* _mapMovementToState(event);
    } else if (event is SheetClosure) {
      yield* _mapClosureToState();
    } else if (event is SheetOpened) {
      yield* _mapOpenedToState();
    }
  }

  Stream<BottomSheetState> _mapMovementToState(SheetMoved event) async* {
    yield SheetMoving(factor: event.factor);
  }

  Stream<BottomSheetState> _mapClosureToState() async* {
    yield SheetClosed();
  }

  Stream<BottomSheetState> _mapOpenedToState() async* {
    yield SheetOpen();
  }
}

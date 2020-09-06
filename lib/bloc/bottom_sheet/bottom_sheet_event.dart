part of 'bottom_sheet_bloc.dart';

@immutable
abstract class BottomSheetEvent {
  const BottomSheetEvent();
}

class SheetMoved extends BottomSheetEvent {
  final double factor;
  const SheetMoved({@required this.factor});
}

class SheetClosure extends BottomSheetEvent {
  const SheetClosure();
}

class SheetOpened extends BottomSheetEvent {
  const SheetOpened();
}

part of 'bottom_sheet_bloc.dart';

@immutable
abstract class BottomSheetState {
  const BottomSheetState();
}

class SheetClosed extends BottomSheetState {
  const SheetClosed();
}

class SheetOpen extends BottomSheetState {
  const SheetOpen();
}

class SheetMoving extends BottomSheetState {
  final double factor;
  const SheetMoving({@required this.factor});
}

//class SheetFixed extends BottomSheetState {}

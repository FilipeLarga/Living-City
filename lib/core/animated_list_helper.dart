import 'package:flutter/material.dart';

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = initialItems?.toList() ?? <E>[];

  final GlobalKey<AnimatedListState> listKey;
  final Widget Function(
          E item, BuildContext context, Animation<double> animation)
      removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index,
        duration: const Duration(milliseconds: 300));
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  bool contains(E item) {
    return _items.contains(item);
  }

  removeAll() {
    final limit = _items.length;
    for (int i = limit - 1; i >= 0; i--) {
      removeAt(i);
    }
  }

  int get length => _items.length;
  E operator [](int index) => _items[index];
  int indexOf(E item) => _items.indexOf(item);
}

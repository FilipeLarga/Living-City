import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import '../../../../core/categories.dart';

class PlanInterestsPanel extends StatelessWidget {
  final List<int> activeCategories;

  const PlanInterestsPanel({Key key, @required this.activeCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Interests',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20, height: 1)),
              Row(
                children: <Widget>[
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              var width = (constraints.maxWidth - 24) / 2;

              return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 24,
                mainAxisSpacing: 16,
                childAspectRatio: width / 48,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                children: [
                  ...categories.map((e) => _CategoryItem(
                        id: e.id,
                        name: e.name,
                        active: activeCategories.contains(e.id),
                        callback: _onTap,
                      ))
                ],
              );
            },
          ),
          const SizedBox(height: 32),
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
                      onTap: () => BlocProvider.of<BSNavigationBloc>(context)
                          .add(BSNavigationAdvanced()),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: Text('NEXT',
                                style: TextStyle(
                                    wordSpacing: 1.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onTap(int index, bool active, BuildContext context) {
    if (active)
      activeCategories.add(index);
    else
      activeCategories.remove(index);
    BlocProvider.of<BSNavigationBloc>(context)
        .add(BSNavigationInterestAdded(categories: activeCategories));
  }
}

class _CategoryItem extends StatelessWidget {
  final int id;
  final String name;
  final bool active;
  final Function(int, bool, BuildContext) callback;

  const _CategoryItem(
      {Key key,
      @required this.id,
      @required this.name,
      @required this.active,
      @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(id, !active, context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: active
                  ? Border.all(width: 2, color: Theme.of(context).accentColor)
                  : null,
              color: /*active ? Theme.of(context).accentColor : */ Colors
                  .grey[100],
            ),
            child: Center(
              child: Text(name,
                  style: TextStyle(
                    fontSize: 16,
                    // color: active ? Colors.white : Colors.black,
                    fontWeight: active ? FontWeight.w400 : FontWeight.normal,
                  )),
            ),
          ),
          // Positioned(
          //   bottom: 10,
          //   right: 10,
          //   height: 18,
          //   width: 18,
          //   child: AnimatedContainer(
          //     duration: const Duration(milliseconds: 200),
          //     height: 0,
          //     width: 0,
          //     child: Icon(
          //       Icons.check_circle,
          //       color: Theme.of(context).accentColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

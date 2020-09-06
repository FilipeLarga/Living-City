import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_city/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import '../../../../bloc/bs_navigation/bs_navigation_bloc.dart';
import 'package:living_city/bloc/search_history/search_history_bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:shimmer/shimmer.dart';

class SearchPanel extends StatefulWidget {
  static const routeName = 'map/explorer/search';

  final Function() openSheet;
  final Function() closeSheet;
  final ScrollController scrollController;

  const SearchPanel(
      {Key key,
      @required this.openSheet,
      @required this.closeSheet,
      @required this.scrollController})
      : super(key: key);

  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  FocusNode _myFocusNode;

  bool _ignoretextfield; //this is true when sheet is closed or moving
  bool _focusWhenOpen;
  @override
  void initState() {
    super.initState();
    if (!(BlocProvider.of<SearchHistoryBloc>(context).state
        is SearchHistoryLoading)) {
      BlocProvider.of<SearchHistoryBloc>(context).add(const FetchHistory());
    }
    _myFocusNode = FocusNode();
    _ignoretextfield = true;
    _focusWhenOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BottomSheetBloc, BottomSheetState>(
          listener: (context, state) {
            if (state is SheetOpen) {
              setState(() {
                if (_focusWhenOpen) _myFocusNode.requestFocus();
                _ignoretextfield = false;
                _focusWhenOpen = false;
              });
            } else if (state is SheetMoving && state.factor < 0.99) {
              FocusScope.of(context).unfocus();
              setState(() {
                _ignoretextfield = true;
              });
            } else if (state is SheetClosed) {
              FocusScope.of(context).unfocus();
              setState(() {
                _ignoretextfield = true;
              });
            }
          },
        ),
      ],
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          controller: widget.scrollController,
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: _PersistentHeader(_ignoretextfield,
                  _openAndFocusKeyboard, _myFocusNode, _onSubmitted),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _OptionsList(
                      onSelect: _onSelect, closeSheet: widget.closeSheet),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RECENT SEARCHES',
                        style: const TextStyle(
                            fontSize: 10,
                            color: const Color(0xFF7F7E7E),
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
              builder: (context, state) {
                if (state is SearchHistoryLoading ||
                    state is SearchHistoryInitial) {
                  return SliverToBoxAdapter(child: const ShimmerList());
                } else if (state is SearchHistoryEmpty) {
                  return SliverToBoxAdapter(child: Text('empty'));
                } else {
                  final List<LocationModel> locations =
                      (state as SearchHistoryLoaded).searchHistory;
                  return SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...locations.map((location) {
                          return SearchHistoryListItem(
                            location: location,
                            onSelect: _onSelect,
                          );
                        }),
                        const SizedBox(height: 24)
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    super.dispose();
  }

  void _openAndFocusKeyboard() {
    setState(() {
      _focusWhenOpen = true;
    });
    widget.openSheet();
  }

  void _onSubmitted(String address) {
    BlocProvider.of<BSNavigationBloc>(context)
        .add(BSNavigationLocationSelected(address: address));
  }

  void _onSelect(LocationModel locationModel) {
    BlocProvider.of<BSNavigationBloc>(context)
        .add(BSNavigationLocationSelected(locationModel: locationModel));
  }
}

class _PersistentHeader extends SliverPersistentHeaderDelegate {
  final bool _ignoretextfield;
  final Function() _openAndFocusKeyboard;
  final FocusNode _myFocusNode;
  final Function(String) _onSubmitted;

  _PersistentHeader(this._ignoretextfield, this._openAndFocusKeyboard,
      this._myFocusNode, this._onSubmitted);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 4,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  ignoring: !_ignoretextfield,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _openAndFocusKeyboard,
                    child: Container(),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: _ignoretextfield,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 48, minHeight: 48),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                    maxLines: 1,
                    focusNode: _myFocusNode,
                    onSubmitted: _onSubmitted,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: const Color(0xFF808080),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 16),
                      hintText: 'Search here',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFFF0F0F0), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Theme.of(context).cursorColor, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFFF0F0F0), width: 1.5),
                      ),
                      fillColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _OptionsList extends StatelessWidget {
  final Function(LocationModel) onSelect;
  final Function() closeSheet;

  const _OptionsList(
      {Key key, @required this.onSelect, @required this.closeSheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () => closeSheet(),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF0F0F0)),
            child: Center(
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 12),
                  Icon(
                    Icons.pin_drop,
                    color: const Color(0xFF808080),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: const Text(
                      'Choose on map',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: const Color(0xFF4D4D4D)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF0F0F0)),
          child: Center(
            child: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
              builder: (context, state) {
                if (state is SearchHistoryLoading ||
                    state is SearchHistoryInitial) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: 12),
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 32.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 10,
                                        color: Colors.white,
                                        width: double.infinity,
                                      ),
                                      const SizedBox(height: 8),
                                      LayoutBuilder(
                                        builder: (_, constraints) {
                                          return Container(
                                            height: 10,
                                            color: Colors.white,
                                            width: constraints.maxWidth / 2,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  LocationModel location;
                  if (state is SearchHistoryEmpty)
                    location = state.currentLocation;
                  if (state is SearchHistoryLoaded)
                    location = state.currentLocation;
                  return GestureDetector(
                    onTap: () => (location != null && location.name != null)
                        ? onSelect(location)
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.history,
                          color: const Color(0xFF808080),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Current Location',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF4D4D4D)),
                              ),
                              Text(
                                location?.name ?? 'Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: const Color(0xFF666666)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: const Color(0xFFF0F0F0),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SearchHistoryListItem extends StatelessWidget {
  final LocationModel location;
  final Function(LocationModel) onSelect;

  const SearchHistoryListItem(
      {Key key, @required this.location, @required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () => onSelect(location),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //color: const Color(0xFFF0F0F0)
          ),
          child: Center(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                Icon(
                  Icons.history,
                  color: const Color(0xFF808080),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        location.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: const Color(0xFF4D4D4D)),
                      ),
                      Text(
                        location.locality,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: const Color(0xFF666666)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: 8,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 12),
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 10,
                            color: Colors.white,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (_, constraints) {
                              return Container(
                                height: 10,
                                color: Colors.white,
                                width: constraints.maxWidth / 2,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// //Model Class
// class ShoppingCartModel with ChangeNotifier {
//   final List<Product> _products = [];

//   List<Product> get products => List.from(_products);

//   void addProduct(Product product) {
//     //Could add some business logic here, such as checking for repeated products
//     _products.add(product);
//     notifyListeners(); //Notify the UI so it reflects the changes made
//   }

//   void removeProduct(Product product) {
//     _products.remove(product);
//     notifyListeners();
//   }

//   bool contains(Product product) {
//     return _products.contains(product);
//   }

//   bool isEmpty() {
//     return _products.isEmpty;
//   }
// }

// //Provider
// ChangeNotifierProvider<ShoppingCartModel>(
//     create: (context) => ShoppingCartModel(),
//     child: ... //the rest of the widget tree
// );

// //Product Details
// Consumer<ShoppingCartModel>(
//   builder: (model) {
//     ... //Rest of the Product Details UI...
//     RaisedButton(     //Button to add product to cart
//       child: Text('Add to cart'),
//       onPressed: () => model.addProduct(product),
//     );
//   },
// );

// //Shopping Cart
// Consumer<ShoppingCartModel>(
//   builder: (model) {
//     //Obtaining the list of products to display
//     final productList = model.getProducts();
//     ...  //Rest of the Shopping Cart UI...
//   },
// );

// @immutable
// abstract class ShoppingCartState {
//   const ShoppingCartState();
// }

// class ShoppingCartEmpty extends ShoppingCartState {
//   const ShoppingCartEmpty();
// }

// class ShoppingCartLoaded extends ShoppingCartState {
//   final List<Product> products;
//   const ShoppingCartLoaded(this.products);

//   bool contains(Product product) {
//     return products.contains(product);
//   }
// }

// @immutable
// abstract class ShoppingCartEvent {
//   const ShoppingCartEvent();
// }

// class AddProduct extends ShoppingCartEvent {
//   final Product product;
//   const AddProduct(this.product);
// }

// class RemoveProduct extends ShoppingCartEvent {
//   final Product product;
//   const RemoveProduct(this.product);
// }

// class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
//   final List<Product> _products = [];
//   ShoppingCartBloc() : super(const ShoppingCartEmpty()); //Initial state

//   @override
//   Stream<ShoppingCartState> mapEventToState(  //Map the incoming events to states
//     ShoppingCartEvent event,
//   ) async* {
//     if (event is AddProduct)
//       yield* _addProduct(event.product);
//     else if (event is RemoveProduct) yield* _removeProduct(event.product);
//   }

//   Stream<ShoppingCartState> _addProduct(Product product) async* {
//     _products.add(product);  //We could add more business logic here, such as duplicate validation...
//     yield ShoppingCartLoaded(List.from(_products));
//   }

//   Stream<ShoppingCartState> _removeProduct(Product product) async* {
//     _products.remove(product);
//     if (_products.isEmpty)
//       yield ShoppingCartEmpty();
//     else
//       yield ShoppingCartLoaded(List.from(_products));
//   }
// }

// //XML Layout omitted for brevity and irrelevance.

// //Obtain the instance of the textview from the XML layout file
// TextView textview = (TextView) findViewById(R.id.textview);
// //Obtain the instance of the button from the XML layout file
// Button button = (Button) findViewById(R.id.button);

// //Create the listener function that will be given to the button
// public onClickListener listener = new View.OnclickListener{
//     onclick(View v){
//       // Set the text property of the textview to display the new message
//       textview.setText("Button clicked!");
//     }
// }

// button.setOnClickListener(listener); //Add the listener to the button

// class ExampleScreen extends StatefulWidget {
//   @override
//   _ExampleScreenState createState() => _ExampleScreenState();
// }

// class _ExampleScreenState extends State<ExampleScreen> {
//   String _message = 'Click the button'; //The initial state of the UI

//   @override
//   Widget build(BuildContext context) {
//     //Describes the part of the user interface represented by this widget.
//     return Scaffold(
//       body: Column(
//         children: [
//           Text(_message), //Text widget that displays the message
//           MaterialButton(
//             onPressed:
//                 _updateMessage, //Method called when the button is clicked
//             child: Text('BUTTON'),
//           )
//         ],
//       ),
//     );
//   }

//   //Method to update the message
//   void _updateMessage() {
//     //Calling [setState] notifies the framework that the internal state
//     //of this object has changed in a way that might impact the
//     //user interface in this subtree, which causes the framework to
//     //schedule a [build] for this [State] object.
//     setState(() => _message = 'Button clicked!');
//   }
// }

import 'package:flutter/material.dart';
import 'package:living_city/core/bluetooth_detection_service.dart';
import 'package:living_city/core/lifecycle_observer.dart';
import 'package:living_city/dependency_injection/injection_container.dart'
    as di;
import './screens/main_screen/main_screen.dart';
import 'bloc/bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  var binding = WidgetsFlutterBinding.ensureInitialized();
  di.init(); //dependencies injection
  binding.addObserver(LifeCycleObserver(di.sl()..start()));
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color(0xFFD98273),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        fontFamily: 'OpenSans',
      ),
      routes: {
        '/': (context) => MainScreen(),
      },
    );
  }
}

// void _onSuccess(http.Response response) {
//   print('Success! $response');
// }

// void _onError() {
//   print('Error!');
// }

// void _networkRequest(String url) {
//   //Make the method call which returns a Future
//   Future<http.Response> networkFuture = http.get(url);
//   //Register the callback to when the future is completed
//   //Provide a success and an error function
//   networkFuture.then(_onSuccess, onError: _onError);
// }

// class DataHolder {
//   final Placeholder data;
//   DataHolder(this.data);
// }

// Future<int> _loadFromDisk() {
//   //Simulate a 1 second operation and return the value 1
//   Future.delayed(const Duration(seconds: 1)).then((value) => 1);
// }

// Future<Placeholder> _fetchNetworkData(int id) {
//   //Simulate a 1 second operation and return fake data
//   Future.delayed(const Duration(seconds: 1)).then((value) => Placeholder());
// }

// //Using the Future API
// Future<DataHolder> createDataWithFuture() {
//   return _loadFromDisk().then((id) {
//     return _fetchNetworkData(id);
//   }).then((data) {
//     return DataHolder(data);
//   });
// }

// //Using the Async / Await API
// Future<DataHolder> createDataWithAsync() async {
//   final id = await _loadFromDisk();
//   final data = await _fetchNetworkData(id);
//   return DataHolder(data);
// }

import 'package:flutter/material.dart';
import 'package:living_city/core/bluetooth_detection_service.dart';
import 'package:living_city/core/lifecycle_observer.dart';
import 'package:living_city/dependency_injection/injection_container.dart'
    as di;
import './screens/main_screen/main_screen.dart';
import 'bloc/bloc_delegate.dart';
import 'package:bloc/bloc.dart';

void main() {
  var binding = WidgetsFlutterBinding.ensureInitialized();
  di.init(); //dependencies injection
  binding.addObserver(LifeCycleObserver(di.sl()..start()));
  BlocSupervisor.delegate = SimpleBlocDelegate();
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

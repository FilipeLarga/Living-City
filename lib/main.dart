import 'package:flutter/material.dart';
import 'package:living_city/dependency_injection/injection_container.dart'
    as di;
import './screens/main_screen/main_screen.dart';
import 'bloc/bloc_delegate.dart';
import 'package:bloc/bloc.dart';

void main() {
  di.init(); //dependencies injection
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color(0xFF5863AF),
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

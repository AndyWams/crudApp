import 'package:crudApp/screens/edit_record.dart';
import 'package:crudApp/screens/home.dart';
import 'package:flutter/material.dart';

const EditRecord = '/place_details';
const _Home = '/';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final int arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case _Home:
          screen = Home();
          break;
        case EditRecord:
          screen = UpdateRecord(arguments);
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}

import 'home_page.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';

void main() => runApp((new MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
        '/landingpage': (BuildContext context) => MyApp(),
        '/homepage' : (BuildContext context) => HomePage(),

      },
    );
  }
}
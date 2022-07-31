import 'package:flutter/material.dart';
import 'package:stadistic/src/main_page.dart';
import 'package:stadistic/src/result_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stadistic Project',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/result': (context) => const ResultPage()
      },
    );
  }
}

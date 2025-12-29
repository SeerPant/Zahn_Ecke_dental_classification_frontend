//material design library
import 'package:flutter/material.dart';
//state management package
import 'package:provider/provider.dart';

//entry point of dart app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ],
      child: MaterialApp(
        title: 'Zahn Ecke',
        initialRoute: '/login',
        routes: {},
      ),
    );
  }
}

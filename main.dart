import 'package:flutter/material.dart';
import 'principal.dart'; //pantalla del memorama
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorama App',// titulo de la app
      theme: ThemeData( // tema de la app
        primarySwatch: Colors.blue, // color primario
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Principal(),
    );
  }
}

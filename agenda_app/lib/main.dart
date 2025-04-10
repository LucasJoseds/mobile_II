import 'package:flutter/material.dart';
import 'package:mobile_a1/screens/home.dart';
import 'screens/home.dart';
import 'services/contato_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ContatoService service = ContatoService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(service: service),
    );
  }
}

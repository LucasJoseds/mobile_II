import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'api/api_server.dart';
import 'services/contato_service.dart';
import 'screens/home_screen.dart';

void main() async {
  final service = ContatoService();
  final api = ApiServer(service);

  // Inicia servidor local na porta 8080
  final server = await shelf_io.serve(api.handler, 'localhost', 8080);
  print('Servidor API rodando em http://${server.address.host}:${server.port}');

  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final ContatoService service;

  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(service: service),
    );
  }
}

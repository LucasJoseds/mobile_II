import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

class Contato {
  final int id;
  final String nome;
  final String telefone;

  Contato(this.id, this.nome, this.telefone);

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'telefone': telefone,
  };

  static Contato fromJson(Map<String, dynamic> json) {
    return Contato(json['id'], json['nome'], json['telefone']);
  }
}

final List<Contato> contatos = [];
int nextId = 1;

void main() async {
  final router = Router();

  router.get('/contatos', (Request request) {
    final json = jsonEncode(contatos.map((c) => c.toJson()).toList());
    return Response.ok(json, headers: {'Content-Type': 'application/json'});
  });

  router.post('/contatos', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final contato = Contato(nextId++, data['nome'], data['telefone']);
    contatos.add(contato);
    return Response.ok(
      jsonEncode(contato.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.put('/contatos/<id|[0-9]+>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final index = contatos.indexWhere((c) => c.id == int.parse(id));
    if (index == -1) return Response.notFound('Contato não encontrado');
    contatos[index] = Contato(int.parse(id), data['nome'], data['telefone']);
    return Response.ok(
      jsonEncode(contatos[index].toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.delete('/contatos/<id|[0-9]+>', (Request request, String id) {
    final idInt = int.parse(id);
    final countBefore = contatos.where((c) => c.id == idInt).length;
    contatos.removeWhere((c) => c.id == idInt);
    return countBefore > 0
        ? Response.ok('Removido')
        : Response.notFound('Contato não encontrado');
  });

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);

  final server = await io.serve(handler, 'localhost', 8080);
  print('✅ Servidor rodando em http://${server.address.host}:${server.port}');
}

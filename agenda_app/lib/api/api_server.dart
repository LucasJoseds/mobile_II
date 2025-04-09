import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/contato.dart';
import '../services/contato_service.dart';

class ApiServer {
  final ContatoService _service;

  ApiServer(this._service);

  Handler get handler {
    final router = Router();

    router.get('/contatos', (Request req) {
      final contatos = _service.getAll().map((e) => e.toJson()).toList();
      return Response.ok(
        jsonEncode(contatos),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.post('/contatos', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      final contato = _service.create(body['nome'], body['telefone']);
      return Response(
        201,
        body: jsonEncode(contato.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.put('/contatos/<id|[0-9]+>', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      final contato = _service.update(
        int.parse(id),
        body['nome'],
        body['telefone'],
      );
      if (contato == null) return Response.notFound('Contato não encontrado');
      return Response.ok(
        jsonEncode(contato.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.delete('/contatos/<id|[0-9]+>', (Request req, String id) {
      final sucesso = _service.delete(int.parse(id));
      return sucesso
          ? Response.ok('Deletado')
          : Response.notFound('Contato não encontrado');
    });

    return router;
  }
}

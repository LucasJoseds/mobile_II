import '../models/contato.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contato.dart';

class ContatoService {
  final String baseUrl = 'http://localhost:8080';

  Future<List<Contato>> getContatos() async {
    final response = await http.get(Uri.parse('$baseUrl/contatos'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Contato.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar contatos');
    }
  }

  Future<void> adicionarContato(Contato contato) async {
    await http.post(
      Uri.parse('$baseUrl/contatos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contato.toJson()),
    );
  }

  Future<void> atualizarContato(int id, Contato contato) async {
    final response = await http.put(
      Uri.parse('$baseUrl/contatos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contato.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar contato');
    }
  }

  Future<void> deletarContato(int id) async {
    await http.delete(Uri.parse('$baseUrl/contatos/$id'));
  }
}

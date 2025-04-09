import '../models/contato.dart';

class ContatoService {
  final List<Contato> _contatos = [];
  int _nextId = 1;

  List<Contato> getAll() => _contatos;

  Contato create(String nome, String telefone) {
    final contato = Contato(id: _nextId++, nome: nome, telefone: telefone);
    _contatos.add(contato);
    return contato;
  }

  Contato? update(int id, String nome, String telefone) {
    final index = _contatos.indexWhere((c) => c.id == id);
    if (index == -1) return null;
    final contato = Contato(id: id, nome: nome, telefone: telefone);
    _contatos[index] = contato;
    return contato;
  }

  bool delete(int id) {
    final originalLength = _contatos.length;
    _contatos.removeWhere((c) => c.id == id);
    return _contatos.length < originalLength;
  }

  Contato? getById(int id) {
    return _contatos.firstWhere(
      (c) => c.id == id,
      orElse: () => null as Contato,
    );
  }
}

import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/contato_service.dart';
import 'contato_form.dart';

class HomeScreen extends StatefulWidget {
  final ContatoService service;

  const HomeScreen({super.key, required this.service});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToForm([Contato? contato]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContatoForm(service: widget.service, contato: contato),
      ),
    );
    setState(() {});
  }

  void _deleteContato(int id) {
    widget.service.delete(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final contatos = widget.service.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de Contatos')),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (_, index) {
          final c = contatos[index];
          return ListTile(
            title: Text(c.nome),
            subtitle: Text(c.telefone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToForm(c),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteContato(c.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

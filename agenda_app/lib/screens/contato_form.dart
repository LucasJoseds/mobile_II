import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../services/contato_service.dart';

class ContatoForm extends StatefulWidget {
  final ContatoService service;
  final Contato? contato;

  const ContatoForm({super.key, required this.service, this.contato});

  @override
  State<ContatoForm> createState() => _ContatoFormState();
}

class _ContatoFormState extends State<ContatoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.contato?.nome ?? '');
    _telefoneController = TextEditingController(
      text: widget.contato?.telefone ?? '',
    );
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final telefone = _telefoneController.text;

      if (widget.contato == null) {
        widget.service.create(nome, telefone);
      } else {
        widget.service.update(widget.contato!.id, nome, telefone);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato == null ? 'Novo Contato' : 'Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o nome'
                            : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o telefone'
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_a1/models/contato.dart';
import '../services/contato_service.dart';

class ContatoForm extends StatefulWidget {
  final ContatoService service;
  final Contato? contato;

  const ContatoForm({Key? key, required this.service, this.contato})
    : super(key: key);

  @override
  State<ContatoForm> createState() => _ContatoFormState();
}

class _ContatoFormState extends State<ContatoForm> {
  final _formKey = GlobalKey<FormState>();
  String? _nome;
  String? _telefone;

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final contato = Contato(
        id: widget.contato?.id ?? 0,
        nome: _nome!,
        telefone: _telefone!,
      );

      if (widget.contato == null) {
        await widget.service.adicionarContato(contato);
      } else {
        await widget.service.atualizarContato(contato.id, contato);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contato == null ? 'Adicionar Contato' : 'Editar Contato',
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.contato?.nome ?? '',
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.orange),
                  prefixIcon: Icon(Icons.person, color: Colors.orange),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o nome'
                            : null,
                onSaved: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.contato?.telefone ?? '',
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  labelStyle: TextStyle(color: Colors.orange),
                  prefixIcon: Icon(Icons.phone, color: Colors.orange),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o telefone'
                            : null,
                onSaved: (value) => _telefone = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

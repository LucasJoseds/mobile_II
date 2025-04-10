import 'package:flutter/material.dart';
import 'package:mobile_a1/screens/contato_form.dart';
import '../models/contato.dart';
import '../services/contato_service.dart';

class Home extends StatefulWidget {
  final ContatoService service;

  const Home({Key? key, required this.service}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Contato> contatos = [];

  @override
  void initState() {
    super.initState();
    _loadContatos();
  }

  Future<void> _loadContatos() async {
    final lista = await widget.service.getContatos();
    setState(() {
      contatos = lista;
    });
  }

  void _remover(int id) async {
    await widget.service.deletarContato(id);
    _loadContatos();
  }

  void _navegarParaAdicionar({Contato? contato}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContatoForm(service: widget.service, contato: contato),
      ),
    );

    if (result == true) {
      _loadContatos(); // recarrega se adicionou/editou
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus Contatos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaAdicionar(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _loadContatos,
        child:
            contatos.isEmpty
                ? ListView(
                  children: const [
                    SizedBox(height: 150),
                    Center(
                      child: Text(
                        'Ainda não há contatos cadastrados',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  itemCount: contatos.length,
                  itemBuilder: (context, index) {
                    final contato = contatos[index];

                    if (contato.nome.isEmpty && contato.telefone.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            contato.nome,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(contato.telefone),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed:
                                    () =>
                                        _navegarParaAdicionar(contato: contato),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _remover(contato.id!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

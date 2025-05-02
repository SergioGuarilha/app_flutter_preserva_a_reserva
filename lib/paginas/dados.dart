import 'package:flutter/material.dart';
import 'package:trabalho_av1_app_moveis/meu_scaffold.dart';
import 'package:trabalho_av1_app_moveis/pessoa.dart';
import 'package:trabalho_av1_app_moveis/lista.dart';

class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _EstadoPaginaDados();
}

class _EstadoPaginaDados extends State<Dados> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorIdade = TextEditingController();

  TextField criarCaixaEdicao({required TextEditingController controlador}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(constraints: BoxConstraints(maxWidth: 300)),
        controller: controlador
    );
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorIdade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MeuScaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text('Preserva Reserva')),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                style: TextStyle(
                    color: Colors.white
                ),
                'Nome: ${_controladorNome.text}'
            ),
            criarCaixaEdicao(controlador: _controladorNome),
            Text(
                style: TextStyle(
                    color: Colors.white
                ),
                'Idade: ${_controladorIdade.text}'
            ),
            criarCaixaEdicao(controlador: _controladorIdade),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                final String nome = _controladorNome.text;
                final String stringIdade = _controladorIdade.text;

                try {
                  final int idade = int.parse(stringIdade);
                  lista.add(Pessoa(nome, idade));
                  _controladorNome.clear();
                  _controladorIdade.clear();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Você foi cadastrado com sucesso')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Idade inválida! Digite um número.")),
                  );
                }
              },
              tooltip: 'Confirmar',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
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

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorIdade.dispose();
    super.dispose();
  }

  Future<void> _removerPessoa(BuildContext context) async {
    final Pessoa? pessoaSelecionada = await showDialog<Pessoa?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selecione quem remover'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final pessoa = lista[index];
              return ListTile(
                title: Text('${pessoa.nome} (${pessoa.idade} anos)'),
                onTap: () => Navigator.pop(context, pessoa),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );

    if (pessoaSelecionada != null) {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmar remoção'),
          content: Text('Deseja realmente remover ${pessoaSelecionada.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Remover'),
            ),
          ],
        ),
      ) ?? false;

      if (confirmado && mounted) {
        setState(() {
          lista.remove(pessoaSelecionada);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pessoaSelecionada.nome} removido com sucesso!')),
        );
      }
    }
  }

  Future<void> _atualizarPessoa(BuildContext context) async {
    final Pessoa? pessoaSelecionada = await showDialog<Pessoa?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selecione quem atualizar'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final pessoa = lista[index];
              return ListTile(
                title: Text('${pessoa.nome} (${pessoa.idade} anos)'),
                onTap: () => Navigator.pop(context, pessoa),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );

    if (pessoaSelecionada != null && mounted) {
      final nomeController = TextEditingController(text: pessoaSelecionada.nome);
      final idadeController = TextEditingController(text: pessoaSelecionada.idade.toString());

      final confirmado = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Editar dados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: idadeController,
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirmar'),
            ),
          ],
        ),
      ) ?? false;

      if (confirmado && mounted) {
        try {
          final novoNome = nomeController.text;
          final novaIdade = int.parse(idadeController.text);

          setState(() {
            final index = lista.indexOf(pessoaSelecionada);
            if (index != -1) {
              lista[index] = Pessoa(novoNome, novaIdade);
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dados atualizados com sucesso!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Idade inválida! Digite um número.")),
          );
        }
      }

      nomeController.dispose();
      idadeController.dispose();
    }
  }

  TextField criarCaixaEdicao({required TextEditingController controlador}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        constraints: BoxConstraints(maxWidth: 300),
        border: OutlineInputBorder(),
      ),
      controller: controlador,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MeuScaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text('Preserva a Reserva')),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Área de cadastro, atualização e remoção de dados',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.green,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Nome: ${_controladorNome.text}',
                style: TextStyle(color: Colors.white),
              ),
              criarCaixaEdicao(controlador: _controladorNome),
              SizedBox(height: 15),
              Text(
                'Idade: ${_controladorIdade.text}',
                style: TextStyle(color: Colors.white),
              ),
              criarCaixaEdicao(controlador: _controladorIdade),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 20, 150, 20),
                    onPressed: () {
                      final nome = _controladorNome.text;
                      final stringIdade = _controladorIdade.text;

                      try {
                        final idade = int.parse(stringIdade);
                        if (mounted) {
                          setState(() {
                            lista.add(Pessoa(nome, idade));
                            _controladorNome.clear();
                            _controladorIdade.clear();
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Você foi cadastrado com sucesso')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Idade inválida! Digite um número.")),
                        );
                      }
                    },
                    tooltip: 'Registrar',
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  FloatingActionButton(
                    onPressed: () => _atualizarPessoa(context),
                    tooltip: 'Atualizar',
                    backgroundColor: Color.fromARGB(255, 200, 200, 25),
                    child: Icon(Icons.update, color: Colors.white),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 255, 50, 50),
                    onPressed: () => _removerPessoa(context),
                    tooltip: 'Apagar',
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 20, 150, 20)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Voltar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
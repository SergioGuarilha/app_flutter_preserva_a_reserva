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
  // Controladores de texto
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorIdade = TextEditingController();
  Future<void> _removerPessoa(BuildContext context) async {
    // Mostra aba para escolher a pessoa a ser removida
    final Pessoa? pessoaSelecionada = await showDialog<Pessoa?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selecione quem remover'),
        content: SizedBox(
          width: double.maxFinite,
          // Mostra as pessoas atualmente na lista
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
      // Aba de confirmação
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
      //Remove a pessoa se operação é confirmada
      if (confirmado) {
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
    // Mostra aba para seleção de pessoa que terá seu cadastro atualizado
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

    if (pessoaSelecionada != null) {
      // Cria controladores temporários para edição na aba de diálogo
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

      if (confirmado) {
        final novoNome = nomeController.text;
        final novaIdadeStr = idadeController.text;

        try {
          final novaIdade = int.parse(novaIdadeStr);
          final index = lista.indexOf(pessoaSelecionada);
          if (index != -1) {
            setState(() {
              lista[index] = Pessoa(novoNome, novaIdade);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Dados atualizados com sucesso!')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Idade inválida! Digite um número.")),
          );
        }
      }

      // Desfaz os controladores temporários
      nomeController.dispose();
      idadeController.dispose();
    }
  }
  TextField criarCaixaEdicao({required TextEditingController controlador}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(constraints: BoxConstraints(maxWidth: 300)),
        controller: controlador
    );
  }

  @override
  //Função de desfazer os controladores
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
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.green,
                fontSize: 30
              ),
                'Área de cadastro e remoção de dados',
            ),
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
            Row(
              spacing: 10,
              children: [
                FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 20, 150, 20),
                  hoverColor: Colors.lightGreen,
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
                  tooltip: 'Registrar',
                  child: const Icon(
                      color: Colors.white,
                      Icons.add
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => _atualizarPessoa(context),
                  tooltip: 'Atualizar',
                  backgroundColor: Color.fromARGB(255, 75, 75, 255),
                  child: Icon(Icons.update, color: Colors.white), // Different color for update
                ),
                FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 255, 75, 75),
                  hoverColor: Colors.lightGreen,
                  onPressed: () => _removerPessoa(context),  // Updated to use the new method
                  tooltip: 'Apagar',
                  child: const Icon(
                      color: Colors.white,
                      Icons.remove
                  ),
                ),
                FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith((states) => Color.fromARGB(255, 20, 150, 20)),

                    ),
                    onPressed: ()=> Navigator.pop(context),
                    child: Text('Voltar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
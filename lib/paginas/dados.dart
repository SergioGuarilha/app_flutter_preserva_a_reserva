import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trabalho_av1_app_moveis/meu_scaffold.dart';
import 'package:trabalho_av1_app_moveis/pessoa.dart';
import 'package:trabalho_av1_app_moveis/lista.dart';
import 'package:path_provider/path_provider.dart';

class Dados extends StatefulWidget {
  const Dados({super.key});

  @override
  State<Dados> createState() => _EstadoPaginaDados();
}

class _EstadoPaginaDados extends State<Dados> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorIdade = TextEditingController();
  late Directory _diretorio;
  late File _arquivoDados;

  @override
  void initState() {
    super.initState();
    _inicializarArmazenamento().then((_) {
      debugPrint("Dados serão salvos em: ${_arquivoDados.path}");
      _carregarDados();
    });
  }

  Future<void> _inicializarArmazenamento() async {
    _diretorio = await getApplicationDocumentsDirectory();
    _arquivoDados = File('${_diretorio.path}/dados_pessoas.json');
  }

  Future<void> _carregarDados() async {
    try {
      if (await _arquivoDados.exists()) {
        final conteudo = await _arquivoDados.readAsString();
        final dados = jsonDecode(conteudo) as List;
        if (mounted) {
          setState(() {
            lista.clear();
            lista.addAll(dados.map((e) => Pessoa.fromJson(e)));
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  Future<void> _salvarDados() async {
    try {
      final dados = lista.map((pessoa) => pessoa.toJson()).toList();
      await _arquivoDados.writeAsString(jsonEncode(dados));
    } catch (e) {
      print('Erro ao salvar dados: $e');
    }
  }

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
        await _salvarDados();
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
          await _salvarDados();
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
                    onPressed: () async {
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
                          await _salvarDados();
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
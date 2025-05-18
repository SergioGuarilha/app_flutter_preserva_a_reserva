import 'package:flutter/material.dart';
import 'package:trabalho_av1_app_moveis/paginas/principal.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:trabalho_av1_app_moveis/pessoa.dart';
import 'package:trabalho_av1_app_moveis/lista.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para await no main
  await carregarListaPessoas(); // Carrega os dados antes de iniciar o app
  runApp(const MyApp());
}

Future<void> carregarListaPessoas() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final arquivo = File('${dir.path}/dados_pessoas.json');
    if (await arquivo.exists()) {
      final conteudo = await arquivo.readAsString();
      final dados = jsonDecode(conteudo) as List;
      lista.clear();
      lista.addAll(dados.map((e) => Pessoa.fromJson(e)));
    }
  } catch (e) {
    debugPrint('Erro ao carregar lista de pessoas: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Principal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

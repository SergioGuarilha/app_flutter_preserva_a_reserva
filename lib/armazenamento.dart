import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'lista.dart';
import 'pessoa.dart';

Future<void> inicializarDadosGlobais() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/dados_pessoas.json');

  if (await file.exists()) {
    final conteudo = await file.readAsString();
    final dados = jsonDecode(conteudo) as List;
    lista.clear();
    lista.addAll(dados.map((e) => Pessoa.fromJson(e)));
  }
}

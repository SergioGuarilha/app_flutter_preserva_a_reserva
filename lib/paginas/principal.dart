import 'package:flutter/material.dart';
import 'package:trabalho_av1_app_moveis/meu_scaffold.dart';
import './dados.dart';
import 'package:trabalho_av1_app_moveis/lista.dart';

class Principal extends StatelessWidget{
  const Principal({super.key});

  @override
  Widget build(BuildContext context){
    return MeuScaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text('Preserva Reserva')),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dados()),
                  );
                },
              child: Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Lista de Pessoas"),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true, // Ensures the ListView fits content
                        itemCount: lista.length,
                        itemBuilder: (context, index) {
                          final pessoa = lista[index]; // Get current Pessoa object
                          return ListTile(
                            title: Text(pessoa.nome),
                            subtitle: Text("Idade: ${pessoa.idade}"),
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Fechar"),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(Icons.smart_display),
            ),
          ],
        ),
      ),
    );
  }
}
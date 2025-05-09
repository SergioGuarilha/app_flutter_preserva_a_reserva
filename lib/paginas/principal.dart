import 'package:flutter/material.dart';
import 'package:trabalho_av1_app_moveis/paginas/livre.dart';
import 'package:trabalho_av1_app_moveis/meu_scaffold.dart';
import './dados.dart';
import 'package:trabalho_av1_app_moveis/lista.dart';

class Principal extends StatelessWidget{
  const Principal({super.key});

  @override
  Widget build(BuildContext context){
    return MeuScaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text('Preserva a Reserva')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                color: Colors.green,
                constraints: BoxConstraints(maxWidth: double.maxFinite, maxHeight: double.maxFinite),
                child: Text(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                ),
                    'Bem vindos à iniciativa Preserva a Reserva! O objetivo da iniciativa é preservar as reservas ambientais.'
                    ' Ao se cadastrar, você poderá participar de nossas atividades voluntariamente, e também poderá receber '
                    'certificados de contribuição!'),
              ),
              Column(
                children: [
                  Row(
                    spacing: 15,
                    children: [
                      Expanded(
                        child: Text(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            'Aba de cadastro/edição:'
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith((states) => Color.fromARGB(255, 20, 150, 20)),
                        ),
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dados()
                              ),
                            );
                          },
                        child: Icon(
                          size: 35,
                            color: Colors.white,
                            Icons.open_in_new
                        ),
                      ),
                    ],
                  ),
                Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      child: Text(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          'Lista de nossos membros:'
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith((states) => Color.fromARGB(255, 20, 150, 20)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Membros atuais"),
                            content: SingleChildScrollView(
                              child: SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true, // Ensures the ListView fits content
                                  physics: NeverScrollableScrollPhysics(),
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
                      child: Icon(
                        size: 35,
                          color: Colors.white,
                          Icons.list_alt
                          ),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: FloatingActionButton(
                    backgroundColor: WidgetStateColor.resolveWith((states) => Color.fromARGB(255, 20, 150, 20)),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Livre()
                          ),
                        );
                      },
                    child: Icon(
                      size: 100,
                        color: Colors.white,
                        Icons.emoji_nature_rounded
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
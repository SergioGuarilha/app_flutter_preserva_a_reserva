import 'package:flutter/material.dart';
import 'package:trabalho_av1_app_moveis/meu_scaffold.dart';

class Livre extends StatelessWidget {
  const Livre({super.key});
  @override

  Widget build(BuildContext context){
    return MeuScaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text('Preserva a Reserva')),
      ),
      body: Text('Pagina livre')
      );
  }
}

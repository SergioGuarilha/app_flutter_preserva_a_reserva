import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:trabalho_av1_app_moveis/meu_scaffold.dart';

class Livre extends StatelessWidget {
  const Livre({super.key});

  @override
  Widget build(BuildContext context) {
    return MeuScaffold(
        appBar: AppBar(
          title: Title(color: Colors.black, child: Text('Preserva a Reserva')),),
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
            scrollbars: true,
            ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
              _buildImage('recursos/IMG_0736.png'),
              _buildImage('recursos/IMG_0860.png'),
              _buildImage('recursos/Pica-pau-do-campo(M)4.png'),
              _buildImage('recursos/Pica-pau-rei2.png'),
              _buildImage('recursos/Sabiá-una(M)4.png'),
              _buildImage('recursos/Saí-andorinha(F)1.png'),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildImage(String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        path,
        width: 400,
        height: 300,
        fit: BoxFit.cover, // Ensures images maintain aspect ratio
      ),
    );
  }
}
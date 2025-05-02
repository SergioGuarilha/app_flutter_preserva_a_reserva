import 'package:flutter/material.dart';

class MeuScaffold extends StatelessWidget{
  final Widget appBar;
  final Widget body;

  const MeuScaffold({
    super.key,
    required this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 50, 0),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          color: Color.fromARGB(255, 10, 70, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.eco_sharp,
                color: Colors.lightGreen,
                size: 50,
              ),
              Text(
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.lime,
                      fontSize: 20
                  ),
                  'Preserva a Reserva'
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listaProfissional extends StatefulWidget {

  String especializacao;
  listaProfissional(this.especializacao);

  @override
  _listaProfissionalState createState() => _listaProfissionalState();
}

class _listaProfissionalState extends State<listaProfissional> {

  String es;

  @override
  void initState (){
    super.initState();
    es = widget.especializacao;
    print(es);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: Colors.black,
        title: Text("Se cuida aí"),
      ),
      body: Column(

      ),
    );
  }
}

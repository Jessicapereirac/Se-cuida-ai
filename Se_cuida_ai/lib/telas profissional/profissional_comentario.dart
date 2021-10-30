import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:Se_cuida_ai/telas%20paciente/paciente_perfildoFuncionario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class comentarios extends StatefulWidget {

  String p;
  comentarios(this.p);

  @override
  _comentariosState createState() => _comentariosState();
}

class _comentariosState extends State<comentarios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text("Se cuida aí"),
        ));

  }
}



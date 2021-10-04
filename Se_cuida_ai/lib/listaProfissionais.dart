import 'package:Se_cuida_ai/model/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'model/profissional.dart';

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

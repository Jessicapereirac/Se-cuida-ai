import 'package:Se_cuida_ai/telas%20paciente/principal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Paciente{

  String _nome;
  String _sobrenome;
  String _email;
  String _senha;
  String _dt_nascimento;
  String _numero_cel;
  String _genero;
  String _tipo;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Paciente();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map ={

     "nome" : this.nome,
     "sobrenome" : this.sobrenome,
     "email" : this.email,
     "dt_nascimento" : this.dt_nascimento,
     "numero_cel" : this.numero_cel,
     "genero" : this.genero,
     "tipo" : this.tipo

    };
    return map;
  }

  void atualizarDados (Paciente p, String _idUserLogado) async {

    db.collection("usuarios")
        .doc(_idUserLogado)
        .update(p.toMap());

  }

  String cadastrarUsuario(Paciente p, context) {

    auth.createUserWithEmailAndPassword(
        email: p.email,
        password: p.senha
    ).then((firebaseUser) {
      db.collection("usuarios")
          .doc(firebaseUser.user.uid)
          .set(p.toMap()).catchError((error){
        print("erro:::"+error.toString());
        return error.toString();

      });

      print("home paciente");
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => homePaciente()));
    }).catchError((error) {
      print("erro:::"+error.toString());
      return error.toString();
    });

  }


  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get genero => _genero;

  set genero(String value) {
    _genero = value;
  }

  String get numero_cel => _numero_cel;

  set numero_cel(String value) {
    _numero_cel = value;
  }

  String get dt_nascimento => _dt_nascimento;

  set dt_nascimento(String value) {
    _dt_nascimento = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get sobrenome => _sobrenome;

  set sobrenome(String value) {
    _sobrenome = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
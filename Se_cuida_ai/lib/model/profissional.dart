import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/geral_login.dart';

class Profissional
{
  String _nome;
  String _sobrenome;
  String _email;
  String _senha;
  String _dt_nascimento;
  String _numero_cel;
  String _genero;
  String _tipo;
  String _especializacao;
  String _registro;
  String _descricao;
  String _imgPerfil;
  String _uid;
  String _endereco;
  int _numComente;



  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Profissional();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map ={

      "nome" : this.nome,
      "sobrenome" : this.sobrenome,
      "email" : this.email,
      "dt_nascimento" : this.dt_nascimento,
      "numero_cel" : this.numero_cel,
      "genero" : this.genero,
      "tipo" : this.tipo,
      "especializacao" : this.especializacao,
      "registro" : this.registro,
      "descricao" : this.descricao,
      "imgPerfil" : this.imgPerfil,
      "senha" : this.senha,
      "uid" : this.uid,
      "endereco" : this.endereco,
      "numComente" : this.numComente

    };
    return map;
  }

  recuperar_uid() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User userLogado = await _auth.currentUser;
    String v = userLogado.uid;
    return v;
  }

  recuperar_unico_profissional() async {

    User userLogado = await _auth.currentUser;
    String _idUserLogado = userLogado.uid;

    DocumentSnapshot snapshot = await _db.collection("profissional")
        .doc(_idUserLogado)
        .get();

    Map<String, dynamic> dados = snapshot.data();

    return dados;
  }

  deletar_profissional(context) async{
    User userLogado = await _auth.currentUser;
    String _idUserLogado = userLogado.uid;
    userLogado.delete();

    _db.collection("profissional")
        .doc(_idUserLogado)
        .delete();
  }

  sair_profissional() async{await _auth.signOut();}

  void atualizarDados (Profissional p, String _idUserLogado) async {

    print(p.email);
    print(p.senha);

    _auth.signInWithEmailAndPassword(
        email: p.email,
        password: p.senha
    ).then((userCredencial){
      userCredencial.user.updateEmail(p.email).catchError((error){
        print("erro:::"+error.toString());
      });
    });

    _db.collection("profissional")
        .doc(_idUserLogado)
        .update(p.toMap());

  }

  Future<void> atualizar_favoritos(List profissional, String uid_paciente) async {

    Map<String, dynamic> map ={
      "profissionais" : profissional
    };

    _db.collection("favoritos")
        .doc(uid_paciente)
        .update(map);

  }

  String cadastrarUsuario(Profissional p, context) {

    _auth.createUserWithEmailAndPassword(
        email: p.email,
        password: p.senha
    ).then((firebaseUser) {
      p.uid = firebaseUser.user.uid;

      Map<String, dynamic> map ={
        "comentario" : []
      };

      _db.collection("favoritos")
          .doc(firebaseUser.user.uid)
          .set(map).catchError((error){
        print("erro:::"+error.toString());
        return error.toString();
      });

      _db.collection("profissional")
          .doc(firebaseUser.user.uid)
          .set(p.toMap() ).catchError((error){
            print("erro:::"+error.toString());
            return error.toString();

      });

      firebaseUser.user.sendEmailVerification().catchError((error) {
        print("erro:::"+error.toString());
        return error.toString();
      });

    }).catchError((error) {
      print("erro:::"+error.toString());
      return error.toString();
    });

    return "ok";

  }

  Future<List> recuperar_favoritos(String uid_paciente) async {

    QuerySnapshot querySnapshot = await _db.collection("favoritos").get();
    List<String> list = [];


    for (DocumentSnapshot item in querySnapshot.docs){

      if (item.id == uid_paciente){
        var dados = item.data();
        List d = dados.values.toList();

        for (var i in d){
          for(var j in i){

            list.add(j.toString());
          }
        }
      }

     }

    return list;
  }

  Future<List> filtrar_profissionais(String busca) async {

    QuerySnapshot querySnapshot = await _db.collection("profissional")
        .where("nome", isGreaterThanOrEqualTo: busca)
        .where("nome", isLessThanOrEqualTo: busca+"\uf8ff")
        .get();

    List<Profissional> list = [];

    for (DocumentSnapshot item in querySnapshot.docs){
      var dados = item.data();

      Profissional p = Profissional();

      p.nome = dados["nome"];
      p.sobrenome = dados["sobrenome"];
      p.email = dados["email"];
      p.senha = dados["senha"];
      p.genero = dados["genero"];
      p.numero_cel = dados["numero_cel"];
      p.dt_nascimento = dados["dt_nascimento"];
      p.tipo = dados["tipo"];
      p.registro = dados["registro"];
      p.especializacao = dados["especializacao"];
      p.descricao = dados["descricao"];
      p.imgPerfil = dados["imgPerfil"];
      p.uid = dados["uid"];
      p.endereco = dados["endereco"];
      p.numComente = dados["numComente"];

      list.add(p);
    }

    return list;


  }

  Future<List> recuperar_profissionais(String es) async {

    QuerySnapshot querySnapshot;

    if (es == ''){
      querySnapshot = await _db.collection("profissional").get();
    }
    else{
      querySnapshot = await _db.collection("profissional").where("especializacao", isEqualTo: es).get();
    }
    
    List<Profissional> list = [];

    for (DocumentSnapshot item in querySnapshot.docs){
      var dados = item.data();

      Profissional p = Profissional();

      p.nome = dados["nome"];
      p.sobrenome = dados["sobrenome"];
      p.email = dados["email"];
      p.senha = dados["senha"];
      p.genero = dados["genero"];
      p.numero_cel = dados["numero_cel"];
      p.dt_nascimento = dados["dt_nascimento"];
      p.tipo = dados["tipo"];
      p.registro = dados["registro"];
      p.especializacao = dados["especializacao"];
      p.descricao = dados["descricao"];
      p.imgPerfil = dados["imgPerfil"];
      p.uid = dados["uid"];
      p.endereco = dados["endereco"];
      p.numComente = dados["numComente"];

      list.add(p);
    }

    return list;
  }

  int get numComente => _numComente;

  set numComente(int value) {
    _numComente = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get registro => _registro;

  set registro(String value) {
    _registro = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get imgPerfil => _imgPerfil;

  set imgPerfil(String value) {
    _imgPerfil = value;
  }

  String get especializacao => _especializacao;

  set especializacao(String value) {
    _especializacao = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get genero => _genero;

  set genero(String value) {
    _genero = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
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
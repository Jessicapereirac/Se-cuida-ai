import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Paciente{

  String _nome;
  String _sobrenome;
  String _email;
  String _senha;
  String _dt_nascimento;
  String _numero_cel;
  String _genero;
  String _tipo;
  String _uid;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Paciente();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map ={
      "nome" : this.nome,
      "sobrenome" : this.sobrenome,
      "email" : this.email,
      "dt_nascimento" : this.dt_nascimento,
      "numero_cel" : this.numero_cel,
      "genero" : this.genero,
      "tipo" : this.tipo,
      "uid" : this.uid

    };
    return map;
  }

  Future<List> profissionais_favoritos(List favoritos) async {

    QuerySnapshot querySnapshot = await _db.collection("profissional").get();
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

      if (favoritos.contains(p.uid)){list.add(p);}
    }

    return list;
  }

  void atualizarDados (Paciente p, String _idUserLogado) async {

    _db.collection("usuarios")
        .doc(_idUserLogado)
        .update(p.toMap());

  }

  String cadastrarUsuario(Paciente p, context) {

    _auth.createUserWithEmailAndPassword(
        email: p.email,
        password: p.senha
    ).then((firebaseUser) {
      p.uid = firebaseUser.user.uid;

      Map<String, dynamic> map ={
        "profissionais" : []
      };

      _db.collection("favoritos")
          .doc(firebaseUser.user.uid)
          .set(map).catchError((error){
        print("erro:::"+error.toString());
        return error.toString();
      });

      _db.collection("usuarios")
          .doc(firebaseUser.user.uid)
          .set(p.toMap()).catchError((error){
        print("erro:::"+error.toString());
        return error.toString();

      });


    }).catchError((error) {
      print("erro:::"+error.toString());
      return error.toString();
    });

    return "ok";

  }


  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
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
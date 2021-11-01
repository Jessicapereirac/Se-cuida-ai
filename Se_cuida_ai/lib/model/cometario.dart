import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comentario {

  String _id;
  String _experiencia;
  String _comentario;
  String _uidDono;
  String _uidProfissional;


  FirebaseFirestore _db = FirebaseFirestore.instance;

  Comentario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "experiencia": this.experiencia,
      "comentario": this.comentario,
      "uidDono": this.uidDono,
      "uidProfissional": this.uidProfissional
    };
    return map;
  }

  criarcomentario(Comentario c) {

    _db.collection("comentarios")
        .add(c.toMap()).catchError((error) {
      print("erro:::" + error.toString());
      return error.toString();
    });

  }
  remove_comentario(String id) async {

    QuerySnapshot querySnapshot = await _db.collection("comentarios").where("id", isEqualTo: id).get();
    var documentID;

    for (var snapshot in querySnapshot.docs) {documentID = snapshot.id;}
    print(documentID);

    _db.collection("comentarios").doc(documentID.toString()).delete();

  }

  recuperar_comentario(String _uidProfissonal) async {

    QuerySnapshot querySnapshot = await _db.collection("comentarios")
        .where("uidProfissional", isEqualTo: _uidProfissonal)
        .get();

    List<Comentario> list = [];

    for (DocumentSnapshot item in querySnapshot.docs){

      var dados = item.data();

      Comentario c = Comentario();

      c.id =dados ["id"];
      c.experiencia = dados["experiencia"];
      c.comentario = dados["comentario"];
      c.uidDono = dados["uidDono"];
      c.uidProfissional = dados["uidProfissonal"];

      list.add(c);

    }

    return list;
  }

  String get experiencia => _experiencia;

  set experiencia(String value) {
    _experiencia = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get comentario => _comentario;

  set comentario(String value) {
    _comentario = value;
  }

  String get uidDono => _uidDono;

  set uidDono(String value) {
    _uidDono = value;
  }

  String get uidProfissional => _uidProfissional;

  set uidProfissional(String value) {
    _uidProfissional = value;
  }

}

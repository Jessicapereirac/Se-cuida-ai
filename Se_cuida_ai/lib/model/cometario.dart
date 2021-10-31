import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comentario {

  String _experiencia;
  String _comentario;
  String _uidDono;
  String _uidProfissional;


  FirebaseFirestore _db = FirebaseFirestore.instance;

  Comentario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "experiencia": this.experiencia,
      "comentario": this.comentario,
      "uidDono": this.uidDono,
      "uidProfissional": this.uidProfissional
    };
    return map;
  }

  criarcomentario(Comentario c) {

    List ex = [];
    ex.add(c);
    print(ex);

    Map<String, dynamic> map ={
      "comentario" : c.comentario,
      "uidDono" : c.uidDono,
      "uidProfissional" : c.uidProfissional,
      "experiencia" : c.experiencia
    };
    ex.add(map);

    _db.collection("comentario")
        .doc(c.uidProfissional)
        .update(map).catchError((error) {
      print("erro:::" + error.toString());
      return error.toString();
    });

  }

  recuperar_comentario(String _idProfissonal) async {

    QuerySnapshot querySnapshot;

    querySnapshot = await _db.collection("comentario").where("uidProfissional", isEqualTo: _idProfissonal).get();

    List<Comentario> list = [];

    for (DocumentSnapshot item in querySnapshot.docs){
      var dados = item.data();

      Comentario c = Comentario();

      c.experiencia = dados["experiencia"];
      c.comentario = dados["comentario"];
      c.uidDono = dados["uidDono"];
      c.uidProfissional = dados["uidProfissional"];

      list.add(c);
    }

    return list;
  }

  String get experiencia => _experiencia;

  set experiencia(String value) {
    _experiencia = value;
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

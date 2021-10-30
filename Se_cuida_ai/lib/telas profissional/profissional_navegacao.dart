import 'dart:io' show Platform;
import 'package:Se_cuida_ai/telas%20paciente/paciente_comentario.dart';
import 'package:Se_cuida_ai/telas%20profissional/profissional_comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/profissional.dart';

class pagProfissional extends StatefulWidget {

  String uid;
  pagProfissional(this.uid);

  @override
  _pagProfissionalState createState() => _pagProfissionalState();
}

class _pagProfissionalState extends State<pagProfissional> {

  Profissional p = Profissional();

_recuperarDadosUser() async {

    String _idUserLogado = widget.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("profissional")
        .doc(_idUserLogado)
        .get();

    Map<String, dynamic> dados = snapshot.data();

    p.email = dados["email"];
    p.dt_nascimento = dados["dt_nascimento"];
    p.nome = dados["nome"];
    p.imgPerfil = dados["imgPerfil"];
    p.sobrenome = dados["sobrenome"];
    p.especializacao = dados["especializacao"];
    p.numero_cel = dados["numero_cel"];
    p.genero = dados["genero"];
    p.descricao = dados["descricao"];
    p.registro = dados["registro"];
    p.tipo = dados["tipo"];
    p.senha = dados["senha"];
    p.uid = dados["uid"];
    p.endereco = dados["endereco"];

    return dados;

  }

  _compartilhar(){
    Share.share("Olha esse profissional que eu entrei no 'Se cuida aí '");
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
  }

  Widget build(BuildContext context) {
    _recuperarDadosUser();
    return Scaffold(
      body: p.uid != null
          ?SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment : MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  (p.imgPerfil != null && p.uid!= null)
                  ? Image.network(p.imgPerfil, height: 185, width:155,fit: BoxFit.fill)
                  : Image.asset('images/user_icon.png', height: 155, width:155,fit: BoxFit.fill)
                  ,SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 12.0),
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            p.nome,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            p.especializacao,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child:IconTile(
                                    backColor: Color(0xffFEF2F0),
                                    imgAssetPath: "images/share.png",
                                  ),
                                  onTap: (){_compartilhar();},
                                ),
                                GestureDetector(
                                    child:IconTile(
                                      backColor: Color(0xffFFECDD),
                                      imgAssetPath: "images/comente.png",
                                    ),
                                    onTap:(){
                                      setState(() {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => comentarios()));

                                      });}
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Sobre",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                p.descricao,
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset("images/mappin.png"),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Endereço",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 268,
                                  child: Text(
                                    p.endereco,
                                    style: TextStyle(color: Colors.black38),
                                  ))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                  Image.asset(
                    "images/map.png",
                    width: 180,
                  )
                ],
              ),
              Text(
                "Acões",
                style: TextStyle(
                    color: Color(0xff242424),
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Container(
                padding: EdgeInsets.only(right:15, left: 18),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 22,horizontal: 16),
                          decoration: BoxDecoration(
                              color: Color(0xffFBB97C),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFCCA9B),
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                  child: Image.asset("images/comente.png")),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                child: Text(
                                  "Comentarios sobre você",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap:(){
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => comentarios()));

                        });} ,
                    ),

                  ],
                ),)
            ],
          ),
        ),

      )
      :Center(child: CircularProgressIndicator(),),
    );
  }
}

class IconTile extends StatelessWidget {
  final String imgAssetPath;
  final Color backColor;

  IconTile({this.imgAssetPath, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Image.asset(
          imgAssetPath,
          width: 20,
        ),
      ),
    );
  }
}


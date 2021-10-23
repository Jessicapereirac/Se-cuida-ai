import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../model/profissional.dart';

class pagProfissional extends StatefulWidget {

  String uid;
  pagProfissional(this.uid);

  @override
  _pagProfissionalState createState() => _pagProfissionalState();
}

class _pagProfissionalState extends State<pagProfissional> {

  Profissional p = Profissional();

  Future<void> _recuperarDadosUser() async {

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


  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: HexColor('#f6d7c0'),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 255,
                  width: 255,
                  child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0x9FF5FAF9),
                          radius: 165,
                          backgroundImage: p.imgPerfil == null
                              ? AssetImage("images/user_icon.png")
                              : NetworkImage(p.imgPerfil),
                        )])),
              Padding(
                  padding: EdgeInsets.only(top:18, bottom: 8, right:8, left:8),
                  child: Text(
                    p.nome +' '+ p.sobrenome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 25,fontWeight: FontWeight.w400 ,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Registro profissional: "+ p.registro,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 20,fontWeight: FontWeight.w400 ,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 28),
                  child: Text(
                    "Especialização: "+ p.especializacao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 20,fontWeight: FontWeight.w400 ,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left:50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      RawMaterialButton(
                        elevation: 3.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Icon(Icons.call, color: Colors.black,size: 40),
                        padding: EdgeInsets.all(25.0),
                        shape: CircleBorder(),
                        onPressed: () {},
                      ),
                      RawMaterialButton(
                        elevation: 2.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Tab(icon: Image.asset('images/icon-whatsApp.png', width: 70, height: 70),),
                        padding: EdgeInsets.all(25.0),
                        shape: CircleBorder(),
                        onPressed: () {},
                      ),
                      RawMaterialButton(
                        elevation: 2.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Icon(CupertinoIcons.share, color: Colors.black,size: 40,),
                        padding: EdgeInsets.all(25.0),
                        shape: CircleBorder(),
                        onPressed: () {},
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}

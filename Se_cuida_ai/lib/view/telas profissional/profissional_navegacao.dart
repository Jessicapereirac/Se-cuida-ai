import 'dart:io' show Platform;
import 'package:Se_cuida_ai/model/cometario.dart';
import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:Se_cuida_ai/view/telas%20profissional/profissional_comentario.dart';import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../controller.dart';


class pagProfissional extends StatefulWidget {

  String uid;
  pagProfissional(this.uid);

  @override
  _pagProfissionalState createState() => _pagProfissionalState();
}

class _pagProfissionalState extends State<pagProfissional> {

  Profissional p = Profissional();
  Comentario _comentarioHelp = Comentario();
  Profissional _profissionalHelp = Profissional();
  List<Comentario> comente = [];
  int num_comente ;
  String _idUserLogado;
  Controller controller = Controller ();

  _recuperarDadosUser() async {

    p = await controller.recuperarDados() ;
    _idUserLogado = widget.uid;

    return p;
  }

  _recuperar_comentarios() async {
    String id = _idUserLogado;

    List c = await _comentarioHelp.recuperar_comentario(id);

    List<Comentario> temp = [];

    for (var i in c) {
      temp.add(i);
    }

    setState(() {
      comente = temp;
      num_comente =comente.length;
    });

    temp = null;
  }

  _compartilhar(){
    Share.share("Olha esse profissional que eu entrei no 'Se cuida aí '");
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
    _recuperar_comentarios();
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
                                        child:Container(
                                          height: 55,
                                          child:Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              IconTile(
                                                backColor: Color(0xffFFECDD),
                                                imgAssetPath: "images/comente.png",
                                              ),
                                              num_comente > p.numComente ?
                                              Positioned(top: 0, right:0 ,bottom: 35, left: 12,
                                                child: Container(

                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                  alignment: Alignment.center,
                                                  child: Text((num_comente - p.numComente).toString(), style: TextStyle(color: Colors.white),),
                                                ),
                                              )
                                                  : Container(),

                                            ],
                                          ),
                                        ),
                                        onTap:(){
                                          setState(() {
                                            p.numComente = num_comente;
                                            _profissionalHelp.atualizarDados(p, p.uid);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) => comentarios(p)));

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
                          p.numComente = num_comente;
                          _profissionalHelp.atualizarDados(p, p.uid);
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => comentarios(p)));

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


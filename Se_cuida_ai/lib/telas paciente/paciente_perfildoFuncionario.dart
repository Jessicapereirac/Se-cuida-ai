
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/profissional.dart';

class perfilProfissional extends StatefulWidget {

  Profissional p;
  perfilProfissional(this.p);

  @override
  _perfilProfissionalState createState() => _perfilProfissionalState();
}

class _perfilProfissionalState extends State<perfilProfissional>{

  Profissional profissional = Profissional();
  Profissional _profissionalHelp = Profissional();
  List<String> favoritos = [];
  String _idUserLogado;

  Future<List<Profissional>> _recuperar_favoritos() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;

    List fav = await  _profissionalHelp.recuperar_favoritos(_idUserLogado);

    List<String> temp2 = [];

    for (var j in fav){
      temp2.add(j);
    }

    setState(() {
      favoritos =  temp2;
    });

    temp2 = null;

    return fav;

  }

  void _favorito(String uid_profissional) {

    if(favoritos.contains(uid_profissional)){
      favoritos.remove(uid_profissional);
    }else{
      favoritos.add(uid_profissional);
    }
    _profissionalHelp.atualizar_favoritos(favoritos, _idUserLogado);
  }

  Future<String> _recuperarDadosUser() async {

    profissional.nome = widget.p.nome;
    profissional.sobrenome = widget.p.sobrenome;
    profissional.email = widget.p.email;
    profissional.senha = widget.p.senha;
    profissional.dt_nascimento = widget.p.dt_nascimento;
    profissional.tipo = widget.p.tipo;
    profissional.genero = widget.p.genero;
    profissional.numero_cel = widget.p.numero_cel;
    profissional.registro = widget.p.registro;
    profissional.especializacao = widget.p.especializacao;
    profissional.descricao = widget.p.descricao;
    profissional.imgPerfil = widget.p.imgPerfil;
    profissional.endereco = widget.p.endereco;
    profissional.uid = widget.p.uid;

    return 'ok';

  }

  _ligacao() async {
    String url = "tel:"+profissional.numero_cel;
    print(url);
    if(await canLaunch(url)){
      await launch(url);
    }else{
      print('erro');
      return "erro";
    }

  }

  _whatsapp() async{

    String url = "+"+profissional.numero_cel;
    if(Platform.isIOS){
      var ios = "https://wa.me/$url?text=${Uri.parse("Olá, vim do Se cuida aí")}";
      if(await canLaunch(ios)){
        await launch(ios);

      }else{print("erro");}} else{
      var android = "whatsapp://send?phone="+url+"&text=Olá, vim do Se cuida aí";
      if(await canLaunch(android)){
        await launch(android);
      }else{print("erro");}
    }
  }

  _compartilhar(){
    Share.share("Olha esse profissional que eu entrei no 'Se cuida aí '");
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
    _recuperar_favoritos();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      title: Text("Se cuida aí"),
    ),
      body: SingleChildScrollView(
        child: Container(

          padding: EdgeInsets.fromLTRB(15, 5, 8, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment : MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(profissional.imgPerfil, height: 190, width:160,fit: BoxFit.fill),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left:10),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          profissional.nome,
                          style: TextStyle(fontSize: 32),
                        ),
                        Text(
                          profissional.especializacao,
                          style: TextStyle(fontSize: 19, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              child:IconTile(
                                backColor: Color(0xffFFECDD),
                                imgAssetPath: "images/share.png",
                              ),
                              onTap: (){_compartilhar();},
                            ),
                            GestureDetector(
                              child:IconTile(
                                backColor: Color(0xffFEF2F0),
                                imgAssetPath: "images/call.png",
                              ),
                              onTap: (){_ligacao();}
                            ),
                            GestureDetector(
                              child:IconTile(
                                backColor: Color(0xffEBECEF),
                                imgAssetPath: "images/icon-whatsApp.png",
                              ),
                              onTap: (){_whatsapp();},
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 22,
              ),
              Text(
                "Sobre",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                profissional.descricao,
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
                                    profissional.endereco,
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 24,horizontal: 16),
                      decoration: BoxDecoration(
                          color: Color(0xffFBB97C),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(child:Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Color(0xffFCCA9B),
                                  borderRadius: BorderRadius.circular(16)
                              ),
                              child: Image.asset("images/comente.png"))),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width/2 - 130,
                              child: Text(
                                "Comente aqui",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 17),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 22,horizontal: 16),
                      decoration: BoxDecoration(
                          color: Color(0xffA5A5A5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Color(0xffBBBBBB),
                                  borderRadius: BorderRadius.circular(16)
                              ),
                              child: Image.asset("images/like.png")),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  _favorito(profissional.uid);
                                });},
                              child: favoritos.contains(profissional.uid)
                                  ? Container(width: MediaQuery.of(context).size.width/2 - 130,child: Text("Salvo",style: TextStyle(color: Colors.white,fontSize: 17),),)
                                  : Container(width: MediaQuery.of(context).size.width/2 - 130,child: Text("Salvar",style: TextStyle(color: Colors.white,fontSize: 17),),)

                          )],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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


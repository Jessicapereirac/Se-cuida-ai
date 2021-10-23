import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../model/profissional.dart';

class perfilProfissional extends StatefulWidget {

  Profissional p;
  perfilProfissional(this.p);

  @override
  _perfilProfissionalState createState() => _perfilProfissionalState();
}

class _perfilProfissionalState extends State<perfilProfissional> {

  Profissional profissional = Profissional();

  Future<void> _recuperarDadosUser() async {

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

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text("Se cuida aí"),
        ),
        backgroundColor: HexColor('#f6d7c0'),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(profissional.nome),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left:50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      RawMaterialButton(
                        elevation: 2.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Icon(Icons.call, color: Colors.black,size: 40),
                        padding: EdgeInsets.all(20.0),
                        shape: CircleBorder(),
                        onPressed: () {},
                      ),
                      RawMaterialButton(
                        elevation: 2.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Tab(icon: Image.asset('images/icon-whatsApp.png', width: 80, height: 80, ),),
                        padding: EdgeInsets.all(20.0),
                        shape: CircleBorder(),
                        onPressed: () {},
                      ),
                      RawMaterialButton(
                        elevation: 2.0,
                        fillColor: Color(0xFFF5F6F9),
                        child: Icon(CupertinoIcons.share, color: Colors.black,size: 40,),
                        padding: EdgeInsets.all(20.0),
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

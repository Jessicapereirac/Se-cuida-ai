import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'model/profissional.dart';
import 'model/paciente.dart';

class perfilUser extends StatefulWidget {

  @override
  _perfilUserState createState() => _perfilUserState();
}

class _perfilUserState extends State<perfilUser> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSobrenome = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  String  _idUserLogado;
  File _imgtemp;
  bool _statusUpload = false;
  String _urlperfil;
  Profissional p = Profissional();
  
  _recuperarDadosUser() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
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


    _controllerNome.text = dados["nome"];
    //_controllerEmail.text = dados["email"];
    _controllerSobrenome.text = dados["sobrenome"];
    _controllerDescricao.text = dados["descricao"];
    _urlperfil = dados["imgPerfil"];

  }

  Future _recuperandoUrl(TaskSnapshot taskSnapshot) async {
    String url = await taskSnapshot.ref.getDownloadURL();
    p.imgPerfil = url;

    setState(() {
      p.atualizarDados(p,_idUserLogado);
    });
  }
  Future _selectImagem( String origem) async {

    switch (origem){
      case "c":
        _imgtemp = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "g":
        _imgtemp = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;

    }
    setState(() {

      if(_imgtemp != null){
        _updateImagem();
      }

    });

  }

  _atualizarDados(){

    p.nome = _controllerNome.text;
    p.sobrenome = _controllerSobrenome.text;
    p.descricao = _controllerDescricao.text;
    /*p.dt_nascimento = dados["dt_nascimento"];
    p.imgPerfil = dados["imgPerfil"];
    p.sobrenome = dados["sobrenome"];
    p.especializacao = dados["especializacao"];
    p.numero_cel = dados["numero_cel"];
    p.genero = dados["genero"];
    p.descricao = dados["descricao"];*/

    p.atualizarDados(p, _idUserLogado);

  }

  Future _updateImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arq = pastaRaiz
    .child("perfil")
    .child(_idUserLogado.toString()+".jpg");

    UploadTask task = arq.putFile(_imgtemp);

    task.snapshotEvents.listen((TaskSnapshot taskSnapshot){

      if(taskSnapshot.state == TaskState.running){
        setState(() {
          _statusUpload = true;
        });
      }
      else if(taskSnapshot.state == TaskState.success){
        _recuperandoUrl(taskSnapshot);
        setState(() {
          _statusUpload = false;

        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          backgroundColor: HexColor('#FFC75F'),
          title: Text("Se cuida aí"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _statusUpload ?Row(mainAxisAlignment: MainAxisAlignment.spaceAround , children: [Container(child: CircularProgressIndicator(),height: 50,  color:HexColor('#FFC75F'))],)
                  :Container(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    color: HexColor('#FFC75F'),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                      child: SizedBox(
                        height: 135,
                        width: 135,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(

                              backgroundColor: Color(0x9FF5FAF9),
                              backgroundImage: _urlperfil == null
                                  ? AssetImage("images/user_icon.png")
                                  : NetworkImage(_urlperfil),
                            ),
                            Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context)=> CupertinoActionSheet(
                                          title: Text("Editar Foto", style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20
                                          )),
                                          actions: [
                                            CupertinoActionSheetAction(
                                                onPressed: () async {
                                                  _selectImagem("c");
                                                },
                                                child: Text("Câmera", style: TextStyle(
                                                    color: Colors.black
                                                )
                                                )),
                                            CupertinoActionSheetAction(
                                                onPressed: () async {
                                                  _selectImagem("g");
                                                },
                                                child: Text("Galeria", style: TextStyle(
                                                    color: Colors.black
                                                )
                                                ))
                                          ],
                                          cancelButton: CupertinoActionSheetAction(
                                              isDefaultAction: true,
                                              onPressed: (){Navigator.pop(context, "Cancelar");},
                                              child: Text("Cancelar", style: TextStyle(
                                                  color: Colors.black)
                                              )),
                                        ));
                                  },
                                  elevation: 2.0,
                                  fillColor: Color(0xFFF5F6F9),
                                  child: Icon(Icons.camera_alt_outlined, color: Colors.black,),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                )),
                          ],
                        ),
                      ),)


                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 8),
                  child: TextField(
                    autofocus: true,
                    controller: _controllerNome,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: TextField(
                    controller: _controllerSobrenome,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: TextField(
                    controller: _controllerDescricao,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 2,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 20),
                        hintMaxLines: 3,
                        hintText: "Descrição: Diga algo que você quer que seus pacientes vejam",
                        hintStyle: TextStyle(fontSize: 18),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32
                                  ))),

                        ),
                        child: Text(
                            "Salvar",
                            style: TextStyle(color: Colors.white, fontSize: 22)),
                        onPressed: () {
                          _atualizarDados();

                        },

                      )
                    ],
                  )
              ),
            ],
          ),
        )


    );
  }
}

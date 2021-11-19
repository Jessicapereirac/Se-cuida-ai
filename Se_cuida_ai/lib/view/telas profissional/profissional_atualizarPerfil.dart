import 'dart:io';
import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controller.dart';

class atualizarPerfil extends StatefulWidget {

  @override
  _atualizarPerfilState createState() => _atualizarPerfilState();
}

class _atualizarPerfilState extends State<atualizarPerfil> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSobrenome = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();

  String  _idUserLogado;
  File _imgtemp;
  bool _statusUpload = false;
  String _urlperfil;
  String msgError = "";

  Controller controller = Controller();
  Profissional p = Profissional();

  void _validarDados(){
    String nome = _controllerNome.text;
    String sobrenome = _controllerSobrenome.text;
    String email = _controllerEmail.text;
    String cel = _controllerCelular.text;
    String endereco = _controllerEndereco.text;

    if(nome.length > 2){
      if(sobrenome.length > 2){
        if(email.isNotEmpty && email.contains("@")){
          if(cel.isNotEmpty && cel.length == 11){
            if(endereco.isNotEmpty && endereco.length>10){
              setState(() {
                msgError = "";
              });

              _atualizarDados();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // retorna um objeto do tipo Dialog
                    return AlertDialog(
                      title: new Text("Dados atualizados com sucesso!"),
                      actions: <Widget>[
                        // define os botões na base do dialogo
                        TextButton(
                          child: new Text("Ok"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );


            } else{
              setState(() {
                msgError = "Insira um endereco de celular  valido";
              });
            }
            
            }else{
          setState(() {
            msgError = "Insira um número de celular  valido";
          });
        }
        } else{
          setState(() {
            msgError = "Insira um email valido";
          });
        }} else{
        setState(() {
          msgError = "Insira um sobrenome valido";
        });
      }} else{
      setState(() {
        msgError = "Insira um nome valido";
      });
    }
  }

  void _recuperarDadosUser() async {

    p = await controller.recuperarDados();
    if(p == null){print("erro dados recuperados"); return;}
    print(p.uid);
    _idUserLogado = p.uid;
    _controllerNome.text = p.nome;
    _controllerEmail.text = p.email;
    _controllerSobrenome.text = p.sobrenome;
    _controllerDescricao.text = p.descricao;
    _controllerCelular.text =  p.numero_cel;
    _controllerEndereco.text =  p.endereco;
    _urlperfil = p.imgPerfil;
    print("foi");
  }

  void _atualizarDados() {

    p.nome = _controllerNome.text;
    p.sobrenome = _controllerSobrenome.text;
    p.descricao = _controllerDescricao.text;
    p.numero_cel = _controllerCelular.text;
    p.email = _controllerEmail.text;
    p.endereco =  _controllerEndereco.text;

    p.atualizarDados(p, _idUserLogado);

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
      _updateImagem();
    });

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
        body: SingleChildScrollView(
          child: Expanded(
            child:Column(
              children: [
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
                      _statusUpload
                          ? Container(child:CircularProgressIndicator(),height: 50, width: 50,)
                          : Container(),
                      Expanded(
                        child:Padding(padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                          child: SizedBox(
                            height: 135,
                            width: 135,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0x9FF5FAF9),
                                  backgroundImage: p.imgPerfil == null
                                      ? AssetImage("images/user_icon.png")
                                      : NetworkImage(p.imgPerfil),
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
                      )


                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(32, 5, 32, 0),
                  child: Center(
                    child: Text(msgError,style: TextStyle(color: Colors.red, fontSize: 12)),
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
                          hintText: "Sobrenome",
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
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Email",
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
                    child: IntlPhoneField(
                      controller: _controllerCelular,
                      decoration: InputDecoration(
                        labelText: 'Número de Telefone',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'BR',

                    )
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    child: TextField(
                      controller: _controllerEndereco,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 2,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 20),
                          hintMaxLines: 3,
                          hintText: "Endereço: Rua, numero - bairo, cidade - cep",
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
                            _validarDados();

                          },

                        ),

                      ],
                    )
                ),
              ],
            )
          )
        )


    );
  }
}

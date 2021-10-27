import 'dart:io';
import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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

  String  _idUserLogado;
  File _imgtemp;
  bool _statusUpload = false;
  String _urlperfil;
  Profissional p = Profissional();
  String msgError = "";

  void _validarDados(){
    String nome = _controllerNome.text;
    String sobrenome = _controllerSobrenome.text;
    String email = _controllerEmail.text;
    String cel = _controllerCelular.text;

    if(nome.length > 2){
      if(sobrenome.length > 2){
        if(email.isNotEmpty && email.contains("@")){
          if(cel.isNotEmpty && cel.length == 11){
            setState(() {
              msgError = "";
            });
            _atualizarDados();

          } else{
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

  void _recuperarDadosUser() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;
    print(_idUserLogado);

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

    _controllerNome.text = dados["nome"];
    _controllerEmail.text = dados["email"];
    _controllerSobrenome.text = dados["sobrenome"];
    _controllerDescricao.text = dados["descricao"];
    _controllerCelular.text =  dados["numero_cel"];
    _urlperfil = dados["imgPerfil"];

  }

  void _atualizarDados() {

    p.nome = _controllerNome.text;
    p.sobrenome = _controllerSobrenome.text;
    p.descricao = _controllerDescricao.text;
    p.numero_cel = _controllerCelular.text;

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: p.email,
        password: p.senha
    ).then((userCredencial){
      userCredencial.user.updateEmail(_controllerEmail.text).catchError((error){
        print("erro:::"+error.toString());
      });
    });

    p.email = _controllerEmail.text;
    print(p.imgPerfil);
    print(_urlperfil);
    p.atualizarDados(p, _idUserLogado);


  }

  Future _recuperandoUrl(TaskSnapshot taskSnapshot) async {
    String url = await taskSnapshot.ref.getDownloadURL();
    print(url);
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
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
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

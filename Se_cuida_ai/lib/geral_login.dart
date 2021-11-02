import 'dart:async';

import 'package:Se_cuida_ai/geral_cadastro.dart';
import 'package:Se_cuida_ai/telas%20paciente/paciente_principal.dart';
import 'package:Se_cuida_ai/telas%20profissional/profissional_principal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String msgErro = "";
  Timer timer;

  Future _rLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    bool a= await verifica();

    if(userLogado != null){
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await db.collection("usuarios")
          .doc(userLogado.uid)
          .get();

      Map<String, dynamic> dados = snapshot.data();


      //if(a){
        //timer.cancel();
        if (dados != null && dados["tipo"] == "0" ){
          print("home paciente");
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => homePaciente()));
        }
        else{
          print("home profissional");
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => homeProfissional()));
        }
     /* }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return AlertDialog(
              title: new Text("Email de verificação"),
              content: new Text("Verifique seu email!"),
              actions: <Widget>[
                // define os botões na base do dialogo
                new TextButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

      }*/
    }

  }

  void _validarDados() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains("@")){
      msgErro = "";
      if(senha.isNotEmpty && senha.length > 5 ){
        setState(() {
          msgErro = "";
        });
       _entrar(email, senha);

      } else{
        setState(() {
          msgErro = "Senha invalida";
        });
      }}
    else{
      setState(() {
        msgErro = "Email invalido";
      });
    }
  }

  verifica() async {
    await auth.currentUser.reload();
    return auth.currentUser.emailVerified;

  }

  Future<void> _entrar( String email, String senha) async {

    //await auth.currentUser.reload();
   // bool a= await verifica();
    auth.signInWithEmailAndPassword(
        email: email,
        password: senha
    ).then((firebaseUser) async {

      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await db.collection("usuarios")
          .doc(firebaseUser.user.uid)
          .get();

      Map<String, dynamic> dados = snapshot.data();


      //if (a){
        if (dados != null && dados["tipo"] == "0"){
          print("home paciente");
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => homePaciente()));
        }
        else{
          print("home profissional");
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => homeProfissional()));
        }
      /*}else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return AlertDialog(
              title: new Text("Email de verificação"),
              content: new Text("Verifique seu email!"),
              actions: <Widget>[
                // define os botões na base do dialogo
                new TextButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }*/
    }).catchError((error){
      print(error.toString());
      setState(() {
        msgErro = "Login ou senha invalidos, verfique e tente novamente";
      });
    });
  }

  @override
  void initState() {
    //_verificarLogado();
    //timer = Timer.periodic(Duration(seconds: 2), (timer){
      //verifica();
    //});
    super.initState();

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text("Se cuida aí"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white60
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 26),
                  child: Image.asset(
                    "images/logo.png",
                    width: 250,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      )
                    ),
                  )
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                      )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32
                                ))),

                      ),
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 22)),
                      onPressed: () {

                        _validarDados();
                      },

                    )
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? Cadastre-se!",
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    ),
                    onTap: (){
                      print("tela cadastro");
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => cadastroGeral()));
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Center(
                  child: Text(msgErro,style: TextStyle(color: Colors.red, fontSize: 12)),
                ))
              ],
            ),

          ),
        ),

      ),

    );
  }
}

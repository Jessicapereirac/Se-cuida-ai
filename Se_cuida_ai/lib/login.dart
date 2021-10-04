import 'package:Se_cuida_ai/cadastroGeral.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class login extends StatefulWidget {
  const login({key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String msgErro = "";

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

  void _entrar( String email, String senha){
    FirebaseAuth auth = FirebaseAuth.instance;
    print(email);
    print(senha);

    auth.signInWithEmailAndPassword(
        email: email,
        password: senha
    ).then((firebaseUser){

      print("tela inicial");
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => telaInicial()));

    }).catchError((error){
      setState(() {
        msgErro = "Login ou senha invalidos, verfique e tente novamente";
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class perfilUser extends StatefulWidget {

  @override
  _perfilUserState createState() => _perfilUserState();
}

class _perfilUserState extends State<perfilUser> {

  TextEditingController _controllerNome = TextEditingController();
  String  _idUserLogado;
  
  _recuperarDadosUser() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;
    print(userLogado.uid);
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
    .doc(_idUserLogado)
    .get();

    Map<String, dynamic> dados = snapshot.data();

    _controllerNome.text = dados["nome"];


  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUser();
  }

  Widget build(BuildContext context) {
    print(_idUserLogado);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          backgroundColor: HexColor('#FFC75F'),
          title: Text("Se cuida aí"),
        ),
        body: Column(
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

                         // backgroundImage: AssetImage("assets/images/Profile Image.png"),
                        ),
                        Positioned(
                            bottom: 0,
                            right: -25,
                            child: RawMaterialButton(
                              onPressed: () {},
                              elevation: 2.0,
                              fillColor: Color(0xFFF5F6F9),
                              child: Icon(Icons.camera_alt_outlined, color: Colors.black,),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            )),
                      ],
                    ),
                  ),),

                ],
              ),
            ),
          ],
        )

    );
  }
}

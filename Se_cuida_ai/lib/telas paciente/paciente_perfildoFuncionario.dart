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

    return 'ok';

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
            child: FutureBuilder(
                future: _recuperarDadosUser(),
                builder: (context, snapshot){
                  if(snapshot.hasData){

                    return SingleChildScrollView(
                        child:Padding(padding: EdgeInsets.only(top:20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 220,
                                    width: 220,
                                    child: Stack(
                                        clipBehavior: Clip.none,
                                        fit: StackFit.expand,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Color(0x9FF5FAF9),
                                            radius: 165,
                                            backgroundImage: profissional.imgPerfil == null
                                                ? AssetImage("images/user_icon.png")
                                                : NetworkImage(profissional.imgPerfil),
                                          )])),
                                Padding(
                                    padding: EdgeInsets.only(top:18, bottom: 8, right:8, left:8),
                                    child: Text(
                                      ''+profissional.nome +' '+ ''+profissional.sobrenome+', '+ profissional.especializacao,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black, fontSize: 23,fontWeight: FontWeight.bold ,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 23),
                                    child: Text(
                                      "Registro profissional: "+ profissional.registro,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 18,
                                          fontStyle: FontStyle.italic

                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(top:8, left: 20, right: 20, bottom: 35),
                                    child: Text(
                                      ""+ profissional.descricao,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w600 ,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                      child:Text(
                                        "Ver comentários",
                                        style: TextStyle(color: Colors.blueAccent, fontSize: 20,
                                            decoration: TextDecoration.underline),
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: (){
                                        print('foi');
                                      },
                                    ) ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:10,left:50.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [
                                        RawMaterialButton(
                                          elevation: 3.0,
                                          fillColor: Color(0xFFF5F6F9),
                                          child: Icon(Icons.call, color: Colors.black,size: 40),
                                          padding: EdgeInsets.all(25.0),
                                          shape: CircleBorder(),
                                          onPressed: () {print('tel');},
                                        ),
                                        RawMaterialButton(
                                          elevation: 2.0,
                                          fillColor: Color(0xFFF5F6F9),
                                          child: Tab(icon: Image.asset('images/icon-whatsApp.png', width: 70, height: 70),),
                                          padding: EdgeInsets.all(25.0),
                                          shape: CircleBorder(),
                                          onPressed: () {print('wpp');},
                                        ),
                                        RawMaterialButton(
                                          elevation: 2.0,
                                          fillColor: Color(0xFFF5F6F9),
                                          child: Icon(CupertinoIcons.share, color: Colors.black,size: 40,),
                                          padding: EdgeInsets.all(25.0),
                                          shape: CircleBorder(),
                                          onPressed: () {print('compartilhar');},
                                        )

                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ))
                    );
                  }
                  else{
                    return Center(
                        child:CircularProgressIndicator()
                    );
                  }

                }

            )
        )
    );
  }
}

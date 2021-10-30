import 'package:Se_cuida_ai/model/cometario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class comentar extends StatefulWidget {

  String p;
  comentar(this.p);

  @override
  _comentarState createState() => _comentarState();
}

class _comentarState extends State<comentar> {

  Comentario _comentarioHelp = Comentario();
  List<Comentario> comentarios = [];
  String _idUserLogado;
  String escolha ="";

  TextEditingController comentController = TextEditingController();

  Future<List<Comentario>> _recuperar_comentarios() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;
    String id = this.widget.p;

    List c = await  _comentarioHelp.recuperar_comentario(id);


    List<Comentario> temp = [];

    for (var i in c){
      temp.add(i);
    }

    setState(() {
      comentarios = temp;
    });

    temp = null;

    return comentarios;

  }

  _exibirAddComentario(){
    showDialog(
        context: context,
        builder: (context){
          String estado = "";
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
              child: AlertDialog(
                title: Text('Escreva seu comentário'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState){
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:5.0),
                          child: Text("Sua experiencia foi: ",style: TextStyle(fontSize: 16)),
                        ),
                        Column(

                          children: [
                            RadioListTile(
                                title:Text("Boa",
                                    style: TextStyle(fontSize: 13)),
                                value: "0" ,
                                groupValue: estado ,
                                onChanged:(String user){
                                  setState(() {
                                    escolha =user;
                                    estado = user;
                                  });
                                } ),
                            RadioListTile(

                                title:Text("Ruim",
                                    style: TextStyle(fontSize: 13)),
                                value: "1" ,
                                groupValue: estado ,
                                onChanged:(String user){
                                  setState(() {
                                    escolha =user;
                                    estado = user;
                                  });
                                } ),


                          ],),
                        TextFormField(
                          controller: comentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 2,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(hintText: 'Comentário', icon: IconTheme(
                              data: IconThemeData(
                                  size: 27,
                                  color: Colors.grey[400]
                              ),
                              child: Icon(Icons.insert_comment_outlined)),
                          ),
                        )
                      ],
                    );
                  }
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Enviar'),
                  ),
                ],
          ));
        }
    );


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text("Se cuida aí"),
        ),
        body:Container(
          color: Colors.grey[100],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              _exibirAddComentario();
              print(escolha);
              },
            elevation: 4,
            icon : Icon(Icons.add, color: Colors.white,size: 30,),
            label: Text("Adicione um comentario")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}

import 'package:Se_cuida_ai/model/cometario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';

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
  String escolha;
  ScrollController controller;
  bool fabIsVisible = true;


  TextEditingController comentController = TextEditingController();

  _recuperar_comentarios() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;
    String id = this.widget.p;

    List c = await _comentarioHelp.recuperar_comentario(id);

    List<Comentario> temp = [];

    for (var i in c) {
      temp.add(i);
    }

    setState(() {
      comentarios = temp;
    });

    temp = null;

    return comentarios;
  }

  _exibirAddComentario() {
    showDialog(
        context: context,
        builder: (context) {
          String estado = "";
          return SingleChildScrollView(
              child: AlertDialog(
            title: Text('Escreva seu comentário'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text("Sua experiencia foi: ",
                        style: TextStyle(fontSize: 16)),
                  ),
                  RadioListTile(
                      title: Text("Muito boa", style: TextStyle(fontSize: 16)),
                      value: "Muito boa",
                      groupValue: estado,
                      onChanged: (String user) {
                        setState(() {
                          escolha = user;
                          estado = user;
                        });
                      }),
                  RadioListTile(
                      title: Text("Boa", style: TextStyle(fontSize: 16)),
                      value: "Boa",
                      groupValue: estado,
                      onChanged: (String user) {
                        setState(() {
                          escolha = user;
                          estado = user;
                        });
                      }),
                  RadioListTile(
                      title: Text("Ruim", style: TextStyle(fontSize: 16)),
                      value: "Ruim",
                      groupValue: estado,
                      onChanged: (String user) {
                        setState(() {
                          escolha = user;
                          estado = user;
                        });
                      }),
                  RadioListTile(
                      title: Text("Muito ruim", style: TextStyle(fontSize: 16)),
                      value: "Muito ruim",
                      groupValue: estado,
                      onChanged: (String user) {
                        setState(() {
                          escolha = user;
                          estado = user;
                        });
                      }),
                  TextFormField(
                    controller: comentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 2,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Comentário',
                      icon: IconTheme(
                          data:
                              IconThemeData(size: 27, color: Colors.grey[400]),
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
                child: Text('Cancelar', style: TextStyle(fontSize: 16)),
              ),

              TextButton(
                onPressed: () {
                  Comentario c = Comentario();
                  c.id = DateTime.now().microsecondsSinceEpoch.toString();
                  c.uidProfissional = this.widget.p;
                  c.uidDono = _idUserLogado;
                  c.comentario = comentController.text;
                  c.experiencia = estado;

                  if(estado.isNotEmpty){
                    Navigator.pop(context);
                    _comentarioHelp.criarcomentario(c);
                    comentController.clear();
                  }else{
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text("Erro", style: TextStyle(color: Colors.red),),
                          content: new Text("Escolha uma das opções!"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new TextButton(
                              child: new Text("Sair", style: TextStyle(fontSize: 16)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                  }
                },
                child: Text('Enviar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ));
        });
  }
  _exibirComentario(Comentario c) {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: AlertDialog(
                title: Text('Detalhes:', style: TextStyle(fontSize: 20)),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(c.experiencia,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text("Sobre o atendimento: " + c.comentario,
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      );

                    }
                ),
                actions: [

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Voltar', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperar_comentarios();
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        fabIsVisible =
            controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text("Se cuida aí"),
      ),
      body: FutureBuilder(
          future: _recuperar_comentarios(),
          builder: (context, snapshot) {
            if (comentarios.isNotEmpty) {
              return Container(padding: EdgeInsets.all(15), child: _viewList());
            } else {
              return Center(child: Text("Não possui comentarios"));
            }
          }),
      floatingActionButton: fabIsVisible
          ? AnimatedOpacity(
              duration: Duration(milliseconds: 10),
              opacity: fabIsVisible ? 1 : 0,
              child: FloatingActionButton.extended(
                  onPressed: () {
                    _exibirAddComentario();
                  },
                  elevation: 4,
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text("Adicione um comentario")),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _viewList() => FutureBuilder(
      future: _recuperar_comentarios(),
      builder: (context, snapshot) {
        return ListView.builder(
            controller: controller,
            itemCount: comentarios.length,
            itemBuilder: (context, index) {
              if (snapshot.hasData) {
                final item = comentarios[index];
                return _cardComentario(item, index);
              } else if (snapshot.hasError) {
                print('DEU ERRO' + snapshot.error);
              }
              return Container();
            });
      });

  Widget _cardComentario(Comentario c, int index) => GestureDetector(
        onTap: () {
          _exibirComentario(c);
        },
        child: Card(
          child: Container(
                padding: EdgeInsets.all(5),
                height: 75,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: Offset(0, 3))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8, right: 0, left: 10),
                          child: Text(
                            c.experiencia,
                            style: TextStyle(
                              color: HexColor('#4b0082'),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 23.0),
                          child: Text(
                            'clique para ver mais...',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {

                            _comentarioHelp.remove_comentario(c.id);
                            _recuperar_comentarios();
                          });
                        },
                        child: c.uidDono == _idUserLogado
                            ? IconTheme(
                                data: IconThemeData(
                                  size: 27,
                                ),
                                child: Icon(Icons.clear))
                            : null)
                  ],
                )),
        ),

      );
}

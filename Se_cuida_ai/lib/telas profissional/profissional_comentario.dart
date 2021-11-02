import 'package:Se_cuida_ai/model/cometario.dart';
import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class comentarios extends StatefulWidget {

  Profissional p;
  comentarios(this.p);

  @override
  _comentariosState createState() => _comentariosState();
}

class _comentariosState extends State<comentarios> {

  Comentario _comentarioHelp = Comentario();
  List<Comentario> comentarios = [];
  String escolha;

  TextEditingController comentController = TextEditingController();

  _recuperar_comentarios() async {
    String id = this.widget.p.uid;

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

  Widget _viewList() => FutureBuilder(
      future: _recuperar_comentarios(),
      builder: (context, snapshot) {
        return ListView.builder(
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
            ],
          )),
    ),

  );


  @override
  void initState() {
    super.initState();
    _recuperar_comentarios();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _recuperar_comentarios(),
          builder: (context, snapshot) {
            if (comentarios.isNotEmpty) {
              return Container(padding: EdgeInsets.all(15), child: _viewList());
            } else {
              return Center(child: Text("Você não possui comentarios"));
            }
          }),
    );
  }


}



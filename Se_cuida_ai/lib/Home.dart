import 'package:Se_cuida_ai/atualizarPerfilProfissional.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'login.dart';

class telaInicial extends StatefulWidget {

  @override
  _telaInicialState createState() => _telaInicialState();
}

class _telaInicialState extends State<telaInicial> {

  List profissoes = ['Todos','Fisioterapia','Nutricionista', 'Enfermagem','Esteticista', 'Médico', 'Dentista', 'Massagista', 'Técnico de enfermagem'];
  List cores = ['#845EC2','#D6967B', '#8F6F91', '#FF1D59', '#D65DB1', '#FF6F91', '#FF9671', '#FFC75F', 'F9F871'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _viewList()
    );
  }
  Widget _viewList() => GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1),
      itemCount: profissoes.length,
      itemBuilder: (context, index){
        final item = profissoes[index];
        return _cardprofissao(item, index);
      });

  Widget _cardprofissao(String prof,int index) => GestureDetector(
    onTap: (){
      print(profissoes[index].toString());
      String es = profissoes[index].toString();
      /*Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => perfilUser()));*/
    },
    child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: HexColor(cores[index]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 5,
                offset: Offset(
                    0,3
                )
            )
          ]

      ),
      padding: EdgeInsets.all(16),

      child: GridTile(
        child: Center(
          child: Text(
            prof,
            style: TextStyle(fontWeight:  FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}



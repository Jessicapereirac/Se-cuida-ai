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

  List profissoes = ['Todos','Fisioterapeuta','Nutricionista', 'Enfermeira/o','Esteticista', 'Médica/o', 'Dentista', 'Massagista', 'Técnica/o de enfermagem'];
  List cores = ['#FFFFFF','#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', 'FFFFFF'];
  List<Icon> icon = [Icon(Icons.apps_outlined), Icon(Icons.zoom_out_map_sharp), Icon(Icons.search), Icon(Icons.search), Icon(Icons.search), Icon(Icons.search), Icon(Icons.search), Icon(Icons.search), Icon(Icons.search)];
  
  bool profSelecionada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: _viewList()
    );
  }
  Widget _viewList() => GridView.builder(
      padding: EdgeInsets.all(26),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
      mainAxisSpacing: 25,

      crossAxisSpacing: 25,
      childAspectRatio: 1),
      itemCount: profissoes.length,
      itemBuilder: (context, index){
        final item = profissoes[index];
        return _cardprofissao(item, index);
      });

  Widget _cardprofissao(String prof,int index) => GestureDetector(

    onTap: (){
      setState(() {
        cores = ['#FFFFFF','#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', 'FFFFFF'];
        cores[index] = '#FFBF00';
        profSelecionada = true;
      });
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
        image:DecorationImage(
          image: AssetImage("images/user_icon.png"),
          fit: BoxFit.cover
        ),
          color: HexColor(cores[index]),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(
                    0,3
                )
            )
          ]

      ),
      padding: EdgeInsets.all(16),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridTile(
            child: Center(
              child: Text(
                prof,
                style: TextStyle( fontSize: 21,fontWeight: FontWeight.bold ,
                    shadows: [Shadow(
                        blurRadius: 9,
                        color: Colors.grey[800],
                        offset: Offset(
                            0,3
                        )
                    )]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:15),
            child:IconTheme(
                data: IconThemeData(
                    size: 47,
                    color: Colors.black
                ),
                child: icon[index])
          ),
        ],
      )
    ),
  );
}



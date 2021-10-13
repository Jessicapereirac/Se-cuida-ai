import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class telaInicial extends StatefulWidget {

  @override
  _telaInicialState createState() => _telaInicialState();
}

class _telaInicialState extends State<telaInicial> {

  List profissoes = ['','Fisioterapeuta','Nutricionista', 'Enfermeira/o','Psicólogo','Esteticista', 'Médica/o', 'Dentista', 'Massagista', 'Técnica/o de enfermagem'];
  List imagens = ['apps.png','fisio.jpg','nutricao.jpg', 'enfermeiro.jpg','psicologia.jpg', 'estetica.jpg', 'medico.jpg', 'dentista.jpg', 'massagista.jpg', 'tec_enfermagem.jpg'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _viewList()
    );
  }
  Widget _viewList() => GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
      mainAxisSpacing: 30,

      crossAxisSpacing: 20,
      childAspectRatio: 0.8),
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
          image:DecorationImage(
              image:  AssetImage('images/'+imagens[index]),
              fit: BoxFit.fitWidth
        ),
          color: HexColor('#FFFFFF'),
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
      padding: EdgeInsets.only(top: 8),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              prof,
              style: TextStyle(color: HexColor('#4b0082'), fontSize: 20,fontWeight: FontWeight.bold ,
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
        ],
      )
    ),
  );
}



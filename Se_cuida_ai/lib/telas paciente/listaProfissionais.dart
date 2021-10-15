import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class listaProfissional extends StatefulWidget {

  String especializacao;
  listaProfissional(this.especializacao);

  @override
  _listaProfissionalState createState() => _listaProfissionalState();
}

class _listaProfissionalState extends State<listaProfissional>  {

  Profissional _profissionalHelp = Profissional();
  List<Profissional> profissionais = [];

  _recuperar_profissionais() async {
    List p = await  _profissionalHelp.recuperar_profissionais();
    List<Profissional> temp = [];

    for (var i in p){
      temp.add(i);
    }

    setState(() {
      profissionais = temp;
    });

    temp = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperar_profissionais();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text("Se cuida aí"),
        ),
        backgroundColor: Colors.grey[100],
        body: _viewList()
    );
  }
  Widget _viewList() => GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,

          crossAxisSpacing: 15,
          childAspectRatio: 2.4),
      itemCount: profissionais.length,
      itemBuilder: (context, index){
        final item = profissionais[index];
        return _cardprofissao(item.nome, index);
      });

  Widget _cardprofissao(String prof,int index) => GestureDetector(

    onTap: (){
      print("foi");
      /*print(profissoes[index].toString());
      String es = profissoes[index].toString();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => perfilprofissional(prof)));
              */
    },
    child: Container(

        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            /*image:DecorationImage(
                image:  AssetImage(prof.imgPerfil),
                fit: BoxFit.fitWidth
            ),*/
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

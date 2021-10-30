import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:Se_cuida_ai/telas%20paciente/paciente_perfildoFuncionario.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<String> favoritos = [];
  String _idUserLogado;

  Future<List<Profissional>> _recuperar_profissionais() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;

    List p = await  _profissionalHelp.recuperar_profissionais(widget.especializacao);
    List fav = await  _profissionalHelp.recuperar_favoritos(_idUserLogado);

    List<Profissional> temp = [];
    List<String> temp2 = [];

    for (var i in p){
      temp.add(i);
    }
    for (var j in fav){
      temp2.add(j);
    }

    setState(() {
      profissionais = temp;
      favoritos =  temp2;
    });

    temp2 = temp = null;

    return profissionais;

  }

  void _favorito(String uid_profissional) {

    if(favoritos.contains(uid_profissional)){
      favoritos.remove(uid_profissional);
    }else{
      favoritos.add(uid_profissional);
    }
    _profissionalHelp.atualizar_favoritos(favoritos, _idUserLogado);
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
        body: FutureBuilder(
            future:_recuperar_profissionais(),
            builder: (context, snapshot){
              if(profissionais.isNotEmpty){
                return _viewList();
              }
              else{
                if(_idUserLogado != null){
                  return Center(child: Text("Ainda não temos profissionais "));
                }else{return Center(child: CircularProgressIndicator());}

              }
            }

        )
    );
  }
  Widget _viewList() => GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
          childAspectRatio: 2.5),
      itemCount: profissionais.length,
      itemBuilder: (context, index){
        final item = profissionais[index];
        return _cardprofissional(item, index);
      });

  Widget _cardprofissional(Profissional p,int index) => GestureDetector(

    onTap: (){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => perfilProfissional(p)));

    },
    child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
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
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: p.imgPerfil == null
                  ? AssetImage("images/user_icon.png")
                  : NetworkImage(p.imgPerfil),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:8, right:8, left:8),
                    child: Text(
                      p.nome,
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
                  Expanded(
                      child: Padding(
                      padding: EdgeInsets.only(top:8, bottom: 1, right:2, left:2),
                      child: Text(
                        p.especializacao,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: HexColor('#4b0082'), fontSize: 16,fontWeight: FontWeight.bold ,
                        ),
                        textAlign: TextAlign.center,
                      )))
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  _favorito(p.uid);
                });},
                child: favoritos.contains(p.uid)
                    ? IconTheme( data: IconThemeData(size: 27), child:  Icon(Icons.favorite))
                    : IconTheme(data: IconThemeData(size: 27), child:  Icon(Icons.favorite_border)))

          ],
        )
    ),
  );
}


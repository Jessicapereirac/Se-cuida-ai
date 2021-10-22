import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class pesquisar extends StatefulWidget {

  @override
  _pesquisarState createState() => _pesquisarState();
}

class _pesquisarState extends State<pesquisar> {

  Profissional _profissionalHelp = Profissional();
  List<Profissional> profissionais = [];
  List<String> favoritos = [];
  String _idUserLogado;

  TextEditingController _pesquisaController = TextEditingController();

  _recuperar_profissionais() async {

    List p = await  _profissionalHelp.recuperar_profissionais('');
    List fav = await  _profissionalHelp.recuperar_favoritos();

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

  }

  void _favorito(String uid_profissional) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;

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
        backgroundColor: Colors.grey[100],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(12),
              child: TextField(
                style: TextStyle(
                  fontSize:20,
                  height: 2
                ),
                autofocus: true,
                controller: _pesquisaController,
                decoration: InputDecoration(
                    labelText: "Procurar profissionais",
                    hintText: "Informe o nome do profissional",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    )
                ),
                onChanged: (text){
                  print(text);
                },
              ),),
            Expanded(
                child: Container(
                  child: _viewList(),
            ))
          ],
        ),
    );
  }

  Widget _viewList() => GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
          childAspectRatio: 4),
      itemCount: profissionais.length,
      itemBuilder: (context, index){
        final item = profissionais[index];
        return _cardprofissional(item, index);
      });

  Widget _cardprofissional(Profissional p,int index) => GestureDetector(

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
              radius: 28,
              backgroundColor: Colors.transparent,
              backgroundImage: p.imgPerfil == null
                  ? AssetImage("images/user_icon.png")
                  : NetworkImage(p.imgPerfil),

            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:8, bottom: 8, right:8, left:8),
                    child: Text(
                      p.nome +' '+ p.sobrenome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: HexColor('#4b0082'), fontSize: 20,fontWeight: FontWeight.bold ,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  )
                ],

              ),
            ),
            GestureDetector(
                onTap: (){
                  setState(() {
                    _favorito(p.uid);
                  });
                },
                child: favoritos.contains(p.uid)
                    ? IconTheme(
                    data: IconThemeData(
                      size: 27,
                    ),
                    child:  Icon(Icons.favorite))
                    : IconTheme(
                    data: IconThemeData(
                      size: 27,
                    ),
                    child:  Icon(Icons.favorite_border)))

          ],
        )
    ),
  );
}

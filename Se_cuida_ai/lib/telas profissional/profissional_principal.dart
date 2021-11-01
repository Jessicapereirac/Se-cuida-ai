import 'package:Se_cuida_ai/telas%20profissional/profissional_comentario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../geral_login.dart';
import 'profissional_navegacao.dart';
import 'profissional_atualizarPerfil.dart';


class homeProfissional extends StatefulWidget {

  @override
  _homeProfissionalState createState() => _homeProfissionalState();
}

class _homeProfissionalState extends State<homeProfissional> {

  int itemselect;
  String _idUserLogado;
  Color backgoundColor = Colors.white;

  List<String> escolhas = ["Sair"];
  List<NavigationItem> itens = [
    NavigationItem(Icon(Icons.comment), Text("Comentarios"), HexColor('#dcbea7')),
    NavigationItem(Icon(Icons.home_filled), Text("      Perfil"),  HexColor('#6d6875')),
    NavigationItem(Icon(Icons.account_circle), Text("   Atualizar"), HexColor('#e5989b')),
  ];

  PageController _pageController = PageController(
      initialPage: 0,
      keepPage: false
  );

  void mudaPagina(int index){
    setState(() {
      itemselect = index;
    });
  }

  Future<String> _recupera_profissional() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;

    return userLogado.uid;

  }

  Widget buildPageView(){
    return PageView(
      controller: _pageController,
      onPageChanged: (index){
        mudaPagina(index);
        mudarbotao(index);
      },
      children: [
        comentarios(_idUserLogado),
        pagProfissional(_idUserLogado),
        atualizarPerfil()
      ],
    );
  }

  void mudarbotao(int index){
    setState(() {
      itemselect = index;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 270), curve: Curves.ease);
    });
  }

  void _escolhaUsuario(String item){

    switch(item){
      case("Sair"):
        _deslogar();
        break;
    }
  }

  void _deslogar() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => login()));
  }

  Widget _criandoItem(NavigationItem item, bool selecionado){
    return AnimatedContainer(
      duration: Duration(milliseconds: 270),
      padding: selecionado ? EdgeInsets.only(left: 13, right: 20):null,
      height: 53,
      width: selecionado ? 190 : 50,
      decoration: selecionado ? BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.all(Radius.circular(50))
      ): null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconTheme(
                  data: IconThemeData(
                      size: 27,
                      color: selecionado ? backgoundColor : Colors.black
                  ),
                  child:  item.icon),
              Padding(padding: EdgeInsets.only(left: 10),
                child: selecionado ? DefaultTextStyle.merge(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: backgoundColor,
                        fontSize: 17
                    ),
                    child: item.title) : Container(),)
            ],
          ),
        ],
      ),
    );
  }

  Widget _criandoNavBar() {
    return Container(
      padding: EdgeInsets.only(left: 15,top: 4, bottom: 4,right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          color: backgoundColor,
          boxShadow:[ BoxShadow(
              color: Colors.black12,
              blurRadius: 4
          )]
      ),
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: itens.map((item){
          var select = itens.indexOf(item);
          return GestureDetector(
            child: _criandoItem(item, select == itemselect),
            onTap: (){
              setState(() {
                itemselect = select;
                mudarbotao(itemselect);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _recupera_profissional();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text("Se cuida aí"),
        actions:[
          PopupMenuButton<String>(
              onSelected: _escolhaUsuario,
              itemBuilder: (context){
                return escolhas.map((String item){
                  return PopupMenuItem<String>(
                      value: item,
                      child: Text(item) );
                }).toList();
              })
        ],
      ),
      body:Container(
        child: buildPageView()
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[100],
        child:_criandoNavBar(),
      ),

    );
  }
}

class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;

  NavigationItem(this.icon, this.title, this.color);
}

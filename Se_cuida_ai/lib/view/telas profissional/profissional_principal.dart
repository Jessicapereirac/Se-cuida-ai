import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../controller.dart';
import 'profissional_navegacao.dart';
import 'profissional_atualizarPerfil.dart';


class homeProfissional extends StatefulWidget {

  @override
  _homeProfissionalState createState() => _homeProfissionalState();
}

class _homeProfissionalState extends State<homeProfissional> {

  int itemselect = 0;
  String _idUserLogado;
  Color backgoundColor = Colors.white;
  Controller controller = Controller();
  Controller controllerP = Controller();

  List<String> escolhas = ["Apagar conta","Sair"];
  List<NavigationItem> itens = [
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
    return _idUserLogado = controllerP.recuperar_id_prof();
  }

  Widget buildPageView(){
    return PageView(
      controller: _pageController,
      onPageChanged: (index){
        mudaPagina(index);
      },
      children: [
        pagProfissional(_idUserLogado),
        atualizarPerfil()
      ],
    );
  }

  void mudarbotao(int index){
    setState(() {
      _pageController.animateToPage(index, duration: Duration(milliseconds: 270), curve: Curves.ease);
    });
  }

  void _escolhaUsuario(String item){

    switch(item){
      case("Sair"):
        _deslogar();
        break;
      case("Apagar conta"):
        _apagar();
        break;
    }
  }

  void _deslogar() async {controller.deslogar_profissional(context);}

  _apagar(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Apagar conta"),
          content: new Text("Tem certeza que desejar apagar sua conta?"),
          actions: <Widget>[
            // define os bot??es na base do dialogo
            TextButton(
              child: new Text("Confirmar"),
              onPressed: () {
                controller.apagar_profissional(context);
              },
            ),
            TextButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        title: Text("Se cuida a??"),
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
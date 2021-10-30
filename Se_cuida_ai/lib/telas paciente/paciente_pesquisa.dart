import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:Se_cuida_ai/telas%20paciente/paciente_perfildoFuncionario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class paciente_pesquisar extends StatefulWidget {

  @override
  _paciente_pesquisarState createState() => _paciente_pesquisarState();
}

class _paciente_pesquisarState extends State<paciente_pesquisar> {

  Profissional _profissionalHelp = Profissional();
  List<Profissional> profissionais = [];
  List<String> favoritos = [];
  String _idUserLogado;

  TextEditingController _pesquisaController = TextEditingController();

  Future<List<Profissional>> _recuperar_profissionais() async {
    List p = await _profissionalHelp.recuperar_profissionais('');
    List<Profissional> temp = [];

    for (var j in p) {
      temp.add(j);
    }

    setState(() {
      profissionais = temp;
    });

    temp = null;

    return temp;
  }

  Future<List> _recuperar_profissionais_filtrado(String busca) async {
    profissionais = [];
    List p = await _profissionalHelp.filtrar_profissionais(busca);


    List<Profissional> temp3 = [];

    for (var i in p) {
      temp3.add(i);
    }

    setState(() {
      profissionais = temp3;
    });

    temp3 = null;

    if (busca.isEmpty) {
      setState(() {
        _recuperar_profissionais();
      });
    }

  }

  void _recuperar_favoritos() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogado = await auth.currentUser;
    _idUserLogado = userLogado.uid;

    List fav = await _profissionalHelp.recuperar_favoritos(_idUserLogado);
    List<String> temp = [];

    for (var i in fav) {
      temp.add(i);
    }

    setState(() {
      favoritos = temp;
    });

    temp = null;
  }

  void _favorito(String uid_profissional) async {

    if (favoritos.contains(uid_profissional)) {
      favoritos.remove(uid_profissional);
    } else {
      favoritos.add(uid_profissional);
    }
    _profissionalHelp.atualizar_favoritos(favoritos, _idUserLogado);
  }


  @override
  void initState() {
    super.initState();
    _recuperar_profissionais();
    _recuperar_favoritos();
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
                  fontSize: 20,
                  height: 2
              ),
              controller: _pesquisaController,
              decoration: InputDecoration(
                  labelText: "Procurar profissionais",
                  hintText: "Informe o nome do profissional",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  )
              ),
              onChanged: (text) async {
                _recuperar_profissionais_filtrado(text);
              },
            ),),
          Expanded(
              child: Container(
                  child:  _viewList()


              ))
        ],
      ),
    );
  }

  Widget _viewList() =>
    GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 15,
            childAspectRatio: 4),
        itemCount: profissionais.length,
        itemBuilder: (context, index) {
          final item = profissionais[index];
          return _cardprofissional(item, index);
        });

  Widget _cardprofissional(Profissional p, int index)=>
    GestureDetector(
      onTap: () {
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
                        0, 3))
              ]
          ),
          padding: EdgeInsets.all(18),
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, right: 0, left: 0),
                        child: Text(
                          p.nome + ' ' + p.sobrenome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: HexColor('#4b0082'),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _favorito(p.uid);
                    });
                  },
                  child: favoritos.contains(p.uid)
                      ? IconTheme(
                      data: IconThemeData(
                        size: 27,
                      ),
                      child: Icon(Icons.favorite))
                      : IconTheme(
                      data: IconThemeData(
                        size: 27,
                      ),
                      child: Icon(Icons.favorite_border)))

            ],
          )
      ),
    );
}
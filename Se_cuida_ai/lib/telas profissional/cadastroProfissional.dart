import 'package:Se_cuida_ai/model/paciente.dart';
import 'package:Se_cuida_ai/model/profissional.dart';
import 'package:Se_cuida_ai/telas%20profissional/principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cadastroProfissional extends StatefulWidget {

  Paciente p;
  cadastroProfissional(this.p);

  @override
  _cadastroProfissionalState createState() => _cadastroProfissionalState();
}

class _cadastroProfissionalState extends State<cadastroProfissional> {

  String profissao = 'Selecione uma opção:';
  String msgErropf = "";
  String msgErroreg = "";
  String msgErroApp = "";

  TextEditingController _controllerRegistro = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();


  void _validarDados() {
    String registro = _controllerRegistro.text;
    String desc = _controllerDescricao.text;

    if(profissao != 'Selecione uma opção:'){
      msgErropf = "";
      if(registro.isNotEmpty && registro.length > 4 ){
        //TODO: REGISTRO VALIDO VIA API
        setState(() {
          msgErroreg = msgErropf = "";
        });

        Profissional profissional = Profissional();
        profissional.nome = widget.p.nome;
        profissional.sobrenome = widget.p.sobrenome;
        profissional.email = widget.p.email;
        profissional.senha = widget.p.senha;
        profissional.dt_nascimento = widget.p.dt_nascimento;
        profissional.tipo = widget.p.tipo;
        profissional.genero = widget.p.genero;
        profissional.numero_cel = widget.p.numero_cel;
        profissional.registro = registro;
        profissional.especializacao = profissao;
        profissional.descricao = desc;
        profissional.imgPerfil = null;

        _cadastrarUsuario(profissional);
        print(msgErroApp);
        if(msgErroApp == 'ok'){
          print("home profissional");
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => homeProfissional()));
        }

      } else{
        setState(() {
          msgErroreg = "Insira um registro valido";
        });
      }}
    else{
      setState(() {
        msgErropf = "Indique sua especialização";
      });
    }
  }

  void _cadastrarUsuario(Profissional p){

    if(msgErroreg.isEmpty && msgErropf.isEmpty && p.tipo == '1'){

      String result = p.cadastrarUsuario(p, context);
      setState(() {
        print(result);
        msgErroApp = result;
      });
    }
    else{
      print("erro");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text("Se cuida aí"),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white60
        ),
        padding: EdgeInsets.fromLTRB(25,12,25,10),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 1),
                  child: DropdownButton<String>(
                    value: profissao,

                    //alignment: AlignmentDirectional.center,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black54),
                    underline: Container(
                      height: 2,
                      color: Colors.black54,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        profissao = newValue;
                      });
                    },
                    items: <String>['Selecione uma opção:','Fisioterapeura', 'Enfermeiro', 'Médico', 'Dentista', 'Massagista', 'Técnico de enfermagem']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 18),),
                      );
                    }).toList(),
                  )
              ),
              Center(
                child: Text(msgErropf,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: TextField(
                    controller: _controllerRegistro,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Registro (CRM, CRO, CRE ...)",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Center(
                child: Text(msgErroreg,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 1, bottom: 10),
                  child: TextField(
                    controller: _controllerDescricao,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 2,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 20),
                        hintMaxLines: 3,
                        hintText: "Descrição: Diga algo que você quer que seus pacientes vejam",
                        hintStyle: TextStyle(fontSize: 18),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),

              Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32
                                  ))),

                        ),
                        child: Text(
                            "Cadastrar",
                            style: TextStyle(color: Colors.white, fontSize: 22)),
                        onPressed: () {
                          _validarDados();

                        },

                      )
                    ],
                  )
              ),
              Center(
                child: Text(msgErropf,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),

            ],
          ),

        ),

      ),

    );
  }
}

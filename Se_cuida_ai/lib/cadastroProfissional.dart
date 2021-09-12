import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class cadastroProfissional extends StatefulWidget {
  @override
  _cadastroProfissionalState createState() => _cadastroProfissionalState();
}

class _cadastroProfissionalState extends State<cadastroProfissional> {

  String dropdownValue = 'Selecione uma opção:';

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
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 16),
                  child: DropdownButton<String>(
                    value: dropdownValue,

                    alignment: AlignmentDirectional.center,
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
                        dropdownValue = newValue;
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
              Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
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
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
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
                          print("tela inicial");
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => telaInicial()));

                        },

                      )
                    ],
                  )
              ),

            ],
          ),

        ),

      ),

    );
  }
}

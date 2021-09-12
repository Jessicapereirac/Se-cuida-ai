import 'package:Se_cuida_ai/cadastroProfissional.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Home.dart';

class cadastroGeral extends StatefulWidget {

  @override
  _cadastroGeralState createState() => _cadastroGeralState();
}

class _cadastroGeralState extends State<cadastroGeral> {
  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field
  List<Gender> genders = new List<Gender>();
  String _tipoUser;

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    genders.add(new Gender("Masculino", MdiIcons.genderMale, false));
    genders.add(new Gender("Feminino", MdiIcons.genderFemale, false));
    genders.add(new Gender("Outros", MdiIcons.genderTransgender, false));
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
        padding: EdgeInsets.fromLTRB(20,35,20,10),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome completo",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
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
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Center(
                      child:TextField(
                        controller: dateinput, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today), //icon of text field
                            labelText: "Data de Nascimento" //label text of field
                        ),
                        readOnly: true,  //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime pickedDate = await showDatePicker(
                              context: context, initialDate: DateTime.now(),
                              firstDate: DateTime(1910), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.now()
                          );

                          if(pickedDate != null ){
                            print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                            print(formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dateinput.text = formattedDate; //set output date to TextField value.
                            });
                          }else{
                            print("Data invalida");
                          }
                        },
                      )
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Número de Telefone',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'BR',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                  )
              ),

              Padding(padding: EdgeInsets.only(right: 0, bottom: 10),
                child: Text("Gênero", style: TextStyle(fontSize: 17, color: Colors.black54),)
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20,0,0,5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(

                          height: 90,
                          width: 50,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: genders.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {
                                    setState(() {
                                      genders.forEach((gender) => gender.isSelected = false);
                                      genders[index].isSelected = true;
                                    });
                                  },
                                  child: CustomRadio(genders[index]),
                                );
                              }),
                        ),
                      )
                    ],
                  )
              ),

              Padding(padding: EdgeInsets.only(right: 0, top:15),
                  child: Text("Você é um:", style: TextStyle(fontSize: 17, color: Colors.black54),)
              ),
              Column(
                children: [
                  RadioListTile(
                      title:Text("Paciente/Cuidador",
                          style: TextStyle(fontSize: 16)),
                      value: "paciente" ,
                      groupValue: _tipoUser ,
                      onChanged:(String user){
                        setState(() {
                          _tipoUser = user;
                        });
                      } ),
                  RadioListTile(
                      title:Text("Profissional",
                          style: TextStyle(fontSize: 16)),
                      value: "profissional" ,
                      groupValue: _tipoUser ,
                      onChanged:(String user){
                        setState(() {
                          _tipoUser = user;
                        });
                      } )
                ],
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
                            "Avançar",
                            style: TextStyle(color: Colors.white, fontSize: 22)),
                        onPressed: () {
                          if(_tipoUser == 'profissional'){
                            print("tela profissional-cadastro");
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => cadastroProfissional()));
                          }
                          else{
                            print("tela inicial");
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => telaInicial()));
                          }
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
class CustomRadio extends StatelessWidget {
  Gender _gender;

  CustomRadio(this._gender);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: _gender.isSelected ? Colors.black : Colors.white,
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          margin: new EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                _gender.icon,
                color: _gender.isSelected ? Colors.white : Colors.black,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                _gender.name,
                style: TextStyle(
                    color: _gender.isSelected ? Colors.white : Colors.black),
              )
            ],
          ),
        ));
  }
}

class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}

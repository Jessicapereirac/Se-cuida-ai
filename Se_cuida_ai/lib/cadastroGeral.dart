import 'package:Se_cuida_ai/model/paciente.dart';
import 'package:Se_cuida_ai/telas%20paciente/principal.dart';
import 'package:Se_cuida_ai/telas%20profissional/cadastroProfissional.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class cadastroGeral extends StatefulWidget {

  @override
  _cadastroGeralState createState() => _cadastroGeralState();
}

class _cadastroGeralState extends State<cadastroGeral> {

  List<Gender> genders = new List<Gender>();
  String _tipoUser = "";
  String _userGender = "";

  String msgErro = "";
  String msgErroApp = "";
  String msgErroNome = "";
  String msgErroSn = "";
  String msgErroEmail = "";
  String msgErroSenha = "";
  String msgErroDt = "";
  String msgErroCel = "";
  String msgErroGen = "";
  String msgErroTp = "";

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerSobrenome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerDtnascimento = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();

  void _validarDados(){
    String nome = _controllerNome.text;
    String sobrenome = _controllerSobrenome.text;
    String senha = _controllerSenha.text;
    String email = _controllerEmail.text;
    String dtnasc = _controllerDtnascimento.text;
    String cel = _controllerCelular.text;

    if(nome.length > 2){
      msgErroNome = "";
      if(sobrenome.length > 2){
        msgErroSn = "";
        if(email.isNotEmpty && email.contains("@")){
          msgErroEmail = "";
          if(senha.isNotEmpty && senha.length >= 6){
            msgErroSenha = "";
            if(dtnasc.isNotEmpty ){
              msgErroDt = "";
              //TODO: MAIORES DE 18
              if(cel.isNotEmpty && cel.length == 11){
                msgErroCel = "";
                if(_tipoUser.isNotEmpty ){
                  msgErroTp = "";
                  if(_userGender.isNotEmpty ){
                    setState(() {
                      msgErro = msgErroNome = msgErroSn = msgErroEmail
                      = msgErroSenha = msgErroDt = msgErroCel = msgErroGen = msgErroTp = "";
                    });

                    Paciente paciente = Paciente();

                    paciente.nome = nome;
                    paciente.sobrenome = sobrenome;
                    paciente.email = email;
                    paciente.senha = senha;
                    paciente.dt_nascimento = dtnasc;
                    paciente.numero_cel = cel;
                    paciente.genero = _userGender;
                    paciente.tipo = _tipoUser;

                    if(_tipoUser == "0"){
                      _cadastrarUsuario(paciente);
                      if(msgErroApp == 'ok'){
                        print("home paciente");
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(
                                builder: (context) => homePaciente()));
                      }

                    }

                    else if(_tipoUser == "1" ){
                      print("tela profissional-cadastro");
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => cadastroProfissional(paciente)));

                    }

                  } else{
                    setState(() {
                      msgErro = msgErroGen = "Indique um gênero";
                    });
                  }} else{
                  setState(() {
                    msgErro = msgErroTp = "Indique que tipo de usuario você é";
                  });
                }} else{
                setState(() {
                  msgErro = msgErroCel = "Insira um número de celular  valido";
                });
              }} else{
              setState(() {
                msgErro = msgErroDt = "Insira uma data de nascimento valida";
              });
            }} else{
            setState(() {
              msgErro = msgErroSenha = "Insira uma senha valida";
            });
          }} else{
          setState(() {
            msgErro = msgErroEmail = "Insira um email valido";
          });
        }} else{
        setState(() {
          msgErro = msgErroSn = "Insira um sobrenome valido";
        });
      }} else{
      setState(() {
        msgErro = msgErroNome = "Insira um nome valido";
      });
    }
  }

  void _cadastrarUsuario(Paciente p){

    if(msgErro.isEmpty && p.tipo == '0'){

      String result = p.cadastrarUsuario(p, context);
      setState(() {
        msgErroApp = result;
        print(result);
      });
    } else{
      print("erro");
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerDtnascimento.text = "";
    genders.add(new Gender("Masculino", MdiIcons.genderMale, false));
    genders.add(new Gender("Feminino", MdiIcons.genderFemale, false));
    genders.add(new Gender("Não-binário", MdiIcons.genderTransgender, false));
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
        padding: EdgeInsets.fromLTRB(20,15,20,10),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 1, bottom: 1),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Center(
                child: Text(msgErroNome,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 1, bottom: 1),
                  child: TextField(
                    controller: _controllerSobrenome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Sobrenome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  )
              ),
              Center(
                child: Text(msgErroSn,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 1, bottom: 1),
                  child: TextField(
                    controller: _controllerEmail,
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
              Center(
                child: Text(msgErroEmail,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 1, bottom: 10),
                  child: TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
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
              Center(
                child: Text(msgErroSenha,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Center(
                      child:TextField(
                        controller: _controllerDtnascimento, //editing controller of this TextField
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
                              _controllerDtnascimento.text = formattedDate;
                              //set output date to TextField value.
                            });
                          }else{
                            print("Data invalida");
                          }
                        },
                      )
                  )
              ),
              Center(
                child: Text(msgErroDt,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: IntlPhoneField(
                    controller: _controllerCelular,
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
              Center(
                child: Text(msgErroCel,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),

              Padding(padding: EdgeInsets.only(right: 0, bottom: 0),
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
                                      print(genders[index].name);
                                      _userGender = genders[index].name;
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
              Center(
                child: Text(msgErroGen,style: TextStyle(color: Colors.red, fontSize: 12)),
              ),

              Padding(padding: EdgeInsets.only(right: 0, top:0),
                  child: Text("Você é um:", style: TextStyle(fontSize: 17, color: Colors.black54),)
              ),
              Column(
                children: [
                  RadioListTile(
                      title:Text("Paciente/Cuidador",
                          style: TextStyle(fontSize: 16)),
                      value: "0" ,
                      groupValue: _tipoUser ,
                      onChanged:(String user){
                        setState(() {
                          _tipoUser = user;
                        });
                      } ),
                  RadioListTile(
                      title:Text("Profissional",
                          style: TextStyle(fontSize: 16)),
                      value: "1" ,
                      groupValue: _tipoUser ,
                      onChanged:(String user){
                        setState(() {
                          _tipoUser = user;
                        });
                      } )
                ],
              ),
              Center(
                child: Text(msgErroTp,style: TextStyle(color: Colors.red, fontSize: 12)),
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
                          _validarDados();

                        },

                      )
                    ],
                  )
              ),
              Center(
                child: Text(msgErroApp,style: TextStyle(color: Colors.red, fontSize: 12)),
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

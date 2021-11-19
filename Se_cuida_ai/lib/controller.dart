import 'package:Se_cuida_ai/view/geral_login.dart';
import 'package:Se_cuida_ai/view/telas%20profissional/profissional_cadastro.dart';
import 'package:flutter/material.dart';

import 'model/paciente.dart';
import 'model/profissional.dart';


class Controller {

  Profissional helpProfissional = Profissional();
  Paciente helpPaciente = Paciente();

  recuperar_id_prof() async {
    //print(helpProfissional.recuperar_uid().toString());
    return await helpProfissional.recuperar_uid();
  }

  recuperar_id_pac() async {

    //print(helpPaciente.recuperar_uid());
    return await helpPaciente.recuperar_uid();
  }

  realizar_login(context, String tipoUser){

    if(tipoUser == "0"){
      print("home paciente");
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => login()));
    }
    else if(tipoUser == "1"){
      print("home profissional");
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => login()));
    }
  }

  continuar_cadastro(context, Paciente paciente){
    print("tela profissional-cadastro");
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => cadastroProfissional(paciente)));
  }

  Future<Profissional> recuperarDados() async {

    Profissional p= Profissional();

    var dados = await helpProfissional.recuperar_unico_profissional();

    p.email = dados["email"];
    p.dt_nascimento = dados["dt_nascimento"];
    p.nome = dados["nome"];
    p.imgPerfil = dados["imgPerfil"];
    p.sobrenome = dados["sobrenome"];
    p.especializacao = dados["especializacao"];
    p.numero_cel = dados["numero_cel"];
    p.genero = dados["genero"];
    p.descricao = dados["descricao"];
    p.registro = dados["registro"];
    p.tipo = dados["tipo"];
    p.senha = dados["senha"];
    p.uid = dados["uid"];
    p.endereco = dados["endereco"];
    p.numComente = dados["numComente"];

    return p;

  }

  apagar_profissional(context){

    helpProfissional.deletar_profissional(context);
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => login()));
  }

  deslogar_profissional(context){

    helpProfissional.sair_profissional();
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => login()));
  }

  apagar_paciente(context){

    helpPaciente.deletar_paciente(context);
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => login()));
  }

  deslogar_paciente(context){

    helpPaciente.sair_paciente();
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => login()));
  }


}


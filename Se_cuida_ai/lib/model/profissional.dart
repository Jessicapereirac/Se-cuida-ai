class Profissional
{
  String _nome;
  String _sobrenome;
  String _email;
  String _senha;
  String _dt_nascimento;
  String _numero_cel;
  String _genero;
  String _tipo;
  String _especializacao;
  String _registro;
  String _descricao;
  String imgPerfil;


  Profissional();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map ={

      "nome" : this.nome,
      "sobrenome" : this.sobrenome,
      "email" : this.email,
      "dt_nascimento" : this.dt_nascimento,
      "numero_cel" : this.numero_cel,
      "genero" : this.genero,
      "tipo" : this.tipo,
      "especializacao" : this.especializacao,
      "registro" : this.registro,
      "descricao" : this.descricao,
      "imgPerfil" : this.imgPerfil

    };
    return map;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get registro => _registro;

  set registro(String value) {
    _registro = value;
  }

  String get especializacao => _especializacao;

  set especializacao(String value) {
    _especializacao = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get genero => _genero;

  set genero(String value) {
    _genero = value;
  }

  String get numero_cel => _numero_cel;

  set numero_cel(String value) {
    _numero_cel = value;
  }

  String get dt_nascimento => _dt_nascimento;

  set dt_nascimento(String value) {
    _dt_nascimento = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get sobrenome => _sobrenome;

  set sobrenome(String value) {
    _sobrenome = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
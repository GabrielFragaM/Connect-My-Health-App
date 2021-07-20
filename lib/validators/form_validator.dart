class FormValidator {

  String validateQuantidaFilhos(String text){
    if(text.isEmpty) return "Obrigatório";
    return null;
  }

  String validateGestante(String text){
    if(text.isEmpty) return "Obrigatório";
    return null;
  }

  String validateMedicamento(String text){
    if(text.isEmpty) return "Obrigatório";
    return null;
  }

  String validateNascimento(String text){
    if(text.isEmpty) return "Preencha sua data de nascimento";
    return null;
  }

  String validateIdade(String text){
    if(text.isEmpty) return "Preencha a sua idade";
    return null;
  }

  String validateNacionalidade(String text){
    if(text.isEmpty) return "Preencha a nacionalidade";
    return null;
  }

  String validateEndereco(String text){
    if(text.isEmpty) return "Preencha o seu endereço";
    return null;
  }

  String validateEstadoCivil(String text){
    if(text.isEmpty) return "Preencha o seu estado civil";
    return null;
  }

  String validateCidade(String text){
    if(text.isEmpty) return "Preencha a sua cidade";
    return null;
  }

  String validatePaiz(String text){
    if(text.isEmpty) return "Preencha o país onde vive";
    return null;
  }

  String validateDocumento(String text){
    if(text.isEmpty) return "Preencha o seu documento";
    return null;
  }

  String validateEmail(String text){
    if(text.isEmpty) return "Preencha o seu email";
    return null;
  }

  String validateTelefone(String text){
    if(text.isEmpty) return "Preencha o seu telefone";
    return null;
  }

}
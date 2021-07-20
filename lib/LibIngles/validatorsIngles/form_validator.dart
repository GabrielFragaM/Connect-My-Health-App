class FormValidator {

  String validateQuantidaFilhos(String text){
    if(text.isEmpty) return "Required";
    return null;
  }

  String validateGestante(String text){
    if(text.isEmpty) return "Required";
    return null;
  }

  String validateMedicamento(String text){
    if(text.isEmpty) return "Required";
    return null;
  }

  String validateNascimento(String text){
    if(text.isEmpty) return "Insert a valid birthday";
    return null;
  }

  String validateIdade(String text){
    if(text.isEmpty) return "Insert your age";
    return null;
  }

  String validateNacionalidade(String text){
    if(text.isEmpty) return "Insert your nationality";
    return null;
  }

  String validateEndereco(String text){
    if(text.isEmpty) return "Insert your adress";
    return null;
  }

  String validateEstadoCivil(String text){
    if(text.isEmpty) return "Insert your civil state";
    return null;
  }

  String validateCidade(String text){
    if(text.isEmpty) return "Insert your city";
    return null;
  }

  String validatePaiz(String text){
    if(text.isEmpty) return "Insert the country you live";
    return null;
  }

  String validateDocumento(String text){
    if(text.isEmpty) return "Insert your document number";
    return null;
  }

  String validateEmail(String text){
    if(text.isEmpty) return "Insert your email";
    return null;
  }

  String validateTelefone(String text){
    if(text.isEmpty) return "Insert your phone number";
    return null;
  }

}
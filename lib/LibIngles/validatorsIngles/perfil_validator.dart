class PerfilValidator {

  String validateImages(List images){
    if(images.isEmpty) return "Add an image to your profile";
    return null;
  }

  String validateImagesDocumento(List images_documento){
    if(images_documento.isEmpty) return "Upload an image of your Document!";
    return null;
  }

  String validateImagesCarteirinha(List images_carteirinha){
    if(images_carteirinha.isEmpty) return "Send an image of your Vaccination Card!";
    return null;
  }

  String validateName(String text){
    if(text.isEmpty) return "Please Insert in your full name";
    return null;
  }

  String validateNascimento(String text){
    if(text.isEmpty) return "Please Insert in your date of birth";
    if(text.length < 10) return "Please Insert in your date of birth";
    return null;
  }

  String validateIdade(String text){
    if(text.isEmpty) return "Please Insert in your age";
    return null;
  }

  String validateNacionalidade(String text){
    if(text.isEmpty) return "Insert in nationality";
    return null;
  }

  String validateEndereco(String text){
    if(text.isEmpty) return "Please Insert in your address";
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
    if(text.isEmpty) return "Insert your document";
    return null;
  }

  String validateEmail(String text){
    if(text.isEmpty) return "Insert your email";
    return null;
  }

  String validateTelefone(String text){
    if(text.isEmpty) return "Insert your phone number";
    if(text.length < 19) return "Insert your phone number";
    return null;
  }


}
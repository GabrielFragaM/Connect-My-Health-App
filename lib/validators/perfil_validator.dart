class PerfilValidator {

  String validateImages(List images){
    if(images.isEmpty) return "Adicione uma imagem para o seu perfil";
    return null;
  }

  String validateImagesDocumento(List images_documento){
    if(images_documento.isEmpty) return "Envie uma imagem do seu Documento!";
    return null;
  }

  String validateImagesCarteirinha(List images_carteirinha){
    if(images_carteirinha.isEmpty) return "Envie uma imagem da sua Carteira de vacinação!";
    return null;
  }

  String validateName(String text){
    if(text.isEmpty) return "Preencha seu nome completo";
    return null;
  }

  String validateNascimento(String text){
    if(text.isEmpty) return "Preencha sua data de nascimento";
    if(text.length < 10) return "Preencha uma data de nascimento válida";
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
    if(text.length < 19) return "Preencha um formato de telefone válido";
    return null;
  }


}
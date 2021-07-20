import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class PerfilBloc extends BlocBase {
  final dataController = BehaviorSubject<Map>();
  final loadingController = BehaviorSubject<bool>();
  final createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => dataController.stream;
  Stream<bool> get outLoading => loadingController.stream;
  Stream<bool> get outCreated => createdController.stream;

  String categoryId;
  DocumentSnapshot form;

  Map<String, dynamic> unsavedData;

  PerfilBloc({this.categoryId, this.form}) {
    if (form != null) {
      unsavedData = Map.of(form.data);
      unsavedData["imagem_documento"] = List.of(form.data["imagem_documento"]);
      unsavedData["images_carteirinha"] = List.of(form.data["images_carteirinha"]);
      unsavedData["imagem_perfil"] = List.of(form.data["imagem_perfil"]);


      createdController.add(true);
    } else {
      unsavedData = {
        "user": null,
        "data_nascimento": null,
        "idade": null,
        "estado_civil": null,
        "nacionalidade": null,
        "endereco": null,
        'estado_civil': null,
        "cidade": null,
        "paiz": null,
        "documento": null,
        "email": null,
        "telefone": null,
        "imagem_perfil": [],
        "imagem_documento": [],
        "images_carteirinha": [],
      };

      createdController.add(false);
    }

    dataController.add(unsavedData);
  }

  void deleteForm() {
    form.reference.delete();
  }


  Future uploadImages(String productId) async {
    try {
      for(int i = 0; i < unsavedData["imagem_perfil"].length; i++){
        if(unsavedData["imagem_perfil"][i] is String) continue;
        StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoryId).
        child(productId).child(DateTime.now().millisecondsSinceEpoch.toString()).
        putFile(unsavedData["imagem_perfil"][i]);

        StorageTaskSnapshot s = await uploadTask.onComplete;
        String downloadUrl = await s.ref.getDownloadURL();

        unsavedData["imagem_perfil"][i] = downloadUrl;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future uploadImages2(String productId) async {
    try {
      for(int i = 0; i < unsavedData["imagem_documento"].length; i++){
        if(unsavedData["imagem_documento"][i] is String) continue;
        StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoryId).
        child(productId).child(DateTime.now().millisecondsSinceEpoch.toString()).
        putFile(unsavedData["imagem_documento"][i]);

        StorageTaskSnapshot s = await uploadTask.onComplete;
        String downloadUrl = await s.ref.getDownloadURL();

        unsavedData["imagem_documento"][i] = downloadUrl;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future uploadImages3(String productId) async {
    try {
      for(int i = 0; i < unsavedData["images_carteirinha"].length; i++){
        if(unsavedData["images_carteirinha"][i] is String) continue;
        StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoryId).
        child(productId).child(DateTime.now().millisecondsSinceEpoch.toString()).
        putFile(unsavedData["images_carteirinha"][i]);

        StorageTaskSnapshot s = await uploadTask.onComplete;
        String downloadUrl = await s.ref.getDownloadURL();

        unsavedData["images_carteirinha"][i] = downloadUrl;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void saveImages(List imagem_perfil){
    unsavedData["imagem_perfil"] = imagem_perfil;
  }

  void saveImagesDocumento(List imagem_documento){
    unsavedData["imagem_documento"] = imagem_documento;
  }

  void saveImagesCarteirinha(List images_carteirinha){
    unsavedData["images_carteirinha"] = images_carteirinha;
  }

  void saveUser(String user){
    unsavedData["user"] = user;
  }

  void saveNascimento(String data_nascimento){
    unsavedData["data_nascimento"] = data_nascimento;
  }

  void saveIdade(String idade){
    unsavedData["idade"] = idade;
  }

  void saveNacionalidade(String nacionalidade){
    unsavedData["nacionalidade"] = nacionalidade;
  }

  void saveEndereco(String endereco){
    unsavedData["endereco"] = endereco;
  }

  void saveCidade(String cidade){
    unsavedData["cidade"] = cidade;
  }

  void saveEstadoCivil(String estado_civil){
    unsavedData["estado_civil"] = estado_civil;
  }

  void savePaiz(String paiz){
    unsavedData["paiz"] = paiz;
  }

  void saveEmail(String email){
    unsavedData["email"] = email;
  }

  void saveTelefone(String telefone){
    unsavedData["telefone"] = telefone;
  }

  void saveDocumento(String documento){
    unsavedData["documento"] = documento;
  }


  @override
  void dispose() {
    dataController.close();
    loadingController.close();
    createdController.close();
  }
}

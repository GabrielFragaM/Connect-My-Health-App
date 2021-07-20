import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';


class CategoryBloc extends BlocBase {

  final titleController = BehaviorSubject<String>();
  final cidadeController = BehaviorSubject<String>();
  final paisController = BehaviorSubject<String>();
  final nomeHospedagemController = BehaviorSubject<String>();
  final enderecoController = BehaviorSubject<String>();
  final motivoController = BehaviorSubject<String>();
  final dataController = BehaviorSubject<String>();
  final tempoController = BehaviorSubject<String>();
  final imageController = BehaviorSubject();
  final deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle =>
      titleController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
                if (title.isEmpty)
                  sink.addError("Insira um nome para o Destino");
                else
                  sink.add(title);
              }
          )
      );

  Stream get outImage =>
  imageController.stream;
  Stream<bool> get outDelete =>
  deleteController.stream;

  Stream<bool> get submitValid =>
      Observable.combineLatest2(
          outTitle, outImage, (a, b) => true
      );

  DocumentSnapshot category;

  String title;
  String cidade;
  String pais;
  String nomeHospedagem;
  String endereco;
  String motivo;
  String data;
  String tempo;
  File image;

  CategoryBloc(this.category) {
    if (category != null) {
      title = category.data["title"];

      titleController.add(category.data["title"]);
      cidadeController.add(category.data["cidade"]);
      paisController.add(category.data["pais"]);
      nomeHospedagemController.add(category.data["nomeHospedagem"]);
      enderecoController.add(category.data["endereco"]);
      motivoController.add(category.data["motivo"]);
      dataController.add(category.data["data"]);
      tempoController.add(category.data["tempo"]);
      imageController.add(category.data["icon"]);
      deleteController.add(true);
    } else {
      deleteController.add(false);
    }
  }

  void setTitle(String title) {
    this.title = title;
    titleController.add(title);
  }

  void setcidade(String cidade) {
    this.cidade = cidade;
    titleController.add(cidade);
  }

  void setpais(String pais) {
    this.pais = pais;
    titleController.add(pais);
  }

  void setnomeHospedagem(String nomeHospedagem) {
    this.nomeHospedagem = nomeHospedagem;
    titleController.add(nomeHospedagem);
  }

  void setendereco(String endereco) {
    this.endereco = endereco;
    titleController.add(endereco);
  }

  void setData(String data) {
    this.data = data;
    titleController.add(data);
  }

  void setTempo(String tempo) {
    this.tempo = tempo;
    titleController.add(tempo);
  }

  void setMotivo(String motivo) {
    this.motivo = motivo;
    titleController.add(motivo);
  }

  void delete() {

    category.reference.delete();
  }

  @override
  void dispose() {
    titleController.close();
    imageController.close();
    deleteController.close();
  }
}
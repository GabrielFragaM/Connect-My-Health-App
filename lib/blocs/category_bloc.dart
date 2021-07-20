import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';


class CategoryBloc extends BlocBase {

  final titleController = BehaviorSubject<String>();
  final origemController = BehaviorSubject<String>();
  final vacinasController = BehaviorSubject<String>();
  final locaisVisitarController = BehaviorSubject<String>();
  final nomeHotelController = BehaviorSubject<String>();
  final acomodacaoController = BehaviorSubject<String>();
  final dataController = BehaviorSubject<String>();
  final companhiaController = BehaviorSubject<String>();
  final tempoController = BehaviorSubject<String>();
  final motivoController = BehaviorSubject<String>();
  final imageController = BehaviorSubject();
  final deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle =>
      titleController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
                if (title.isEmpty)
                  sink.addError("Insira um destino");
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
  String origem;
  String vacinas;
  String locaisVisitar;
  String nomeHotel;
  String acomodacao;
  String data;
  String companhia;
  String tempo;
  String motivo;
  File image;

  CategoryBloc(this.category) {
    if (category != null) {
      title = category.data["title"];

      titleController.add(category.data["title"]);
      origemController.add(category.data["origem"]);
      vacinasController.add(category.data["vacinas"]);
      locaisVisitarController.add(category.data["locaisVisitar"]);
      nomeHotelController.add(category.data["nomeHotel"]);
      acomodacaoController.add(category.data["acomodacao"]);
      dataController.add(category.data["data"]);
      companhiaController.add(category.data["companhia"]);
      tempoController.add(category.data["tempo"]);
      motivoController.add(category.data["motivo"]);
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

  void setOrigem(String origem) {
    this.origem = origem;
    titleController.add(origem);
  }

  void setVacinas(String vacinas) {
    this.vacinas = vacinas;
    titleController.add(vacinas);
  }

  void setLocaisVisitar(String locaisVisitar) {
    this.locaisVisitar = locaisVisitar;
    titleController.add(locaisVisitar);
  }

  void setNomeHotel(String nomeHotel) {
    this.nomeHotel = nomeHotel;
    titleController.add(nomeHotel);
  }

  void setAcomodacao(String acomodacao) {
    this.acomodacao = acomodacao;
    titleController.add(acomodacao);
  }

  void setData(String data) {
    this.data = data;
    titleController.add(data);
  }

  void setCompanhia(String companhia) {
    this.companhia = companhia;
    titleController.add(companhia);
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
import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';


class PerfilCategoryBloc extends BlocBase {

  final titleController = BehaviorSubject<String>();
  final imageController = BehaviorSubject();
  final deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle =>
      titleController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
                if (title.isEmpty)
                  sink.addError("Failed Create your Profiles");
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

  DocumentSnapshot perfil_category;

  String title;
  File image;

  PerfilCategoryBloc(this.perfil_category) {
    if (perfil_category != null) {
      title = perfil_category.data["title"];

      titleController.add(perfil_category.data["title"]);
      imageController.add(perfil_category.data["icon"]);
      deleteController.add(true);
    } else {
      deleteController.add(false);
    }
  }

  void setTitle(String title) {
    this.title = title;
    titleController.add(title);
  }

  void delete() {
    perfil_category.reference.delete();
  }

  @override
  void dispose() {
    titleController.close();
    imageController.close();
    deleteController.close();
  }
}
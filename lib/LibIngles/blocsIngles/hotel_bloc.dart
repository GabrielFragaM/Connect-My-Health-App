import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class FormBloc extends BlocBase {
  final dataController = BehaviorSubject<Map>();
  final loadingController = BehaviorSubject<bool>();
  final createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => dataController.stream;
  Stream<bool> get outLoading => loadingController.stream;
  Stream<bool> get outCreated => createdController.stream;

  String categoryId;
  DocumentSnapshot form;

  Map<String, dynamic> unsavedData;

  FormBloc({this.categoryId, this.form}) {
    if (form != null) {
      unsavedData = Map.of(form.data);

      createdController.add(true);
    } else {
      unsavedData = {
        "user": null,
      };

      createdController.add(false);
    }

    dataController.add(unsavedData);
  }

  void deleteForm() {
    form.reference.delete();
  }

  @override
  void dispose() {
    dataController.close();
    loadingController.close();
    createdController.close();
  }
}

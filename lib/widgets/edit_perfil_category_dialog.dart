import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/blocs/perfil_category_bloc.dart';
import 'package:loja_virtual/models/user_model.dart';

class EditPerfilCategoryDialog extends StatefulWidget {

  final DocumentSnapshot perfil_category;

  EditPerfilCategoryDialog({this.perfil_category});

  @override
  EditPerfilCategoryDialogState createState() => EditPerfilCategoryDialogState(
      perfil_category: perfil_category
  );
}

class EditPerfilCategoryDialogState extends State<EditPerfilCategoryDialog> {
  final PerfilCategoryBloc _PerfilcategoryBloc;

  final TextEditingController _controller;


  EditPerfilCategoryDialogState({DocumentSnapshot perfil_category}) :
        _PerfilcategoryBloc = PerfilCategoryBloc(perfil_category),
        _controller = TextEditingController(text: perfil_category != null ?
        perfil_category.data["title"] : ""
        );

  @override
  Widget build(BuildContext context) {

    String uid = UserModel
        .of(context)
        .firebaseUser
        .uid;

    Future saveData() async {
      if (_PerfilcategoryBloc.image == null && _PerfilcategoryBloc.perfil_category != null &&
          _PerfilcategoryBloc.title == _PerfilcategoryBloc.perfil_category.data["title"]) return;

      Map<String, dynamic> dataToUpdate = {};

      if(_PerfilcategoryBloc.image != null){
        StorageUploadTask task = FirebaseStorage.instance.ref().child("icons")
            .child(_PerfilcategoryBloc.title).putFile(_PerfilcategoryBloc.image);
        StorageTaskSnapshot snap = await task.onComplete;
        dataToUpdate["icon"] = await snap.ref.getDownloadURL();
      }

      if (_PerfilcategoryBloc.perfil_category == null || _PerfilcategoryBloc.title != _PerfilcategoryBloc.perfil_category.data["title"]) {
        dataToUpdate["title"] = 'Meus Perfis';
        dataToUpdate["icon"] = 'https://firebasestorage.googleapis.com/v0/b/connect-my-health-24512.appspot.com/o/baixados.png?alt=media&token=586c5723-a47e-4903-a5e4-9f5ad6e22779';
      }


      if (_PerfilcategoryBloc.perfil_category == null) {
        await Firestore.instance.collection("accounts").document(uid)
            .collection("perfis").document('Meus Pefis')
            .setData(dataToUpdate);
      } else {
        await _PerfilcategoryBloc.perfil_category.reference.updateData(dataToUpdate);
      }
    }

    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                  stream: _PerfilcategoryBloc.submitValid,
                  builder: (context, snapshot) {
                    return FlatButton(
                      child: Text("Criar Meus Perfis"),
                      onPressed: null == null ? () async {
                        await saveData();
                        Navigator.of(context).pop();
                      } : null,
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}


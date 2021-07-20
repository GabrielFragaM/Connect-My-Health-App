import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/forms_painel_details.dart';
import 'package:loja_virtual/screens/perfil_screen.dart';

class PainelTile extends StatelessWidget {
  final DocumentSnapshot perfil_category;

  PainelTile(this.perfil_category);

  @override
  Widget build(BuildContext context) {
    String uid = UserModel.of(context).firebaseUser.uid;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text(
            '${perfil_category.data["email"]}',
            style:
                TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          trailing: IconButton(
              icon: Icon(Icons.restore_from_trash),
              onPressed: (){
                perfil_category.reference.delete();
              }
          ),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('accounts')
                  .document(perfil_category.documentID)
                  .collection('form_scaneados')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Column(children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('accounts')
                        .document(perfil_category.documentID)
                        .collection('perfis')
                        .document('user')
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return Column(children: [
                        Card(
                          child: ExpansionTile(
                              title: Text('Perfis Criados: '),
                              trailing:
                              Text('${snapshot.data.documents.length}', style:
                              TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w800),),

                              children: <Widget>[
                                StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('accounts')
                                      .document(perfil_category.documentID)
                                      .collection('perfis')
                                      .document('user')
                                      .collection('users')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return Container();
                                    return Column(
                                        children:
                                        snapshot.data.documents.map((doc) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  doc.data["imagem_perfil"][0]),
                                            ),
                                            title: Text(doc.data["user"]),
                                            trailing: Text('Perfil'),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PerfilScreen(
                                                            categoryId:
                                                            perfil_category
                                                                .documentID,
                                                            form: doc,
                                                          )));
                                            },
                                          );
                                        }).toList());
                                  },
                                )
                              ]),
                        ),
                      ]);
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('accounts')
                        .document(perfil_category.documentID)
                        .collection('allformsuser')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return Column(children: [
                        Card(
                          child: ExpansionTile(
                              title: Text('Formulários Criados: '),
                              trailing:
                              Text('${snapshot.data.documents.length}', style:
                              TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w800),),

                              children: <Widget>[
                                StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('accounts')
                                      .document(perfil_category.documentID)
                                      .collection('allformsuser')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return Container();
                                    return Column(
                                        children:
                                        snapshot.data.documents.map((doc) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  doc.data["imagem_perfil"]),
                                            ),
                                            title: Text(doc.data["user"]),
                                            trailing: Text('Formulário'),
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => FormScreenDetailsPainel(
                                                    id_form: doc.data["id_form"],
                                                  )));
                                            },
                                          );
                                        }).toList());
                                  },
                                )
                              ]),
                        ),
                      ]);
                    },
                  ),
                  Card(
                    child: ExpansionTile(
                      title: Text('Formulários escaneados: '),
                      trailing: Text('${snapshot.data.documents.length}', style:
                      TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w800),),
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('accounts')
                              .document(perfil_category.documentID)
                              .collection('form_scaneados')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            return Column(
                                children: snapshot.data.documents.map((doc) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(doc.data["image_profile"]),
                                ),
                                title: Text(doc.data["name_perfil"]),
                                trailing: IconButton(
                                    icon: Icon(Icons.restore_from_trash),
                                    onPressed: (){
                                      Firestore.instance.collection("accounts").document(perfil_category.documentID)
                                          .collection("form_scaneados").document(doc.reference.documentID)
                                          .delete();
                                    }
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FormScreenDetailsPainel(
                                            id_form: doc.data["idFormScan"],
                                          )));
                                },
                              );
                            }).toList());
                          },
                        ),
                      ],
                    ),
                  ),


                ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

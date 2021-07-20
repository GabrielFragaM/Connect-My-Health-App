import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/modelsIngles/user_model.dart';
import 'package:loja_virtual/LibIngles/screensIngles/perfil_screen.dart';

class PerfilTile extends StatelessWidget {

  final DocumentSnapshot perfil_category;

  PerfilTile(this.perfil_category);

  @override
  Widget build(BuildContext context) {
    String uid = UserModel.of(context).firebaseUser.uid;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){},
            child: CircleAvatar(
              backgroundImage: NetworkImage(perfil_category.data["icon"]),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text('My Profiles',
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('accounts')
                  .document(uid)
                  .collection('perfis')
                  .document('user')
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.documents.map((doc){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc.data["imagem_perfil"][0]),
                      ),
                      title: Text(doc.data["user"]),
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => PerfilScreen(
                              categoryId: perfil_category.documentID,
                              form: doc,
                            ))
                        );
                      },
                    );
                  }).toList()..add(
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.add, color: Colors.green,),
                        ),
                        title: Text("Add new profile"),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => PerfilScreen(
                                categoryId: perfil_category.documentID,
                              ))
                          );
                        },
                      )
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


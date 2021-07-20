import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/hotel_screen.dart';
import 'package:loja_virtual/screens/hotel_screen_details.dart';

import 'edit_hotel_category_dialog.dart';




class HotelTile extends StatelessWidget {

  final DocumentSnapshot category;

  HotelTile(this.category);

  @override
  Widget build(BuildContext context) {

    String uid = UserModel
        .of(context)
        .firebaseUser
        .uid;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){
          showDialog(context: context,
        builder: (context) => EditHotelCategoryDialog(
           category: category,
      )
    );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(category.data["icon"]),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text('${category.data["title"]}',
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance                  .collection('accounts')
                  .document(uid)
                  .collection('hoteis')
                  .document(category.reference.documentID)
                  .collection('forms')
                  .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.documents.map((doc){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc.data["imagem_perfil"]),
                      ),
                      title: Text(doc.data["user"]),
                      trailing: Text('Formulário'),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => FormScreenDetails(
                            categoryId: category.documentID,
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
                      title: Text("Adicionar Formulário"),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => FormScreen(
                            categoryId: category.documentID,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/widgetsIngles/hotel_tile.dart';
import 'package:loja_virtual/LibIngles/modelsIngles/user_model.dart';
import 'package:loja_virtual/LibIngles/screensIngles/login_screen.dart';

class HotelTab extends StatefulWidget {


  @override
  HotelTabState createState() => HotelTabState();
}

class HotelTabState extends State<HotelTab> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {

    super.build(context);

    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel
          .of(context)
          .firebaseUser
          .uid;

      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("accounts").document(uid)
            .collection("hoteis").snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return HotelTile(snapshot.data.documents[index]);
            },

          );
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
              size: 80.0, color: Theme
                  .of(context)
                  .primaryColor,),
            SizedBox(height: 16.0,),
            Text("Login to access your forms!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0,),
            RaisedButton(
              child: Text("Login", style: TextStyle(fontSize: 18.0),),
              textColor: Colors.white,
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            )
          ],
        ),
      );
    }
  }
  @override
  bool get wantKeepAlive => true;
}
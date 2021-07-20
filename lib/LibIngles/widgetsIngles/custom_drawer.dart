import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/modelsIngles/user_model.dart';
import 'package:loja_virtual/LibIngles/screensIngles/login_screen.dart';
import 'package:loja_virtual/LibIngles/tilesIngles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';


class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    var uid = '';
    try {
      uid = UserModel
          .of(context)
          .firebaseUser
          .uid;
    }catch (e){
      print('erro');
    }

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 236, 241),
                Colors.white
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 20.0,
                      left: 0.0,
                      child: Text("Connect My Healt",
                        style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        top: 65.0,
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Hello, ${!model.isLoggedIn() ? "" : model.userData["name_company"]}",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn() ?
                                  "Login or register >"
                                  : "Logout",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onTap: (){
                                  if(!model.isLoggedIn())
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>LoginScreen())
                                    );
                                  else
                                    model.signOut();
                                  },
                              )
                            ],
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.place, "Trip", pageController, 0),
              DrawerTile(Icons.location_city, "Accommodation", pageController, 1),
              DrawerTile(Icons.map, "Leisure", pageController, 2),
              DrawerTile(Icons.account_circle, "My Profiles", pageController, 3),
              DrawerTile(Icons.qr_code, "Scan QR code", pageController, 4),
              DrawerTile(Icons.language, "Languages", pageController, 5),
              if(uid == 'R9RupqfqE0brDCNw5HsIp09TOij2' ||uid == 'Doxvyg86fBdMcdke1oIHT2p3Gl63' || uid == 'xJSxDdyUYGc1J2v73K1tFdcqHGY2')
                DrawerTile(Icons.assignment_ind, "Painel Admin", pageController, 6),
            ],
          )
        ],
      ),
    );
  }
}

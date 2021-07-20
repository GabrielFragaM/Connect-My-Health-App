import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/main.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/scan.dart';
import 'package:loja_virtual/tabs/hotel_tab.dart';
import 'package:loja_virtual/tabs/language_tab.dart';
import 'package:loja_virtual/tabs/perfil_tab.dart';
import 'package:loja_virtual/tabs/park_tab.dart';
import 'package:loja_virtual/tabs/painel_admin.dart';
import 'package:loja_virtual/tabs/form_tab.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';
import 'package:loja_virtual/widgets/hotel_button.dart';
import 'package:loja_virtual/widgets/perfil_button.dart';
import 'package:loja_virtual/widgets/travel_button.dart';
import 'package:loja_virtual/widgets/park_button.dart';
import 'package:loja_virtual/models/user_model.dart';

import '../main.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var uid = '';

    try {
      uid = UserModel
          .of(context)
          .firebaseUser
          .uid;

    }catch (e){
      print(e);
    }


    if (UserModel.of(context).isLoggedIn() && uid == 'R9RupqfqE0brDCNw5HsIp09TOij2' ||uid == 'Doxvyg86fBdMcdke1oIHT2p3Gl63' || uid == 'xJSxDdyUYGc1J2v73K1tFdcqHGY2') {

      final _pageController = PageController();
        return PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                title: Text("Viagens"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(_pageController),
              body: FormTab(),
              floatingActionButton: TravelButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Hospedagem"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(_pageController),
              body: HotelTab(),
              floatingActionButton: HotelButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Parques/Lazer"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(_pageController),
              body: ParkTab(),
              floatingActionButton: ParkButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Perfis"),
                centerTitle: true,
              ),
              body: PerfilTab(),
              drawer: CustomDrawer(_pageController),
              floatingActionButton: PerfilButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Escanear Código QR"),
                centerTitle: true,
              ),
              body: ScanPage(),
              drawer: CustomDrawer(_pageController),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Linguagens"),
                centerTitle: true,
              ),
              body: LanguageTab(),
              drawer: CustomDrawer(_pageController),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Painel Admin"),
                centerTitle: true,
              ),
              body: PainelAdminTab(),
              drawer: CustomDrawer(_pageController),
            ),
          ],
        );
    }
    if (UserModel.of(context).isLoggedIn()) {

      final _pageController = PageController();
      return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text("Viagens"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: FormTab(),
            floatingActionButton: TravelButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Hospedagem"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: HotelTab(),
            floatingActionButton: HotelButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Parques/Lazer"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: ParkButton(),
            body: ParkTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Perfis"),
              centerTitle: true,
            ),
            body: PerfilTab(),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: PerfilButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Escanear Código QR"),
              centerTitle: true,
            ),
            body: ScanPage(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Linguagens"),
              centerTitle: true,
            ),
            body: LanguageTab(),
            drawer: CustomDrawer(_pageController),
          ),
        ],
      );
    } else {
      final _pageController = PageController();
      return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text("Viagens"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: FormTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Hospedagem"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: HotelTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Parques/Lazer"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: ParkTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Meus Perfis"),
              centerTitle: true,
            ),
            body: PerfilTab(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Escanear Código QR"),
              centerTitle: true,
            ),
            body: ScanPage(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Linguagens"),
              centerTitle: true,
            ),
            body: LanguageTab(),
            drawer: CustomDrawer(_pageController),
          ),
        ],
      );
    }
  }
  @override
  bool get wantKeepAlive => true;
}





import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/screensIngles/scan.dart';
import 'package:loja_virtual/LibIngles/tabsIngles/hotel_tab.dart';
import 'package:loja_virtual/LibIngles/tabsIngles/language_tabIngles.dart';
import 'package:loja_virtual/LibIngles/tabsIngles/perfil_tab.dart';
import 'package:loja_virtual/LibIngles/tabsIngles/park_tab.dart';
import 'package:loja_virtual/LibIngles/tabsIngles/painel_admin.dart';
import 'package:loja_virtual/LibIngles/tabsIngles/form_tab.dart';
import 'package:loja_virtual/LibIngles/widgetsIngles/custom_drawer.dart';
import 'package:loja_virtual/LibIngles/widgetsIngles/hotel_button.dart';
import 'package:loja_virtual/LibIngles/widgetsIngles/perfil_button.dart';
import 'package:loja_virtual/LibIngles/widgetsIngles/travel_button.dart';
import 'package:loja_virtual/LibIngles/widgetsIngles/park_button.dart';
import 'package:loja_virtual/LibIngles/modelsIngles/user_model.dart';

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
      print('erro');
    }
    if (UserModel.of(context).isLoggedIn() && uid == 'R9RupqfqE0brDCNw5HsIp09TOij2' ||uid == 'Doxvyg86fBdMcdke1oIHT2p3Gl63' || uid == 'xJSxDdyUYGc1J2v73K1tFdcqHGY2') {

      final _pageController = PageController();
        return PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                title: Text("Travels"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(_pageController),
              body: FormTab(),
              floatingActionButton: TravelButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Accommodation"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(_pageController),
              body: HotelTab(),
              floatingActionButton: HotelButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Parks/Leisure"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(_pageController),
              body: ParkTab(),
              floatingActionButton: ParkButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("My Profiles"),
                centerTitle: true,
              ),
              body: PerfilTab(),
              drawer: CustomDrawer(_pageController),
              floatingActionButton: PerfilButton(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Scan Qr Code"),
                centerTitle: true,
              ),
              body: ScanPage(),
              drawer: CustomDrawer(_pageController),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Languages"),
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
              title: Text("Travels"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: FormTab(),
            floatingActionButton: TravelButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Accommodation"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: HotelTab(),
            floatingActionButton: HotelButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Parks/Leisure"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: ParkButton(),
            body: ParkTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("My Profiles"),
              centerTitle: true,
            ),
            body: PerfilTab(),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: PerfilButton(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Scan Qr Code"),
              centerTitle: true,
            ),
            body: ScanPage(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Languages"),
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
              title: Text("Travels"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: FormTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Accommodation"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: HotelTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Parks/Leisure"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: ParkTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("My Profiles"),
              centerTitle: true,
            ),
            body: PerfilTab(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Scan Qr Code"),
              centerTitle: true,
            ),
            body: ScanPage(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Languages"),
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




 import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/modelsIngles/cart_model.dart';
import 'package:loja_virtual/LibIngles/modelsIngles/user_model.dart';
import 'package:loja_virtual/LibIngles/screensIngles/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
 import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(new MyApp2());

class MyApp2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            return ScopedModel<CartModel>(
              model: CartModel(model),
              child: MaterialApp(
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [const Locale('en', '')],
                  title: "Flutter's Clothing",
                  theme: ThemeData(
                      primaryColor: Color.fromRGBO(1, 0, 190, 1),
                  ),

                  debugShowCheckedModeBanner: false,
                  home: HomeScreen()
              ),
            );
          }
      ),
    );
  }
}



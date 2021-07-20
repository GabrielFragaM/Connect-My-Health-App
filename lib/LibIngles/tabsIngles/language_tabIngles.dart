
import 'package:flutter/material.dart';
import 'package:loja_virtual/LibIngles/main.dart';

import '../../main.dart';


class LanguageTab extends StatefulWidget {


  @override
  LanguageTabState createState() => LanguageTabState();
}

class LanguageTabState extends State<LanguageTab> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text("Change to Portuguese",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  textColor: Colors.white,
                  color: Theme
                      .of(context)
                      .primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                ),
              ),
              SizedBox(height: 16.0,),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text("Change to English",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  textColor: Colors.white,
                  color: Theme
                      .of(context)
                      .primaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp2()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
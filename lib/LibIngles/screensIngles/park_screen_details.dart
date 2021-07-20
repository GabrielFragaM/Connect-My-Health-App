import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:loja_virtual/LibIngles/apiIngles/pdf_api_park.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/LibIngles/blocsIngles/hotel_bloc.dart';
import 'package:loja_virtual/LibIngles/validatorsIngles/form_validator.dart';
import 'package:flutter/cupertino.dart';

class FormScreenDetails extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot form;

  FormScreenDetails({this.categoryId, this.form});

  @override
  FormScreenState createState() => FormScreenState(categoryId, form);
}

class FormScreenState extends State<FormScreenDetails> with FormValidator {
  int _stepperCount = 0;

  final FormBloc _formBloc;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String qrData = "https://github.com/neon97"; // a

  FormScreenState(String categoryId, DocumentSnapshot form)
      : _formBloc = FormBloc(categoryId: categoryId, form: form);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _formBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "My Form" : "New Form");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _formBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<Map>(
                    stream: _formBloc.outData,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.restore_from_trash),
                        onPressed: (){
                          _formBloc.deleteForm();
                          Firestore.instance.collection("accounts").document(snapshot.data['uid_account'])
                              .collection("allformsuser").document(snapshot.data['id_form'])
                              .delete();
                          Navigator.of(context).pop();
                        },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<Map>(
            stream: _formBloc.outData,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  onPressed: () async {
                    final pdfFile =
                        await PdfApiPark.generateTable(snapshot.data['id_form']);

                    PdfApiPark.openFile(pdfFile);
                  },
                );
              else
                return Container();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            child: StreamBuilder<Map>(
                stream: _formBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container();
                  else
                    qrData = snapshot.data['id_form'];
                  return ListView(
                    children: [
                      ListTile(
                        title: Text(
                          "Form completed by:",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: Text(
                          "${snapshot.data['user']} ${snapshot.data['data_form']}",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        leading: Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      snapshot.data['vacinas_pontos'] == 0 &&
                          snapshot.data['conhece_vacinas_pontos_viagem'] == 0 &&
                          snapshot.data['possui_doencas_pontos'] == 0 &&
                          snapshot.data['pontos_sintomas'] == 0 &&
                          snapshot.data['tomou_vacina_viagem_pontos'] == 0 ?
                      ListTile(

                        title: Icon(
                          Icons.info,
                          size: 40,
                          color: Colors.green,
                        ),
                      ):

                      snapshot.data['vacinas_pontos'] > 3 ||
                          snapshot.data['conhece_vacinas_pontos_viagem'] > 3 ||
                          snapshot.data['possui_doencas_pontos'] > 3 ||
                          snapshot.data['pontos_sintomas'] > 3 ||
                          snapshot.data['tomou_vacina_viagem_pontos'] > 3
                          ?
                      ListTile(

                        title: Icon(
                          Icons.info,
                          color: Colors.red,
                          size: 40,
                        ),
                      ):
                      ListTile(
                        title: Icon(
                          Icons.info,
                          size: 40,
                          color: Colors.yellow,
                        ),
                      ),

                      StreamBuilder<DocumentSnapshot>(
                          stream: Firestore.instance
                              .collection('accounts')
                              .document(snapshot.data['uid_account'])
                              .collection('perfis')
                              .document('user')
                              .collection('users')
                              .document(snapshot.data['perfil_id'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || !snapshot.data.exists)
                              return Column(
                                children: [
                                  Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            else if (snapshot.hasData)
                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 36.0,
                                      left: 6.0,
                                      right: 6.0,
                                      bottom: 6.0),
                                  child: ExpansionTile(
                                    title: Text(
                                      'Show Profile',
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          "Profile picture:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.account_circle,

                                          size: 40,
                                        ),
                                      ),
                                      Container(
                                        height: 180.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot.data["imagem_perfil"][0]),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Full name:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['user']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Email:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['email']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.email,
                                          size: 40,
                                        ),
                                      ),


                                      ListTile(
                                        title: Text(
                                          "Contact Phone:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['telefone']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.phone_android,
                                          size: 40,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Birth date:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['data_nascimento'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.date_range,
                                          size: 40,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Age:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['idade'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('null', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.celebration,
                                          size: 40,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Nationality:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['nacionalidade']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.place,
                                          size: 40,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Marital status:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['estado_civil'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.people,
                                          size: 40,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Document Type:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['tipo_documento'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('null', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.contact_page,
                                          size: 40,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Document number:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['documento'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('null', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.credit_card,
                                          size: 40,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Document Photo:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.inbox,
                                          size: 40,
                                        ),
                                      ),
                                      Container(
                                        height: 200.0,
                                        width: 300.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot.data["imagem_documento"][0]),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),

                                      ListTile(
                                        title: Text(
                                          "Photo of the Vaccination Card:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.inbox,
                                          size: 40,
                                        ),
                                      ),
                                      Container(
                                        height: 200.0,
                                        width: 300.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot.data["images_carteirinha"][0]),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Address:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['endereco'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('null', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.home,
                                          size: 40,
                                        ),
                                      ),


                                      ListTile(
                                        title: Text(
                                          "City:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['cidade'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Sem data').replaceAll('null', 'Sem data')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.location_city,
                                          size: 40,
                                        ),
                                      ),


                                      ListTile(
                                        title: Text(
                                          "Country:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['paiz'].toString()}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.place,
                                          size: 40,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              );
                          }),
                      StreamBuilder<DocumentSnapshot>(
                          stream: Firestore.instance
                              .collection('accounts')
                              .document(snapshot.data['uid_account'])
                              .collection('parks')
                              .document(snapshot.data['uid_category'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || !snapshot.data.exists)
                              return Column(
                                children: [
                                  Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            else if (snapshot.hasData)
                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 36.0,
                                      left: 6.0,
                                      right: 6.0,
                                      bottom: 6.0),
                                  child: ExpansionTile(
                                    title: Text(
                                      'Show Details Destination/Leisure',
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          "Destination name",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['title']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Address:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['endereco']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "City:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['cidade']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Country:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['pais']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Start period:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['periodo'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Date:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['data']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Type of leisure:",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data['tipo'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.library_books,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                          }),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                          child: ExpansionTile(
                            title: Text(
                              'Show Form QR Code',
                            ),
                            children: <Widget>[
                              QrImage(
                                data: qrData,
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                          child: ExpansionTile(
                            title: Text(
                              'Show Form Details',
                            ),
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Blood type:",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "${snapshot.data['tipo_sangue']}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.playlist_add_check,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                              if(snapshot.data['quantidadefilhos'] != '')
                                ListTile(
                                  title: Text(
                                    "Number of children:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['quantidadefilhos']}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),
                              if(snapshot.data['quantidadefilhos'] == '')
                                ListTile(
                                  title: Text(
                                    "Number of children:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "No Info",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),
                              ListTile(
                                title: Text(
                                  "Are you pregnant ?",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "${snapshot.data['gestante']}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.playlist_add_check,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                              if(snapshot.data['quantidade_gestacao'] != '')
                                ListTile(
                                  title: Text(
                                    "How many weeks:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['quantidade_gestacao']}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),
                              if(snapshot.data['quantidade_gestacao'] == '')
                                ListTile(
                                  title: Text(
                                    "How many weeks:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "No Info",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['possui_doencas_pontos'] == 0 && snapshot.data['possui_doencas_verificar'] == 1 )
                                ListTile(
                                  title: Text(
                                    "Do you have any illnesses? ?",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "No",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['possui_doencas_pontos'] == 0 && snapshot.data['possui_doencas_verificar'] == 2 )
                                ListTile(
                                  title: Text(
                                    "Do you have any illnesses? ?",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['possui_doencas'].toString().replaceAll('[', '').replaceAll(']', '')}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['possui_doencas_pontos'] == 3 && snapshot.data['possui_doencas_verificar'] == 3 )
                                ListTile(
                                  title: Text(
                                    "Do you have any illnesses? ?",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['possui_doencas'].toString().replaceAll('[', '').replaceAll(']', '')}, ${snapshot.data['possui_doencas_outra']} ",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.yellow,
                                    size: 40,
                                  ),
                                ),

                              ListTile(
                                title: Text(
                                  "Do you use any medications daily ?",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "${snapshot.data['medicamento']}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.playlist_add_check,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                              if(snapshot.data['tomou_vacina_viagem_pontos'] == 3)
                                ListTile(
                                  title: Text(
                                    "Did you have any vaccinations for this trip:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "No",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(Icons.info,size: 40,
                                    color: Colors.yellow,
                                  ),
                                ),
                              if(snapshot.data['tomou_vacina_viagem_pontos'] == 0)
                                ListTile(
                                  title: Text(
                                    "Did you have any vaccinations for this trip:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    snapshot.data['tomou_vacinas_viagem_qual'],
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(Icons.info,size: 40,
                                    color: Colors.green,
                                  ),
                                ),

                              if(snapshot.data['vacinas_pontos'] == 0)
                                ListTile(
                                  title: Text(
                                    "Vaccines taken previously:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['vacinas'].toString().replaceAll('[', '').replaceAll(']', '')}, ${snapshot.data['outras_vacinas']}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['vacinas_pontos'] == 3)
                                ListTile(
                                  title: Text(
                                    "Vaccines taken previously:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['outras_vacinas']}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.yellow,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['vacinas_pontos'] == 5)
                                ListTile(
                                  title: Text(
                                    "Vaccines taken previously:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "None",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),


                              if(snapshot.data['conhece_vacinas_viagem'] == 'Sim')
                                ListTile(
                                  title: Text(
                                    "Do you know the necessary\nvaccinations for the destination(s) of your trip:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Yes",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),
                              if(snapshot.data['conhece_vacinas_viagem'] == 'Não')
                                ListTile(
                                  title: Text(
                                    "Do you know the necessary\nvaccinations for the destination(s) of your trip:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "No",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.yellow,
                                    size: 40,
                                  ),
                                ),


                              if(snapshot.data['ja_teve_doencas_pontos'] == 0 && snapshot.data['ja_teve_doencas_verificar'] == 1 )
                                ListTile(
                                  title: Text(
                                    "Have you had these illnesses ?",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "None",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['ja_teve_doencas_pontos'] == 0 && snapshot.data['ja_teve_doencas_verificar'] == 2 )
                                ListTile(
                                  title: Text(
                                    "Have you had these illnesses ?",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['ja_teve_doencas'].toString().replaceAll('[', '').replaceAll(']', '')}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['ja_teve_doencas_pontos'] == 3 && snapshot.data['ja_teve_doencas_verificar'] == 3 )
                                ListTile(
                                  title: Text(
                                    "Have you had these illnesses ?",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['ja_teve_doencas'].toString().replaceAll('[', '').replaceAll(']', '')}, ${snapshot.data['ja_teve_doencas_outras']} ",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.yellow,
                                    size: 40,
                                  ),
                                ),

                              if(snapshot.data['ja_teve_doencas_pontos'] == 3 && snapshot.data['ja_teve_doencas_verificar'] == 4 )
                                ListTile(
                                  title: Text(
                                    "Have you had these illnesses ?",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['ja_teve_doencas_outras']} ",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.yellow,
                                    size: 40,
                                  ),
                                ),




                              if(snapshot.data['ano_teve_doencas'] != '')
                                ListTile(
                                  title: Text(
                                    "Year I had these diseases:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${snapshot.data['ano_teve_doencas'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Sem data').replaceAll('null', 'Sem data')}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),
                              if(snapshot.data['ano_teve_doencas'] == '')
                                ListTile(
                                  title: Text(
                                    "Year I had these diseases:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "No Info",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),


                              snapshot.data['pontos_sintomas'] == 0?
                              ListTile(
                                title: Text(
                                  "Have you had any of these symptoms in the last 7 days:",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "None",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.info,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ):
                              snapshot.data['pontos_sintomas'] > 3 ?
                              ListTile(
                                title: Text(
                                  "Have you had any of these symptoms in the last 7 days:",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "${snapshot.data['sintomas'].toString().replaceAll('[', '').replaceAll(']', '')}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.info,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ):
                              ListTile(
                                title: Text(
                                  "Have you had any of these symptoms in the last 7 days:",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "${snapshot.data['sintomas'].toString().replaceAll('[', '').replaceAll(']', '')}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.info,
                                  color: Colors.yellow,
                                  size: 40,
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _formBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/api/pdf_api.dart';
import 'package:loja_virtual/api/pdf_api_viagem.dart';
import 'package:loja_virtual/api/pdf_api_park.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';



class FormScreenDetailsPainel extends StatefulWidget {
  final String id_form;


  FormScreenDetailsPainel({this.id_form});

  @override
  FormScreenState createState() => FormScreenState(id_form);
}

class FormScreenState extends State<FormScreenDetailsPainel> {
  final FormScreenDetailsPainel _formScreenDetais;

  FormScreenState(String id_form,)
      : _formScreenDetais = FormScreenDetailsPainel(id_form: id_form);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Formulário'),
      actions: [
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
          .collection('allforms')
          .document(_formScreenDetais.id_form)
          .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return IconButton(
                icon: Icon(Icons.picture_as_pdf),
                onPressed: () async {
                  if(snapshot.data['form_destino'] == 'Hotel') {
                    final _pdfFile =
                    await PdfApiHotel.generateTable(snapshot.data['id_form']);

                    PdfApiHotel.openFile(_pdfFile);
                  }
                  if(snapshot.data['form_destino'] == 'Viagem') {
                    final _pdfFile =
                    await PdfApiViagem.generateTable(snapshot.data['id_form']);

                    PdfApiViagem.openFile(_pdfFile);
                  }
                  if(snapshot.data['form_destino'] == 'Park') {
                    final _pdfFile =
                    await PdfApiPark.generateTable(snapshot.data['id_form']);

                    PdfApiPark.openFile(_pdfFile);
                  }
                },
              );
            else
              return Container();
          },
        ),
      ],
      ),

      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            child: StreamBuilder<DocumentSnapshot >(
                stream: Firestore.instance
                    .collection('allforms')
                    .document(_formScreenDetais.id_form)
                    .snapshots(),
                builder: (context, snapshot) {
                 if(snapshot.hasData)
                    return ListView(
                      children: [
                        ListTile(
                          title: Text(
                            "Formulário preenchido por:",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Text(
                            "${snapshot.data['user']} em ${snapshot.data['data_form']}",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          leading: Icon(Icons.account_circle,size: 40,
                          ),
                        ),
                        SizedBox(height: 30.0,),
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

                        if(snapshot.data['form_destino'] == 'Hotel')
                          StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('accounts')
                                  .document(snapshot.data['uid_account'])
                                  .collection('all_locais')
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
                                          'Mostrar Detalhes do Hotel',
                                        ),
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              "Nome da Hospedagem:",
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
                                              "Endereço da Hospedagem:",
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
                                              "Cidade de Hospedagem:",
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
                                              "País de Hospedagem:",
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
                                              "Tempo de duração (em dias):",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${snapshot.data['tempo'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
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
                                              "Data de Check-in:",
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
                                              "Motivo:",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${snapshot.data['motivo'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
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
                        if(snapshot.data['form_destino'] == 'Park')
                          StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('accounts')
                                  .document(snapshot.data['uid_account'])
                                  .collection('all_locais')
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
                                          'Mostrar Detalhes Destino/Lazer',
                                        ),
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              "Nome:",
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
                                              "Endereço:",
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
                                              "Cidade:",
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
                                              "País:",
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
                                              "Período de início:",
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
                                              "Data:",
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
                                              "Tipo de lazer:",
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
                        StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('accounts')
                                .document(snapshot.data['uid_account'])
                                .collection('perfis')
                                .document('user').collection('users').document(snapshot.data['perfil_id'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || !snapshot.data.exists)
                                return Column(
                                  children: [
                                    Text(
                                      "Nenhuma informação encontrada !",
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
                                        'Mostrar Perfil Completo',
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                            "Foto de Perfil:",
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
                                            "Nome Completo:",
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
                                            "Telefone Para Contato:",
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
                                            "Data de Nascimento:",
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
                                            "Idade:",
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
                                            "Nacionalidade:",
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
                                            "Estado Civil:",
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
                                            "Tipo de Documento:",
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
                                            "Número do Documento:",
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
                                            "Foto do Documento:",
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
                                            "Foto da Carteira de Vacinação:",
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
                                            "Endereço:",
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
                                            "Cidade:",
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
                                            "País:",
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
                        if(snapshot.data['form_destino'] == 'Viagem')
                        StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('accounts')
                                .document(snapshot.data['uid_account'])
                                .collection('all_locais')
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
                                        'Mostrar Detalhes da Viagem',
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                            "Destino:",
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
                                            "Origem:",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${snapshot.data['origem']}",
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
                                            "Motivo da Viagem:",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${snapshot.data['motivo']}",
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
                                            "Tempo de duração da viagem(em dias):",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${snapshot.data['tempo'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
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
                                            "Companhia Aérea:",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${snapshot.data['companhia'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('null', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
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
                                            "Data de embarque:",
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
                                            "Nome Hotel/Endereço Acomodação:",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${snapshot.data['nomeHotel'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('[null]', 'Nenhuma')}",
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
                                            "Outros locais(cidade) que vai visitar:",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${snapshot.data['locaisVisitar'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('[]', 'Nenhuma').replaceAll('null', 'Nenhuma')}",
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
                                'Exibir Formulário',
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "Tipo Sanguíneo:",
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
                                      "Quantidade de filhos:",
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
                                      "Quantidade de filhos:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Sem Informação",
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
                                    "È gestante ?",
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
                                      "Tempo de gestação:",
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
                                      "Tempo de gestação:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Sem Informação",
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
                                      "Possui alguma doença ?",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Nenhuma",
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
                                      "Possui alguma doença ?",
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
                                      "Possui alguma doença ?",
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
                                    "Faz uso de algum medicamento diário ?",
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
                                      "Tomou alguma vacina para esta viagem:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Não",
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
                                      "Tomou alguma vacina para esta viagem:",
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
                                      "Vacinas tomadas anteriormento:",
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
                                      "Vacinas tomadas anteriormento:",
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
                                      "Vacinas tomadas anteriormento:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Nenhuma",
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
                                      "Você sabe quais são as vacinas para o destino:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Sim",
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
                                      "Você sabe quais são as vacinas para o destino:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Não",
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
                                      "Já teve doenças ?",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Nenhuma",
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
                                      "Já teve doenças ?",
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
                                      "Já teve doenças ?",
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
                                      "Já teve doenças ?",
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
                                      "Ano que tive essas doenças:",
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
                                      "Ano que tive essas doenças:",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Sem Data",
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
                                    "Sintomas nos últimos 7 dias:",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Nenhum",
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
                                    "Sintomas nos últimos 7 dias:",
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
                                    "Sintomas nos últimos 7 dias:",
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
        ],
      ),
    );
  }
}
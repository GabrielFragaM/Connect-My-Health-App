import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:loja_virtual/blocs/perfis_bloc.dart';
import 'package:loja_virtual/validators/perfil_validator.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/widgets/images_widget.dart';
import 'package:loja_virtual/widgets/images_widget2.dart';
import 'package:loja_virtual/widgets/images_widget3.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PerfilScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot form;

  PerfilScreen({this.categoryId, this.form});

  @override
  PerfilScreenState createState() => PerfilScreenState(categoryId, form);
}

class PerfilScreenState extends State<PerfilScreen> with PerfilValidator {
  int _stepperCount = 0;

  //Chave do form
  final _formKey = GlobalKey<FormState>();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: { "#": RegExp(r'[0-9]')});
  var maskFormatterphone = new MaskTextInputFormatter(
      mask: '+## (##) #####-####', filter: { "#": RegExp(r'[0-9]')});

  String tipo_documento = '';

  FirebaseUser firebaseUser;

  final PerfilBloc _formBloc;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PerfilScreenState(String categoryId, DocumentSnapshot form)
      : _formBloc = PerfilBloc(categoryId: categoryId, form: form);

  @override
  Widget build(BuildContext context) {
    String uid = UserModel
        .of(context)
        .firebaseUser
        .uid;
    Future getValues() async {
      DocumentSnapshot dr = await Firestore.instance
          .collection("accounts")
          .document(uid)
          .collection("perfis")
          .document('user')
          .collection('users').document(_formBloc.form.documentID).get();

      setState(() {
        tipo_documento = dr.data['tipo_documento'];
      });
    }
    if (tipo_documento == '') {
      getValues();
    }
    if (tipo_documento != '') {

    }

    Future<bool> saveFormOficial() async {
      _formBloc.loadingController.add(true);

      try {
        if (_formBloc.form != null) {
          await _formBloc.uploadImages(_formBloc.form.documentID);
          await _formBloc.uploadImages2(_formBloc.form.documentID);
          await _formBloc.uploadImages3(_formBloc.form.documentID);
          await _formBloc.form.reference.updateData(_formBloc.unsavedData);
        } else {
          DocumentReference dr = await Firestore.instance
              .collection("accounts")
              .document(uid)
              .collection("perfis")
              .document('user')
              .collection('users')
              .add(Map.from(_formBloc.unsavedData)
            ..remove("imagem_perfil")..remove('imagem_documento')..remove('images_carteirinha'));

          await _formBloc.uploadImages(dr.documentID);
          await _formBloc.uploadImages2(dr.documentID);
          await _formBloc.uploadImages3(dr.documentID);
          await dr.updateData(_formBloc.unsavedData);
        }
        _formBloc.createdController.add(true);
        _formBloc.loadingController.add(false);
        return true;
      } catch (e) {
        _formBloc.loadingController.add(false);
        return false;
      }
    }

    Future<bool> saveFormOficialAllPerfis() async {
      _formBloc.loadingController.add(true);

      try {
        if (_formBloc.form != null) {
          await _formBloc.uploadImages(_formBloc.form.documentID);
          await _formBloc.uploadImages2(_formBloc.form.documentID);
          await _formBloc.uploadImages3(_formBloc.form.documentID);
          await _formBloc.form.reference.updateData(_formBloc.unsavedData);
        } else {
          DocumentReference dr = await Firestore.instance
              .collection("Allperfis")
              .add(Map.from(_formBloc.unsavedData)
            ..remove("imagem_perfil")..remove('imagem_documento')..remove('images_carteirinha'));
          await _formBloc.uploadImages(dr.documentID);
          await _formBloc.uploadImages2(dr.documentID);
          await _formBloc.uploadImages3(dr.documentID);
          await dr.updateData(_formBloc.unsavedData);
        }
        _formBloc.createdController.add(true);
        _formBloc.loadingController.add(false);
        return true;
      } catch (e) {
        _formBloc.loadingController.add(false);
        return false;
      }
    }

    void saveForm() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        _formBloc.unsavedData["tipo_documento"] = tipo_documento.toString();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Salvando Perfil...",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.blue,
        ));

        await saveFormOficialAllPerfis();
        bool success = await saveFormOficial();

        _scaffoldKey.currentState.removeCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            success ? "Perfil salvo!" : "Erro ao salvar um novo Perfil!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ));
        Navigator.of(context).pop();
      }else{
        _scaffoldKey.currentState.removeCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Você precisa estar com todos os dados preenchidos antes de salvar !",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }

    final _fieldStyle = TextStyle(color: Colors.black, fontSize: 16);

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.black));
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _formBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editar Perfil" : "Novo Perfil");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _formBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _formBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.restore_from_trash),
                        onPressed: snapshot.data
                            ? null
                            : () {
                          _formBloc.deleteForm();
                          Navigator.of(context).pop();
                        },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _formBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: saveForm,
                );
              }
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _formBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return Stepper(
                      controlsBuilder: (BuildContext context,
                          {VoidCallback onStepContinue,
                            VoidCallback onStepCancel}) =>
                          Container(),
                      currentStep: _stepperCount,
                      onStepTapped: (index) {
                        setState(() {
                          _stepperCount = index;
                        });
                      },
                      steps: [
                        _createStepper(
                          0,
                          Text(
                            "Foto de Perfil",
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          ImagesWidget(
                            context: context,
                            initialValue: snapshot.data["imagem_perfil"],
                            onSaved: _formBloc.saveImages,
                            validator: validateImages,
                          ),
                        ),
                        _createStepper(
                            1,
                            Text(
                              "Perfil Completo",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                            Column(children: [
                              TextFormField(
                                initialValue: snapshot.data["user"],
                                validator: validateName,
                                style: _fieldStyle,
                                onSaved: _formBloc.saveUser,
                                decoration: _buildDecoration("Nome Completo"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["email"],
                                validator: validateEmail,
                                onSaved: _formBloc.saveEmail,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Email"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["telefone"],
                                validator: validateTelefone,
                                keyboardType: TextInputType.number,
                                inputFormatters: [maskFormatterphone],
                                onSaved: _formBloc.saveTelefone,
                                style: _fieldStyle,
                                decoration:
                                _buildDecoration("Telefone Para Contato"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["data_nascimento"],
                                validator: validateNascimento,
                                inputFormatters: [maskFormatter],
                                keyboardType: TextInputType.number,
                                style: _fieldStyle,
                                onSaved: _formBloc.saveNascimento,
                                decoration:
                                _buildDecoration("Data de Nascimento"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["idade"],
                                validator: validateIdade,
                                onSaved: _formBloc.saveIdade,
                                keyboardType: TextInputType.number,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Idade"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["nacionalidade"],
                                validator: validateNacionalidade,
                                onSaved: _formBloc.saveNacionalidade,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Nacionalidade"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["estado_civil"],
                                validator: validateEstadoCivil,
                                onSaved: _formBloc.saveEstadoCivil,
                                style: _fieldStyle,
                                decoration: _buildDecoration(
                                    "Estado Civil "),
                              ),
                              SizedBox(height: 16,),
                              Text("Documento"),
                              Column(children: [
                                  RadioButton(
                                    description: "CPF",
                                    value: "CPF",
                                    groupValue: tipo_documento,
                                    onChanged: (value) =>
                                        setState(
                                              () => tipo_documento = value,
                                        ),
                                  ),
                                  RadioButton(
                                    description: "RG",
                                    value: "RG",
                                    groupValue: tipo_documento,
                                    onChanged: (value) =>
                                        setState(
                                              () => tipo_documento = value,
                                        ),
                                  ),
                                  RadioButton(
                                    description: "Passaporte",
                                    value: "Passaporte",
                                    groupValue: tipo_documento,
                                    onChanged: (value) =>
                                        setState(
                                              () => tipo_documento = value,
                                        ),
                                  ),
                                  TextFormField(
                                    initialValue: snapshot.data["documento"],
                                    validator: validateDocumento,
                                    onSaved: _formBloc.saveDocumento,
                                    style: _fieldStyle,
                                    decoration: _buildDecoration(
                                        "Digite o número do seu documento."),
                                  ),
                                  ]),
                            ])),
                        _createStepper(
                          2,
                          Text(
                            "Foto de Documentos",
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          ImagesWidget2(
                            context: context,
                            initialValue: snapshot.data["imagem_documento"],
                            onSaved: _formBloc.saveImagesDocumento,
                            validator: validateImagesDocumento,
                          ),
                        ),
                        _createStepper(
                          3,
                          Text(
                            "Foto da Carteira de vacinação",
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          ImagesWidget3(
                            context: context,
                            initialValue: snapshot.data["images_carteirinha"],
                            onSaved: _formBloc.saveImagesCarteirinha,
                            validator: validateImagesCarteirinha,
                          ),
                        ),
                        _createStepper(
                            4,
                            Text(
                              "Endereço Completo",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                            Column(children: [
                              TextFormField(
                                initialValue: snapshot.data["endereco"],
                                validator: validateEndereco,
                                onSaved: _formBloc.saveEndereco,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Endereço"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["cidade"],
                                validator: validateCidade,
                                onSaved: _formBloc.saveCidade,
                                style: _fieldStyle,
                                decoration: _buildDecoration("Cidade"),
                              ),
                              TextFormField(
                                initialValue: snapshot.data["paiz"],
                                validator: validatePaiz,
                                onSaved: _formBloc.savePaiz,
                                style: _fieldStyle,
                                decoration: _buildDecoration("País"),
                              ),
                            ])),
                      ]);
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

  Step _createStepper(int index, Text _title, _content) {
    return Step(
      isActive: _stepperCount == index,
      title: _title,
      content: _content,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/blocs/category_bloc.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/validators/travel_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class EditCategoryDialog extends StatefulWidget {
  final DocumentSnapshot category;

  EditCategoryDialog({this.category});

  @override
  EditCategoryDialogState createState() =>
      EditCategoryDialogState(category: category);
}

class EditCategoryDialogState extends State<EditCategoryDialog>
    with TravelValidator {
  final CategoryBloc _categoryBloc;
  final _formKey = GlobalKey<FormState>();
  int _stepperCount = 0;



  final TextEditingController _controller;
  final TextEditingController _controllerOrigem;
  final TextEditingController _controllerLocaisVisitar;
  final TextEditingController _controllerNomeHotel;
  final TextEditingController _controllerAcomodacao;
  final TextEditingController dateController;
  final TextEditingController _controllerCompanhia;
  final TextEditingController _controllerTempo;
  final TextEditingController _controllerMotivo;
  bool conhece_vacinas = false;

  EditCategoryDialogState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        _controllerOrigem = TextEditingController(
            text: category != null ? category.data["origem"] : ""),
        _controllerLocaisVisitar = TextEditingController(
            text: category != null ? category.data["locaisVisitar"] : ""),
        _controllerNomeHotel = TextEditingController(
            text: category != null ? category.data["nomeHotel"] : ""),
        _controllerAcomodacao = TextEditingController(
            text: category != null ? category.data["acomodacao"] : ""),
        dateController = TextEditingController(
            text: category != null ? category.data["data"] : ""),
        _controllerCompanhia = TextEditingController(
            text: category != null ? category.data["companhia"] : ""),
        _controllerTempo = TextEditingController(
            text: category != null ? category.data["tempo"] : ""),
        _controllerMotivo = TextEditingController(
            text: category != null ? category.data["motivo"] : ""),
        _controller = TextEditingController(
            text: category != null ? category.data["title"] : "");

  @override
  Widget build(BuildContext context) {
    String uid = UserModel.of(context).firebaseUser.uid;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    Future saveData() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        if (_categoryBloc.image == null &&
            _categoryBloc.category != null &&
            _categoryBloc.locaisVisitar == _categoryBloc.category.data["locaisVisitar"] &&
            _categoryBloc.nomeHotel == _categoryBloc.category.data["nomeHotel"] &&
            _categoryBloc.acomodacao == _categoryBloc.category.data["acomodacao"] &&
            _categoryBloc.data == _categoryBloc.category.data["data"] &&
            _categoryBloc.companhia == _categoryBloc.category.data["companhia"] &&
            _categoryBloc.tempo == _categoryBloc.category.data["tempo"] &&
            _categoryBloc.motivo == _categoryBloc.category.data["motivo"] &&
            _categoryBloc.origem == _categoryBloc.category.data["origem"] &&
            _categoryBloc.title == _categoryBloc.category.data["title"])
          return;

        Map<String, dynamic> dataToUpdate = {};

        if (_categoryBloc.image != null) {
          StorageUploadTask task = FirebaseStorage.instance
              .ref()
              .child("icons")
              .child(_categoryBloc.title)
              .putFile(_categoryBloc.image);
          StorageTaskSnapshot snap = await task.onComplete;
          dataToUpdate["icon"] = await snap.ref.getDownloadURL();
        }

        if (_categoryBloc.category == null ||
            _categoryBloc.title != _categoryBloc.category.data["title"] ||
            _categoryBloc.title != _categoryBloc.category.data["origem"] ||
            _categoryBloc.title != _categoryBloc.category.data["locaisVisitar"] ||
            _categoryBloc.title != _categoryBloc.category.data["acomodacao"] ||
            _categoryBloc.title != _categoryBloc.category.data["companhia"] ||
            _categoryBloc.title != _categoryBloc.category.data["tempo"] ||
            _categoryBloc.title != _categoryBloc.category.data["motivo"]) {
          dataToUpdate["title"] = _categoryBloc.title;
          dataToUpdate["origem"] = _controllerOrigem.text;

          dataToUpdate["locaisVisitar"] = _controllerLocaisVisitar.text;
          dataToUpdate["nomeHotel"] = _controllerNomeHotel.text;
          dataToUpdate["acomodacao"] = _controllerAcomodacao.text;
          dataToUpdate["data"] = dateController.text;
          dataToUpdate["companhia"] = _controllerCompanhia.text;
          dataToUpdate["tempo"] = _controllerTempo.text;
          dataToUpdate["motivo"] = _controllerMotivo.text;
          dataToUpdate["icon"] =
              'https://firebasestorage.googleapis.com/v0/b/connect-my-health-24512.appspot.com/o/edit_viagem.png?alt=media&token=d4c2ecde-9e3c-446b-89f0-d8d5d605e1f6';
        }

        if (_categoryBloc.category == null) {
          await Firestore.instance
              .collection("accounts")
              .document(uid)
              .collection("travels")
              .document(_categoryBloc.title.toLowerCase())
              .setData(dataToUpdate);
          await Firestore.instance
              .collection("accounts")
              .document(uid)
              .collection("all_locais")
              .document(_categoryBloc.title.toLowerCase())
              .setData(dataToUpdate);
        } else {
          await _categoryBloc.category.reference.updateData(dataToUpdate);
        }
        Navigator.of(context).pop();

      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: _categoryBloc.outTitle,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? "Editar Viagem" : "Nova Viagem");
            }),
        elevation: 0,
        actions: <Widget>[
          StreamBuilder<String>(
            stream: _categoryBloc.outTitle,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return IconButton(
                        icon: Icon(Icons.restore_from_trash),
                        onPressed: snapshot.data
                            ? () {
                                _categoryBloc.delete();
                                Navigator.of(context).pop();
                              }
                            : null,
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _categoryBloc.outDelete,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: saveData,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: ListTile(
              title: StreamBuilder<String>(
                  stream: _categoryBloc.outTitle,
                  builder: (context, snapshot) {
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
                                "Viagem   ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Destino da viagem ?                                            '),
                                  TextFormField(
                                    controller: _controller,
                                    onChanged: _categoryBloc.setTitle,
                                    validator: validateDestino,
                                    decoration: InputDecoration(
                                        hintText: 'Digite aqui..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Origem da viagem ?                                       '),
                                  TextFormField(
                                    controller: _controllerOrigem,
                                    onChanged: _categoryBloc.setOrigem,
                                    validator: validateOrigem,
                                    decoration: InputDecoration(
                                        hintText: 'Digite aqui..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Motivo da viagem ?                                       '),
                                  TextFormField(
                                    controller: _controllerMotivo,
                                    onChanged: _categoryBloc.setMotivo,
                                    validator: validateMotivo,
                                    decoration: InputDecoration(
                                        hintText: 'Digite aqui..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Tempo de duração da viagem(em dias) ?                                       '),
                                  TextFormField(
                                    controller: _controllerTempo,
                                    onChanged: _categoryBloc.setTempo,
                                    keyboardType: TextInputType.number,
                                    validator: validateTempo,
                                    decoration: InputDecoration(
                                        hintText: 'Digite aqui..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                ],
                              )),
                          _createStepper(
                              1,
                              Text(
                                "Detalhes da viagem",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Column(children: [
                                Text(
                                  'Companhia Aérea ?                                       ',
                                ),
                                TextFormField(
                                  controller: _controllerCompanhia,
                                  onChanged: _categoryBloc.setCompanhia,
                                  validator: validateCompanhia,
                                  decoration: InputDecoration(
                                      hintText: 'Digite aqui..',
                                      errorText: snapshot.hasError
                                          ? snapshot.error
                                          : null),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                    'Data de embarque ?                                       '),
                                TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    var date =  await showDatePicker(
                                        context: context,
                                        locale : const Locale("pt",""),
                                        initialDate:DateTime.now(),
                                        firstDate:DateTime(1900),
                                        lastDate: DateTime(2100)
                                    );
                                    dateController.text = date.toString().substring(0,10);
                                  },
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    labelText: "Data Embarque",
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                    'Tipo de acomodação ?                                       '),
                                TextFormField(
                                  controller: _controllerAcomodacao,
                                  onChanged: _categoryBloc.setAcomodacao,
                                  validator: validateAcomodacao,
                                  decoration: InputDecoration(
                                      hintText: 'Digite aqui..',
                                      errorText: snapshot.hasError
                                          ? snapshot.error
                                          : null),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text('Nome Hotel/Endereço Acomodação ?             '),
                                TextFormField(
                                  controller: _controllerNomeHotel,
                                  onChanged: _categoryBloc.setNomeHotel,
                                  validator: validateNomeHotel,
                                  decoration: InputDecoration(
                                      hintText: 'Digite aqui..',
                                      errorText: snapshot.hasError
                                          ? snapshot.error
                                          : null),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text('Outros locais(cidade) que vai visitar.             '),
                                TextFormField(
                                  controller: _controllerLocaisVisitar,
                                  onChanged: _categoryBloc.setLocaisVisitar,
                                  decoration: InputDecoration(
                                      hintText: 'Não é obrigatório..',
                                      errorText: snapshot.hasError
                                          ? snapshot.error
                                          : null),
                                ),
                              ])),
                        ]);
                  }),
            ),
          ),
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

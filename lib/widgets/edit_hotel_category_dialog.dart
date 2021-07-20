import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/blocs/hotelCategory_bloc.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/validators/travel_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class EditHotelCategoryDialog extends StatefulWidget {
  final DocumentSnapshot category;

  EditHotelCategoryDialog({this.category});

  @override
  EditCategoryDialogState createState() =>
      EditCategoryDialogState(category: category);
}

class EditCategoryDialogState extends State<EditHotelCategoryDialog>
    with TravelValidator {
  final CategoryBloc _categoryBloc;
  final _formKey = GlobalKey<FormState>();
  int _stepperCount = 0;



  final TextEditingController _controller;
  final TextEditingController cidadeController;
  final TextEditingController paisController;
  final TextEditingController nomeHospedagemController;
  final TextEditingController enderecoController;
  final TextEditingController motivoController;
  final TextEditingController dataController;
  final TextEditingController _controllerTempo;
  bool conhece_vacinas = false;

  EditCategoryDialogState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        cidadeController = TextEditingController(
            text: category != null ? category.data["cidade"] : ""),
        paisController = TextEditingController(
            text: category != null ? category.data["pais"] : ""),
        nomeHospedagemController = TextEditingController(
            text: category != null ? category.data["nomeHospedagem"] : ""),
        enderecoController = TextEditingController(
            text: category != null ? category.data["endereco"] : ""),
        motivoController = TextEditingController(
            text: category != null ? category.data["motivo"] : ""),
        dataController = TextEditingController(
            text: category != null ? category.data["data"] : ""),
        _controllerTempo = TextEditingController(
            text: category != null ? category.data["tempo"] : ""),
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
            _categoryBloc.nomeHospedagem == _categoryBloc.category.data["nomeHospedagem"] &&
            _categoryBloc.pais == _categoryBloc.category.data["pais"] &&
            _categoryBloc.endereco == _categoryBloc.category.data["endereco"] &&
            _categoryBloc.data == _categoryBloc.category.data["data"] &&
            _categoryBloc.tempo == _categoryBloc.category.data["tempo"] &&
            _categoryBloc.motivo == _categoryBloc.category.data["motivo"] &&
            _categoryBloc.cidade == _categoryBloc.category.data["cidade"] &&
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
            _categoryBloc.title != _categoryBloc.category.data["pais"] ||
            _categoryBloc.title != _categoryBloc.category.data["nomeHospedagem"] ||
            _categoryBloc.title != _categoryBloc.category.data["endereco"] ||
            _categoryBloc.title != _categoryBloc.category.data["tempo"] ||
            _categoryBloc.title != _categoryBloc.category.data["motivo"]) {
          dataToUpdate["title"] = _categoryBloc.title;
          dataToUpdate["cidade"] = cidadeController.text;

          dataToUpdate["nomeHospedagem"] = nomeHospedagemController.text;
          dataToUpdate["pais"] = paisController.text;
          dataToUpdate["endereco"] = enderecoController.text;
          dataToUpdate["data"] = dataController.text;
          dataToUpdate["tempo"] = _controllerTempo.text;
          dataToUpdate["motivo"] = motivoController.text;
          dataToUpdate["icon"] =
              'https://firebasestorage.googleapis.com/v0/b/connect-my-health-24512.appspot.com/o/edit_viagem.png?alt=media&token=d4c2ecde-9e3c-446b-89f0-d8d5d605e1f6';
        }

        if (_categoryBloc.category == null) {
          await Firestore.instance
              .collection("accounts")
              .document(uid)
              .collection("hoteis")
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
              return Text(snapshot.hasData ? "Editar Hotel" : "Novo Hotel");
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
                                "Detalhes da Hospedagem",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Nome da Hospedagem ?                                            '),
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
                                      'Cidade de Hospedagem ?                                       '),
                                  TextFormField(
                                    controller: cidadeController,
                                    onChanged: _categoryBloc.setcidade,
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
                                    'País de Hospedagem ?                                       ',
                                  ),
                                  TextFormField(
                                    controller: paisController,
                                    onChanged: _categoryBloc.setpais,
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
                                      'Motivo da viagem ?                                       '),
                                  TextFormField(
                                    controller: motivoController,
                                    onChanged: _categoryBloc.setMotivo,
                                    validator: validateMotivo,
                                    decoration: InputDecoration(
                                        hintText: 'Lazer/Trabalho/Saúde',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Tempo de duração (em dias) ?                                       '),
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
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Data de Check-in                                                  '),
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
                                      dataController.text = date.toString().substring(0,10);
                                    },
                                    controller: dataController,
                                    decoration: InputDecoration(
                                      labelText: "Data de Check-in ",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Endereço da Hospedagem ?                                       '),
                                  TextFormField(
                                    controller: enderecoController,
                                    onChanged: _categoryBloc.setendereco,
                                    validator: validateAcomodacao,
                                    decoration: InputDecoration(
                                        hintText: 'Digite aqui..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                ],
                              )),
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

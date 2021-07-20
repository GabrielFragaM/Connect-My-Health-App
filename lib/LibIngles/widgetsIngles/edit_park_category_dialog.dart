import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:loja_virtual/LibIngles/blocsIngles/parkCategory_bloc.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/LibIngles/validatorsIngles/travel_validator.dart';
import 'package:flutter/cupertino.dart';



class EditParkCategoryDialog extends StatefulWidget {
  final DocumentSnapshot category;

  EditParkCategoryDialog({this.category});

  @override
  EditCategoryDialogState createState() =>
      EditCategoryDialogState(category: category);
}

class EditCategoryDialogState extends State<EditParkCategoryDialog>
    with TravelValidator {
  final CategoryBloc _categoryBloc;
  final _formKey = GlobalKey<FormState>();
  int _stepperCount = 0;

  String tipo_lazer = '';


  final TextEditingController _controller;
  final TextEditingController cidadeController;
  final TextEditingController paisController;
  final TextEditingController periodoController;
  final TextEditingController enderecoController;
  final TextEditingController dataController;
  bool conhece_vacinas = false;

  EditCategoryDialogState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        cidadeController = TextEditingController(
            text: category != null ? category.data["cidade"] : ""),
        paisController = TextEditingController(
            text: category != null ? category.data["pais"] : ""),
        periodoController = TextEditingController(
            text: category != null ? category.data["periodo"] : ""),
        enderecoController = TextEditingController(
            text: category != null ? category.data["endereco"] : ""),

        dataController = TextEditingController(
            text: category != null ? category.data["data"] : ""),
        _controller = TextEditingController(
            text: category != null ? category.data["title"] : "");

  @override
  Widget build(BuildContext context) {
    String uid = UserModel.of(context).firebaseUser.uid;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    Future getValues() async {
      DocumentSnapshot dr = await Firestore.instance
          .collection("accounts")
          .document(uid)
          .collection("parks")
          .document(_categoryBloc.title).get();
      setState(() {
        tipo_lazer = dr.data['tipo'];
      });
    }
    if (tipo_lazer == '') {
      getValues();
    }
    if (tipo_lazer != '') {

    }
    Future saveData() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        if (_categoryBloc.image == null &&
            _categoryBloc.category != null &&
            _categoryBloc.pais == _categoryBloc.category.data["pais"] &&
            _categoryBloc.endereco == _categoryBloc.category.data["endereco"] &&
            _categoryBloc.data == _categoryBloc.category.data["data"] &&
            _categoryBloc.periodo == _categoryBloc.category.data["periodo"] &&
            tipo_lazer.toString() == _categoryBloc.category.data["tipo"] &&
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
            _categoryBloc.title != _categoryBloc.category.data["tipo"] ||
            _categoryBloc.title != _categoryBloc.category.data["endereco"] ||
            _categoryBloc.title != _categoryBloc.category.data["periodo"]) {
          dataToUpdate["title"] = _categoryBloc.title;
          dataToUpdate["cidade"] = cidadeController.text;

          dataToUpdate["pais"] = paisController.text;
          dataToUpdate["endereco"] = enderecoController.text;
          dataToUpdate["data"] = dataController.text;
          dataToUpdate["periodo"] = periodoController.text;
          dataToUpdate["tipo"] = tipo_lazer.toString();
          dataToUpdate["icon"] =
              'https://firebasestorage.googleapis.com/v0/b/connect-my-health-24512.appspot.com/o/edit_viagem.png?alt=media&token=d4c2ecde-9e3c-446b-89f0-d8d5d605e1f6';
        }

        if (_categoryBloc.category == null) {
          await Firestore.instance
              .collection("accounts")
              .document(uid)
              .collection("parks")
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
              return Text(snapshot.hasData ? "Edit" : "New");
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
                                "Details",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Destination name ?                                            '),
                                  TextFormField(
                                    controller: _controller,
                                    onChanged: _categoryBloc.setTitle,
                                    validator: validateDestino,
                                    decoration: InputDecoration(
                                        hintText: 'Type here..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),

                                  Text(
                                      'Type of leisure ?                                                          '),
                                  Column(children: [
                                    RadioButton(
                                      description: "Show/Ballad/Party",
                                      value: "Show/Ballad/Party",
                                      groupValue: tipo_lazer,
                                      onChanged: (value) =>
                                          setState(
                                                () => tipo_lazer = value,
                                          ),
                                    ),
                                    RadioButton(
                                      description: "Movie theater",
                                      value: "Movie theater",
                                      groupValue: tipo_lazer,
                                      onChanged: (value) =>
                                          setState(
                                                () => tipo_lazer = value,
                                          ),
                                    ),
                                    RadioButton(
                                      description: "Amusement park",
                                      value: "Amusement park",
                                      groupValue: tipo_lazer,
                                      onChanged: (value) =>
                                          setState(
                                                () => tipo_lazer = value,
                                          ),
                                    ),
                                    RadioButton(
                                      description: "Museum",
                                      value: "Museum",
                                      groupValue: tipo_lazer,
                                      onChanged: (value) =>
                                          setState(
                                                () => tipo_lazer = value,
                                          ),
                                    ),
                                    RadioButton(
                                      description: "Bar/Restaurant",
                                      value: "Bar/Restaurant",
                                      groupValue: tipo_lazer,
                                      onChanged: (value) =>
                                          setState(
                                                () => tipo_lazer = value,
                                          ),
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 16,
                                  ),

                                  Text(
                                    'City ?                                                                              ',
                                  ),
                                  TextFormField(
                                    controller: cidadeController,
                                    onChanged: _categoryBloc.setcidade,
                                    validator: validateCompanhia,
                                    decoration: InputDecoration(
                                        hintText: 'Type here..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Country ?                                                                '),
                                  TextFormField(
                                    controller: paisController,
                                    onChanged: _categoryBloc.setpais,
                                    validator: validateMotivo,
                                    decoration: InputDecoration(
                                        hintText: 'Type here..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Address ?                                                           '),
                                  TextFormField(
                                    controller: enderecoController,
                                    onChanged: _categoryBloc.setendereco,
                                    validator: validateTempo,
                                    decoration: InputDecoration(
                                        hintText: 'Type here..',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Date                                                                 '),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: () async {
                                      var date =  await showDatePicker(
                                          context: context,
                                          locale : const Locale("en",""),
                                          initialDate:DateTime.now(),
                                          firstDate:DateTime(1900),
                                          lastDate: DateTime(2100)
                                      );
                                      dataController.text = date.toString().substring(0,10);
                                    },
                                    controller: dataController,
                                    decoration: InputDecoration(
                                      labelText: "Date",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                      'Start period ?                                               '),
                                  TextFormField(
                                    controller: periodoController,
                                    onChanged: _categoryBloc.setPeriodo,
                                    validator: validateAcomodacao,
                                    decoration: InputDecoration(
                                        hintText: 'Morning/Evening/Night',
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

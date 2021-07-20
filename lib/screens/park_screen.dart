import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/blocs/hotel_bloc.dart';
import 'package:loja_virtual/multiselects/multiselect_classes.dart';
import 'package:loja_virtual/validators/form_validator.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot form;

  FormScreen({this.categoryId, this.form});

  @override
  FormScreenState createState() => FormScreenState(categoryId, form);
}

class FormScreenState extends State<FormScreen> with FormValidator {
  int _stepperCount = 0;

  static List<Vacina> _vacinas = [
    Vacina(nome: "Febre Amarela"),
    Vacina(nome: "Rubéola"),
    Vacina(nome: "Tétano"),
    Vacina(nome: "Hepatite B"),
    Vacina(nome: "Tríplice viral"),
  ];
  static List<Doenca> _doencas = [
    Doenca(nome: "Diabete"),
    Doenca(nome: "Cancer"),
    Doenca(nome: "Bronquite"),
    Doenca(nome: "Alzheimer"),
    Doenca(nome: "Osteoporose"),
    Doenca(nome: "Pneumonia"),
    Doenca(nome: "Vitiligo"),
  ];

  static List<Doenca> _doencas2 = [
    Doenca(nome: "Covid"),
    Doenca(nome: "Febre Amarela"),
    Doenca(nome: "H1N1"),
    Doenca(nome: "Meningite"),
    Doenca(nome: "Sarampo"),
    Doenca(nome: "Rubéola"),
    Doenca(nome: "Caxumba"),
    Doenca(nome: "Catapora/Varicela"),
    Doenca(nome: "Coqueluche"),
  ];

  static List<Sintoma> _sintomas = [
    Sintoma(nome: "Febre"),
    Sintoma(nome: "Dor no corpo"),
    Sintoma(nome: "Enjoo"),
    Sintoma(nome: "Dor de cabeça"),
    Sintoma(nome: "Dor na nuca"),
    Sintoma(nome: "Dor no peito"),
    Sintoma(nome: "Formigamento"),
    Sintoma(nome: "Cãibra"),
    Sintoma(nome: "Coriza"),
    Sintoma(nome: "Vista turva/Tontura"),
    Sintoma(nome: "Desmaio"),
  ];


  final _itemsVacinas = _vacinas
      .map((vacina) => MultiSelectItem<Vacina>(vacina, vacina.nome))
      .toList();
  final _itemsDoencas = _doencas
      .map((doenca) => MultiSelectItem<Doenca>(doenca, doenca.nome))
      .toList();
  final _itemsDoencas2 = _doencas2
      .map((doenca2) => MultiSelectItem<Doenca>(doenca2, doenca2.nome))
      .toList();
  final _itemsSintomas = _sintomas
      .map((sintoma) => MultiSelectItem<Sintoma>(sintoma, sintoma.nome))
      .toList();

  //Chave do form
  final _formKey = GlobalKey<FormState>();

  //Valores do form
  final quantidadeFilhosController = TextEditingController();
  final quantidadeSemanasGestacaoController = TextEditingController();
  final conheceVacinasController = TextEditingController();
  final medicamentoController = TextEditingController();
  final vacinaAntesViagemController = TextEditingController();
  final anoDoencas2Controller = TextEditingController();
  final conheceTomouVacinasController = TextEditingController();

  String _tipoSanguineo = 'O+';
  String _perfil;
  var data_perfil;
  bool _gestante = false;
  bool conhece_vacinas = false;
  bool tomou_vacinas = false;

  List<Doenca> _doencasSelecionadas = [];
  List<Doenca> _doencasSelecionadas2 = [];
  List<Vacina> _vacinasSelecionadas = [];
  List<Sintoma> _sintomasSelecionados = [];

  final possuiDoencasController = TextEditingController();
  final outrasDoencas2Controller = TextEditingController();
  final outrasVacinasController = TextEditingController();
  final outrosSintomasController = TextEditingController();

  final FormBloc _formBloc;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FormScreenState(String categoryId, DocumentSnapshot form)
      : _formBloc = FormBloc(categoryId: categoryId, form: form);

  @override
  Widget build(BuildContext context) {
    String uid = UserModel.of(context).firebaseUser.uid;

    Future<bool> saveFormOficial() async {
      _formBloc.loadingController.add(true);

      String id_form = randomAlphaNumeric(16);

      _formBloc.unsavedData["id_form"] = id_form;

      try {
        if (_formBloc.form != null) {

          await _formBloc.form.reference.updateData(_formBloc.unsavedData);
        } else {
          DocumentReference dr = await Firestore.instance
              .collection("accounts")
              .document(uid)
              .collection("parks")
              .document(_formBloc.categoryId)
              .collection("forms")
              .add(Map.from(_formBloc.unsavedData)..remove("images"));

          await dr.updateData(_formBloc.unsavedData);
        }

        _formBloc.createdController.add(true);
        _formBloc.loadingController.add(false);

        var allForm = Map<String, dynamic>();

        DocumentSnapshot ds = (await Firestore.instance.collection('accounts').document(uid)
            .collection('perfis').document('user').collection('users').document(_perfil.split(' ')[0]).get());

        String name = ds.data['user'];
        String imagem_perfil = ds.data['imagem_perfil'][0];

        allForm["data_form"] = DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(DateTime.now());

        allForm["uid_category"] = _formBloc.categoryId.toString();
        allForm["form_destino"] = 'Park';
        allForm["id_form"] = id_form;

        allForm["perfil_id"] = _perfil.split(' ')[0];

        allForm["user"] = name.toString();
        allForm["uid_account"] = uid.toString();
        allForm["imagem_perfil"] = imagem_perfil.toString();
        DocumentSnapshot travel = (await Firestore.instance
            .collection('accounts')
            .document(uid)
            .collection('all_locais')
            .document(_formBloc.categoryId).get());
        DocumentSnapshot account = (await Firestore.instance
            .collection('accounts')
            .document(uid).get());
        allForm["email"] = ds.data['email'];
        allForm["telefone"] = ds.data['telefone'];
        allForm["idade"] = ds.data['data_nascimento'];
        allForm["cidade"] = ds.data['cidade'];
        allForm["pais"] = ds.data['paiz'];
        allForm["tempo_deviagem"] = '';
        allForm["checkin"] = travel.data['data'];
        allForm["name_company"] = account.data['name_company'];
        allForm["tipo_sangue"] = _tipoSanguineo.toString();
        allForm["gestante"] = _gestante ? "Sim" : "Não";

        if(quantidadeSemanasGestacaoController == ''){
          allForm["quantidade_gestacao"] = 'Não';
        }

        if(quantidadeFilhosController == ''){
          allForm["quantidadefilhos"] = 'Não';
        }

        allForm["quantidade_gestacao"] =
            quantidadeSemanasGestacaoController.text;
        allForm["quantidadefilhos"] =
            quantidadeFilhosController.text;
        allForm["medicamento"] = medicamentoController.text;
        allForm["vacinas_antes_viagem"] = vacinaAntesViagemController.text;

        List<String> listaVacinasTomadas = [];
        List<String> listaDoencas = [];
        List<String> listaDoencas2 = [];
        List<String> listaSintomas = [];
       List<String> listaSintomas2 = [];


      for (var vacina in _vacinasSelecionadas) {
          listaVacinasTomadas.add(vacina.nome);
        }
        print(listaVacinasTomadas);
        allForm["vacinas"] = listaVacinasTomadas;
        allForm["outras_vacinas"] = outrasVacinasController.text;


        if (listaVacinasTomadas.length == 0 && outrasVacinasController.text == ''){
          allForm["vacinas_pontos"] = 5;
        }

        if (listaVacinasTomadas.length == 0 && outrasVacinasController.text != ''){
          allForm["vacinas_pontos"] = 3;
        }

        if (listaVacinasTomadas.length != 0 && outrasVacinasController.text == ''){
          allForm["vacinas_pontos"] = 0;
        }

        if (listaVacinasTomadas.length != 0 && outrasVacinasController.text != ''){
          allForm["vacinas_pontos"] = 0;
        }


        allForm["conhece_vacinas_viagem"] = conhece_vacinas ? "Sim" : "Não";
        allForm["tomou_vacina_viagem"] = tomou_vacinas ? "Sim" : "Não";

        var pontos_conhece_vacinas = conhece_vacinas ? "Sim" : "Não";

        if(pontos_conhece_vacinas == 'Sim'){
          allForm["conhece_vacinas_pontos_viagem"] = 0;
        }
        if(pontos_conhece_vacinas == 'Não'){
          allForm["conhece_vacinas_pontos_viagem"] = 3;
        }

        allForm["conhece_vacinas_viagem_qual"] =
            conheceVacinasController.text;



        var pontos_tomou_vacinas = tomou_vacinas ? "Sim" : "Não";

        if(pontos_tomou_vacinas == 'Sim'){
          allForm["tomou_vacina_viagem_pontos"] = 0;
        }
        if(pontos_tomou_vacinas == 'Não'){
          allForm["tomou_vacina_viagem_pontos"] = 3;
        }

        allForm["tomou_vacinas_viagem_qual"] =
            conheceTomouVacinasController.text;


        for (var doenca in _doencasSelecionadas) {
          listaDoencas.add(doenca.nome);
        }

        allForm["possui_doencas"] = listaDoencas;
        allForm["possui_doencas_outra"] =
            possuiDoencasController.text;


        if ( listaDoencas.length == 0 && possuiDoencasController.text == ''){
          allForm["possui_doencas_pontos"] = 0;
          allForm["possui_doencas_verificar"] = 1;
        }

        if (listaDoencas.length != 0 && possuiDoencasController.text == ''){
          allForm["possui_doencas_pontos"] = 0;
          allForm["possui_doencas_verificar"] = 2;
        }

        if (listaDoencas.length != 0 && possuiDoencasController.text != ''){
          allForm["possui_doencas_pontos"] = 3;
          allForm["possui_doencas_verificar"] = 3;
        }


        for (var doenca2 in _doencasSelecionadas2) {
          listaDoencas2.add(doenca2.nome);
        }
        allForm["ja_teve_doencas"] = listaDoencas2;
        allForm["ja_teve_doencas_outras"] =
            outrasDoencas2Controller.text;

        if ( listaDoencas2.length == 0 && outrasDoencas2Controller.text == ''){
          allForm["ja_teve_doencas_pontos"] = 0;
          allForm["ja_teve_doencas_verificar"] = 1;
        }

        if (listaDoencas2.length != 0 && outrasDoencas2Controller.text == ''){
          allForm["ja_teve_doencas_pontos"] = 0;
          allForm["ja_teve_doencas_verificar"] = 2;
        }

        if (listaDoencas2.length != 0 && outrasDoencas2Controller.text != ''){
          allForm["ja_teve_doencas_pontos"] = 3;
          allForm["ja_teve_doencas_verificar"] = 3;
        }

        if (listaDoencas2.length == 0 && outrasDoencas2Controller.text != ''){
          allForm["ja_teve_doencas_pontos"] = 3;
          allForm["ja_teve_doencas_verificar"] = 4;
        }

        allForm["ano_teve_doencas"] = anoDoencas2Controller.text;



        for (var sintoma in _sintomasSelecionados) {
          listaSintomas.add(sintoma.nome);
        }


        if (listaSintomas.length == 1 && outrosSintomasController.text == '') {

          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);

              allForm["sintomas"] = listaSintomas2;

              allForm["pontos_sintomas"] =
                  listaSintomas.length * 3 - 3 + 5;
            }
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);

              allForm["sintomas"] = listaSintomas2;

              allForm["pontos_sintomas"] =
                  listaSintomas.length * 3;
            }
          }

        }

        if (listaSintomas.length == 0 && outrosSintomasController.text != '') {
          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }
            listaSintomas2.add(outrosSintomasController.text);
            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] =
                5 - 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }
            listaSintomas2.add(outrosSintomasController.text);
            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] =
            5;
          }
        }

        if (listaSintomas.length == 0 && outrosSintomasController.text == '') {

          for (var sintoma2 in _sintomasSelecionados) {
            listaSintomas2.add(sintoma2.nome);
          }
          listaSintomas2.add(outrosSintomasController.text);
          allForm["sintomas"] = listaSintomas2;

          allForm["pontos_sintomas"] =
          0;
        }

        if (listaSintomas.length == 1 && outrosSintomasController.text != '') {
          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] = listaSintomas2.length * 3- 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] = listaSintomas2.length * 3;
          }
        }

        if (listaSintomas.length > 1 && outrosSintomasController.text != '') {
          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] = listaSintomas2.length * 3- 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] = listaSintomas2.length * 3;
          }
        }

        if (listaSintomas.length > 1 && outrosSintomasController.text == '') {
          if (listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] = listaSintomas2.length * 3 - 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            allForm["sintomas"] = listaSintomas2;

            allForm["pontos_sintomas"] = listaSintomas2.length * 3;
          }
        }

        allForm["outros_sintomas"] =
            outrosSintomasController.text;

        if (outrosSintomasController.text != ''){
          allForm["outros_sintomas_pontos"] = 5;
        }
        if (outrosSintomasController.text == ''){
          allForm["outros_sintomas_pontos"] = 0;
        }

        await Firestore.instance
            .collection("allforms")
            .document(id_form).setData(allForm);

        await Firestore.instance
            .collection("accounts")
            .document(uid).collection('allformsuser')
            .document(id_form).setData(allForm);

        return true;
      } catch (e) {
        _formBloc.loadingController.add(false);
        return false;
      }
    }


    void saveForm() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        DocumentSnapshot ds = (await Firestore.instance.collection('accounts').document(uid)
            .collection('perfis').document('user').collection('users').document(_perfil.split(' ')[0]).get());

        String name = ds.data['user'];
        String imagem_perfil = ds.data['imagem_perfil'][0];

        _formBloc.unsavedData["uid_category"] = _formBloc.categoryId.toString();

        _formBloc.unsavedData["data_form"] = DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(DateTime.now());
        _formBloc.unsavedData["form_destino"] = 'Park';
        _formBloc.unsavedData["user"] = name.toString();
        _formBloc.unsavedData["uid_account"] = uid.toString();
        _formBloc.unsavedData["imagem_perfil"] = imagem_perfil.toString();
        _formBloc.unsavedData["perfil_id"] = _perfil.split(' ')[0];
        DocumentSnapshot travel = (await Firestore.instance
            .collection('accounts')
            .document(uid)
            .collection('all_locais')
            .document(_formBloc.categoryId).get());
        DocumentSnapshot account = (await Firestore.instance
            .collection('accounts')
            .document(uid).get());
        _formBloc.unsavedData["email"] = ds.data['email'];
        _formBloc.unsavedData["telefone"] = ds.data['telefone'];
        _formBloc.unsavedData["idade"] = ds.data['data_nascimento'];
        _formBloc.unsavedData["cidade"] = ds.data['cidade'];
        _formBloc.unsavedData["pais"] = ds.data['paiz'];
        _formBloc.unsavedData["checkin"] = travel.data['data'];
        _formBloc.unsavedData["tempo_deviagem"] = '';
        _formBloc.unsavedData["name_company"] = account.data['name_company'];
        _formBloc.unsavedData["tipo_sangue"] = _tipoSanguineo.toString();

        _formBloc.unsavedData["gestante"] = _gestante ? "Sim" : "Não";

        _formBloc.unsavedData["conhece_vacinas_viagem"] = conhece_vacinas ? "Sim" : "Não";
        _formBloc.unsavedData["tomou_vacina_viagem"] = tomou_vacinas ? "Sim" : "Não";

        var pontos_conhece_vacinas = conhece_vacinas ? "Sim" : "Não";

        if(pontos_conhece_vacinas == 'Sim'){
          _formBloc.unsavedData["conhece_vacinas_pontos_viagem"] = 0;
        }
        if(pontos_conhece_vacinas == 'Não'){
          _formBloc.unsavedData["conhece_vacinas_pontos_viagem"] = 3;
        }

        _formBloc.unsavedData["conhece_vacinas_viagem_qual"] =
            conheceVacinasController.text;


        var pontos_tomou_vacinas = tomou_vacinas ? "Sim" : "Não";

        if(pontos_tomou_vacinas == 'Sim'){
          _formBloc.unsavedData["tomou_vacina_viagem_pontos"] = 0;
        }
        if(pontos_tomou_vacinas == 'Não'){
          _formBloc.unsavedData["tomou_vacina_viagem_pontos"] = 3;
        }
        _formBloc.unsavedData["tomou_vacinas_viagem_qual"] =
            conheceTomouVacinasController.text;


        _formBloc.unsavedData["quantidade_gestacao"] =
            quantidadeSemanasGestacaoController.text;
        _formBloc.unsavedData["quantidadefilhos"] =
            quantidadeFilhosController.text;
        _formBloc.unsavedData["medicamento"] = medicamentoController.text;
        _formBloc.unsavedData["vacinas_antes_viagem"] = vacinaAntesViagemController.text;

        List<String> listaVacinasTomadas = [];
        List<String> listaDoencas = [];
        List<String> listaDoencas2 = [];
        List<String> listaSintomas = [];
        List<String> listaSintomas2 = [];

        for (var vacina in _vacinasSelecionadas) {
          listaVacinasTomadas.add(vacina.nome);
        }
        print(listaVacinasTomadas);
        _formBloc.unsavedData["vacinas"] = listaVacinasTomadas;
        _formBloc.unsavedData["outras_vacinas"] = outrasVacinasController.text;


        if (listaVacinasTomadas.length == 0 && outrasVacinasController.text == ''){
          _formBloc.unsavedData["vacinas_pontos"] = 5;
        }

        if (listaVacinasTomadas.length == 0 && outrasVacinasController.text != ''){
          _formBloc.unsavedData["vacinas_pontos"] = 3;
        }

        if (listaVacinasTomadas.length != 0 && outrasVacinasController.text == ''){
          _formBloc.unsavedData["vacinas_pontos"] = 0;
        }

        if (listaVacinasTomadas.length != 0 && outrasVacinasController.text != ''){
          _formBloc.unsavedData["vacinas_pontos"] = 0;
        }


        for (var doenca in _doencasSelecionadas) {
          listaDoencas.add(doenca.nome);
        }
        if (possuiDoencasController.text != ''){
          _formBloc.unsavedData["possui_doencas_outra"] = 3;
        }
        if (possuiDoencasController.text != ''){
          _formBloc.unsavedData["possui_doencas_outra"] = 0;
        }
        _formBloc.unsavedData["possui_doencas"] = listaDoencas;
        _formBloc.unsavedData["possui_doencas_outra"] =
            possuiDoencasController.text;

        if ( listaDoencas.length == 0 && possuiDoencasController.text == ''){
          _formBloc.unsavedData["possui_doencas_pontos"] = 0;
          _formBloc.unsavedData["possui_doencas_verificar"] = 1;
        }

        if (listaDoencas.length != 0 && possuiDoencasController.text == ''){
          _formBloc.unsavedData["possui_doencas_pontos"] = 0;
          _formBloc.unsavedData["possui_doencas_verificar"] = 2;
        }

        if (listaDoencas.length != 0 && possuiDoencasController.text != ''){
          _formBloc.unsavedData["possui_doencas_pontos"] = 3;
          _formBloc.unsavedData["possui_doencas_verificar"] = 3;
        }

        for (var doenca2 in _doencasSelecionadas2) {
          listaDoencas2.add(doenca2.nome);
        }
        _formBloc.unsavedData["ja_teve_doencas"] = listaDoencas2;
        _formBloc.unsavedData["ja_teve_doencas_outras"] =
            outrasDoencas2Controller.text;

        if ( listaDoencas2.length == 0 && outrasDoencas2Controller.text == ''){
          _formBloc.unsavedData["ja_teve_doencas_pontos"] = 0;
          _formBloc.unsavedData["ja_teve_doencas_verificar"] = 1;
        }

        if (listaDoencas2.length != 0 && outrasDoencas2Controller.text == ''){
          _formBloc.unsavedData["ja_teve_doencas_pontos"] = 0;
          _formBloc.unsavedData["ja_teve_doencas_verificar"] = 2;
        }

        if (listaDoencas2.length != 0 && outrasDoencas2Controller.text != ''){
          _formBloc.unsavedData["ja_teve_doencas_pontos"] = 3;
          _formBloc.unsavedData["ja_teve_doencas_verificar"] = 3;
        }

        if (listaDoencas2.length == 0 && outrasDoencas2Controller.text != ''){
          _formBloc.unsavedData["ja_teve_doencas_pontos"] = 3;
          _formBloc.unsavedData["ja_teve_doencas_verificar"] = 4;
        }



        _formBloc.unsavedData["ano_teve_doencas"] = anoDoencas2Controller.text;

        for (var sintoma in _sintomasSelecionados) {
          listaSintomas.add(sintoma.nome);
        }


        if (listaSintomas.length == 1 && outrosSintomasController.text == '') {

          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);

              _formBloc.unsavedData["sintomas"] = listaSintomas2;

              _formBloc.unsavedData["pontos_sintomas"] =
                  listaSintomas.length * 3 - 3 + 5;
            }
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);

              _formBloc.unsavedData["sintomas"] = listaSintomas2;

              _formBloc.unsavedData["pontos_sintomas"] =
                  listaSintomas.length * 3;
            }
          }

        }

        if (listaSintomas.length == 0 && outrosSintomasController.text != '') {
          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }
            listaSintomas2.add(outrosSintomasController.text);
            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] =
                5 - 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }
            listaSintomas2.add(outrosSintomasController.text);
            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] =
            5;
          }
        }

        if (listaSintomas.length == 0 && outrosSintomasController.text == '') {

          for (var sintoma2 in _sintomasSelecionados) {
            listaSintomas2.add(sintoma2.nome);
          }
          listaSintomas2.add(outrosSintomasController.text);
          _formBloc.unsavedData["sintomas"] = listaSintomas2;

          _formBloc.unsavedData["pontos_sintomas"] =
          0;
        }

        if (listaSintomas.length == 1 && outrosSintomasController.text != '') {
          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] = listaSintomas2.length * 3- 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] = listaSintomas2.length * 3;
          }
        }

        if (listaSintomas.length > 1 && outrosSintomasController.text != '') {
          if(listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] = listaSintomas2.length * 3- 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            listaSintomas2.add(outrosSintomasController.text);

            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] = listaSintomas2.length * 3;
          }
        }

        if (listaSintomas.length > 1 && outrosSintomasController.text == '') {
          if (listaSintomas.contains('Dor na nuca')) {
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] = listaSintomas2.length * 3 - 3 + 5;
          }else{
            for (var sintoma2 in _sintomasSelecionados) {
              listaSintomas2.add(sintoma2.nome);
            }

            _formBloc.unsavedData["sintomas"] = listaSintomas2;

            _formBloc.unsavedData["pontos_sintomas"] = listaSintomas2.length * 3;
          }
        }

        _formBloc.unsavedData["outros_sintomas"] =
            outrosSintomasController.text;

        if (outrosSintomasController.text != ''){
          _formBloc.unsavedData["outros_sintomas_pontos"] = 5;
        }
        if (outrosSintomasController.text == ''){
          _formBloc.unsavedData["outros_sintomas_pontos"] = 0;
        }

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Salvando Seu Formulário...",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.blue,
        ));

        print(possuiDoencasController);
        print(listaDoencas2);
        print(outrasDoencas2Controller);
        print(outrosSintomasController);

        bool success = await saveFormOficial();

        _scaffoldKey.currentState.removeCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            success ? "Formulário salvo!" : "Erro ao salvar o Formulário.\n Certifique que todos os dados estão preenchidos !",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ));
        Navigator.of(context).pop();
      }else{
        _scaffoldKey.currentState.removeCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
           "Você precisa estar com todos os dados preenchidos antes de enviar !",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
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
              return Text(
                  snapshot.data ? "Meu Formulário" : "Novo Formulário");
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
                          Text("Escolha de quem é este formulário"),
                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection('accounts')
                                  .document(uid)
                                  .collection('perfis')
                                  .document('user')
                                  .collection('users')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if(!snapshot.hasData) return Container();
                                else {
                                  List<DropdownMenuItem> data_perfil_id = [];
                                  for (int i = 0;
                                  i < snapshot.data.documents.length;
                                  i++) {
                                    DocumentSnapshot snap =
                                    snapshot.data.documents[i];
                                    data_perfil_id.add(
                                      DropdownMenuItem(
                                        child: Text(
                                          snap.data['user'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        value: "${snap.documentID} ${snap.data['user']}",
                                      ),
                                    );
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      DropdownButton(
                                        items: data_perfil_id,
                                        onChanged: (data_perfil) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                              'Perfil ${data_perfil.split(' ')[1]} selecionado !',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.blue,
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          setState(() {
                                            _perfil = data_perfil;
                                          });
                                        },
                                        value: _perfil,
                                        isExpanded: false,
                                        hint: new Text(
                                          "Escolha um perfil, ou crie um pefil \nantes de iniciar o formulário. ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                        ),
                        _createStepper(
                          1,
                          Text("Tipo Sanguíneo"),
                          Column(
                            children: [
                              RadioButton(
                                description: "O+",
                                value: "O+",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "O-",
                                value: "O-",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "A+",
                                value: "A+",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "A-",
                                value: "A-",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "B+",
                                value: "B+",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "B-",
                                value: "B-",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "AB+",
                                value: "AB+",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "AB-",
                                value: "AB-",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                              RadioButton(
                                description: "Não Sei",
                                value: "Não Sei",
                                groupValue: _tipoSanguineo,
                                onChanged: (value) => setState(
                                      () => _tipoSanguineo = value,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _createStepper(
                          2,
                          Text("Quantidade de filhos"),
                          TextFormField(
                            controller: quantidadeFilhosController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration:
                            InputDecoration(border: OutlineInputBorder()),
                          ),
                        ),
                        _createStepper(
                          3,
                          Text("É gestante?"),
                          Column(
                            children: [
                              RadioButton(
                                description: "Sim",
                                value: true,
                                groupValue: _gestante,
                                onChanged: (value) => setState(
                                      () => _gestante = value,
                                ),
                              ),
                              RadioButton(
                                description: "Não",
                                value: false,
                                groupValue: _gestante,
                                onChanged: (value) => setState(
                                      () => _gestante = value,
                                ),
                              ),
                              TextFormField(
                                controller: quantidadeSemanasGestacaoController,
                                keyboardType: TextInputType.number,
                                enabled: _gestante,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                    labelText: "Quantas semanas?"),
                              )
                            ],
                          ),
                        ),
                        _createStepper(
                          4,
                          Text('Você sabe quais são as vacinas\nnecessárias para o(s) destino(s) da sua viagem ?'),
                          Column(
                            children: [
                              RadioButton(
                                description: "Sim",
                                value: true,
                                groupValue: conhece_vacinas,
                                onChanged: (value) => setState(
                                      () => conhece_vacinas = value,
                                ),
                              ),
                              RadioButton(
                                description: "Não",
                                value: false,
                                groupValue: conhece_vacinas,
                                onChanged: (value) => setState(
                                      () => conhece_vacinas = value,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _createStepper(
                          5,
                          Text("Você possui alguma doença?"),
                          Column(
                            children: [
                              MultiSelectDialogField(
                                items: _itemsDoencas,
                                title: Text("Doenças"),
                                selectedColor: Colors.blue,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                buttonText: Text(
                                  "Clique Para Escolher",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 16,
                                  ),
                                ),
                                onConfirm: (results) {
                                  _doencasSelecionadas = results;
                                },
                              ),
                              TextFormField(
                                controller: possuiDoencasController,
                                decoration: InputDecoration(labelText: "Outro"),
                              ),
                            ],
                          ),
                        ),
                        _createStepper(
                          6,
                          Text("Faz uso de algum medicamento diário? Qual?"),
                          TextFormField(
                            validator: validateMedicamento,
                            controller: medicamentoController,
                            decoration:
                            InputDecoration(border: OutlineInputBorder()),
                          ),
                        ),
                        _createStepper(
                          7,
                          Text("Vacinas tomadas anteriormente"),
                          Column(
                            children: [
                              MultiSelectDialogField(
                                items: _itemsVacinas,
                                title: Text("Vacinas"),
                                selectedColor: Colors.blue,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                buttonText: Text(
                                  "Clique Para Escolher",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 16,
                                  ),
                                ),
                                onConfirm: (results) {
                                  _vacinasSelecionadas = results;
                                },
                              ),
                              TextFormField(
                                controller: outrasVacinasController,
                                decoration: InputDecoration(labelText: "Outro"),
                              ),
                            ],
                          ),
                        ),
                        _createStepper(
                          8,
                          Text("Tomou alguma vacina para esta viagem? Qual?"),
                          Column(children: [
                            RadioButton(
                              description: "Sim",
                              value: true,
                              groupValue: tomou_vacinas,
                              onChanged: (value) => setState(
                                    () => tomou_vacinas = value,
                              ),
                            ),
                            RadioButton(
                              description: "Não",
                              value: false,
                              groupValue: tomou_vacinas,
                              onChanged: (value) => setState(
                                    () => tomou_vacinas = value,
                              ),
                            ),
                            TextFormField(
                              controller: conheceTomouVacinasController,
                              enabled: tomou_vacinas,
                              decoration: InputDecoration(
                                  labelText: "Qual?"),
                            )
                          ],)
                        ),
                        _createStepper(
                          9,
                          Text("Já teve estas doenças?"),
                          Column(
                            children: [
                              MultiSelectDialogField(
                                items: _itemsDoencas2,
                                title: Text("Doenças"),
                                selectedColor: Colors.blue,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                buttonText: Text(
                                  "Clique Para Escolher",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 16,
                                  ),
                                ),
                                onConfirm: (results) {
                                  _doencasSelecionadas2 = results;
                                },
                              ),
                              TextFormField(
                                controller: outrasDoencas2Controller,
                                decoration: InputDecoration(labelText: "Outro"),
                              ),
                            ],
                          ),
                        ),
                        _createStepper(
                          10,
                          Text(
                              "Para caso afirmativo da pergunta anterior, em qual ano você teve a(s) doença(s)?"),
                          TextFormField(
                            controller: anoDoencas2Controller,
                            decoration:
                            InputDecoration(border: OutlineInputBorder()),
                          ),
                        ),
                        _createStepper(
                          11,
                          Text(
                              "Nos últimos 7 dias, apresentou algum destes sintomas?"),
                          Column(
                            children: [
                              MultiSelectDialogField(
                                items: _itemsSintomas,
                                title: Text("Vacinas"),
                                selectedColor: Colors.blue,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                buttonIcon: Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                buttonText: Text(
                                  "Clique Para Escolher",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 16,
                                  ),
                                ),
                                onConfirm: (results) {
                                  _sintomasSelecionados = results;
                                },
                              ),
                              TextFormField(
                                controller: outrosSintomasController,
                                decoration: InputDecoration(labelText: "Outro"),
                              ),
                            ],
                          ),
                        ),
                        _createStepper(
                          12,
                          Text("Tudo Pronto!"),
                          Column(
                            children: [
                              Text(
                                  "Já preencheu todo seu formulário? Certifique-se de que todos os campos obrigatórios estão preenchidos."),
                              ElevatedButton(
                                  onPressed: saveForm, child: Text("Enviar"))
                            ],
                          ),
                        ),
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

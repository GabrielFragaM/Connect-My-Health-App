import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfScreen {
  final String Question;
  final Aswer;

  final String QuestionTravel;
  final AswerTravel;

  final String QuestionPerfil;
  final AswerPerfil;




  const PdfScreen({this.Question, this.Aswer,this.QuestionTravel, this.AswerTravel,this.QuestionPerfil, this.AswerPerfil,});
}

class PdfApiViagem {
  static Future<File> generateTable(form) async {
    final pdf = Document();

    var id_form = form;

    final data = await Firestore.instance.collection('allforms').document(form).get();
    final dataTravel = await Firestore.instance.collection('accounts')
        .document(data['uid_account'])
        .collection('all_locais')
        .document(data['uid_category']).get();
    final dataPerfil = await Firestore.instance.collection('accounts')
        .document(data['uid_account'])
        .collection('perfis')
        .document('user')
        .collection('users')
        .document(data['perfil_id']).get();

    final headers = ['Formulário', 'Detalhes'];
    final headersTravel = ['Viagem', 'Detalhes'];
    final headersPerfil = ['Perfil', 'Detalhes'];

    var tipo_sanguineo = data['tipo_sangue'];
    var quantidade_filhos = '';
    var quantidade_gestacao = '';
    var possui_doencas = '';
    var tomou_vacinas_viagem_qual = '';
    var vacinas = '';
    var voce_sabe_vacinas = '';
    var ja_teve_doencas = '';
    var ano_teve_doencas = '';
    var sintomas = '';

    if (data['quantidadefilhos'] != ''){
      quantidade_filhos = data['quantidadefilhos'];
    }
    if (data['quantidadefilhos'] == ''){
      quantidade_filhos = 'Nenhum';
    }

    if (data['quantidade_gestacao'] != ''){
      quantidade_gestacao = data['quantidade_gestacao'];
    }
    if (data['quantidade_gestacao'] == ''){
      quantidade_gestacao = 'Sem Data';
    }

    if (data['possui_doencas_pontos'] == 0 &&
        data['possui_doencas_verificar'] ==
            1){
      possui_doencas = 'Nenhum';
    }
    if (data['possui_doencas_pontos'] == 0 &&
        data['possui_doencas_verificar'] ==
            2){
      possui_doencas = data['possui_doencas'].toString().replaceAll('[', '').replaceAll(']', '');
    }
    if (data['possui_doencas_pontos'] == 3 &&
        data['possui_doencas_verificar'] ==
            3){
      possui_doencas = "${data['possui_doencas'].toString().replaceAll('[', '').replaceAll(']', '')} ${data['possui_doencas_outra']}";
    }
    if (data['tomou_vacina_viagem_pontos'] ==
        3){
      tomou_vacinas_viagem_qual = 'Não';
    }
    if (data['tomou_vacina_viagem_pontos'] ==
        0){
      tomou_vacinas_viagem_qual = data['tomou_vacinas_viagem_qual'];
    }

    if (data['vacinas_pontos'] == 0){
      vacinas = "${data['vacinas'].toString().replaceAll('[', '').replaceAll(']', '')}, ${data['outras_vacinas']}";
    }
    if (data['vacinas_pontos'] == 3){
      vacinas = "${data['outras_vacinas']}";
    }
    if (data['vacinas_pontos'] == 5){
      vacinas = "Nenhuma";
    }

    if (data['conhece_vacinas_viagem'] ==
        'Sim'){
      voce_sabe_vacinas = "Sim";
    }
    if (data['conhece_vacinas_viagem'] ==
        'Não'){
      voce_sabe_vacinas = "Não";
    }

    if (data['ja_teve_doencas_pontos'] ==
        0 &&
        data['ja_teve_doencas_verificar'] ==
            1){
      ja_teve_doencas = "Nenhuma";
    }
    if (data['ja_teve_doencas_pontos'] ==
        0 &&
        data['ja_teve_doencas_verificar'] ==
            2){
      ja_teve_doencas = data['ja_teve_doencas'].toString().replaceAll('[', '').replaceAll(']', '');
    }
    if (data['ja_teve_doencas_pontos'] ==
        3 &&
        data['ja_teve_doencas_verificar'] ==
            3){
      ja_teve_doencas = "${data['ja_teve_doencas'].toString().replaceAll('[', '').replaceAll(']', '')}, ${data['ja_teve_doencas_outras']}";
    }
    if (data['ja_teve_doencas_pontos'] ==
        3 &&
        data['ja_teve_doencas_verificar'] ==
            4){
      ja_teve_doencas = "${data['ja_teve_doencas_outras']}";
    }
    if (data['ano_teve_doencas'] != ''){
      ano_teve_doencas = data['ano_teve_doencas'];
    }
    if (data['ano_teve_doencas'] == ''){
      ano_teve_doencas = "Sem Data";
    }

    if (data['pontos_sintomas'] == 0){
      sintomas = 'Nenhum';
    }
    if (data['pontos_sintomas'] != 0){
      sintomas = "${data['sintomas'].toString().replaceAll('[', '').replaceAll(']', '')}";
    }

    final users = [
      PdfScreen(Question:  'Tipo Sanguíneo:', Aswer: tipo_sanguineo),
      PdfScreen(Question: 'Quantidade de filhos:', Aswer: quantidade_filhos),
      PdfScreen(Question:  'È gestante ?', Aswer: quantidade_gestacao),
      PdfScreen(Question: 'Tempo de gestação:', Aswer: quantidade_gestacao),
      PdfScreen(Question:  'Possui alguma doença ?', Aswer: possui_doencas),
      PdfScreen(Question: 'Faz uso de algum medicamento diário ?', Aswer: data['medicamento']),
      PdfScreen(Question:  'Tomou alguma vacina para esta viagem:', Aswer: tomou_vacinas_viagem_qual),
      PdfScreen(Question: 'Vacinas tomadas anteriormento:', Aswer: vacinas),
      PdfScreen(Question:  'Você sabe quais são as vacinas para o destino:', Aswer: voce_sabe_vacinas),
      PdfScreen(Question: 'Já teve doenças ?', Aswer: ja_teve_doencas),
      PdfScreen(Question:  'Ano que tive essas doenças:', Aswer: ano_teve_doencas),
      PdfScreen(Question: 'Sintomas nos últimos 7 dias:', Aswer: sintomas),
    ];

    final travel = [
      PdfScreen(QuestionTravel:  'Destino:', AswerTravel: dataTravel['title']),
      PdfScreen(QuestionTravel: 'Origem:', AswerTravel: dataTravel['origem']),
      PdfScreen(QuestionTravel:  'Motivo da Viagem:', AswerTravel: dataTravel['motivo']),
      PdfScreen(QuestionTravel: 'Tempo de duração da viagem(em dias):', AswerTravel: dataTravel['tempo']),
      PdfScreen(QuestionTravel:  'Companhia Aérea:', AswerTravel: dataTravel['companhia']),
      PdfScreen(QuestionTravel: 'Data de embarque:', AswerTravel: dataTravel['data']),
      PdfScreen(QuestionTravel:  'Nome Hotel/Endereço Acomodação:', AswerTravel: dataTravel['nomeHotel']),
      PdfScreen(QuestionTravel: 'Outros locais(cidade) que vai visitar:', AswerTravel: dataTravel['locaisVisitar']),
    ];

    final perfil = [
      PdfScreen(QuestionPerfil:  'Nome Completo:', AswerPerfil: dataPerfil['user']),
      PdfScreen(QuestionPerfil: 'Email:', AswerPerfil: dataPerfil['email']),
      PdfScreen(QuestionPerfil:  'Telefone Para Contato:', AswerPerfil: dataPerfil['telefone']),
      PdfScreen(QuestionPerfil: 'Data de Nascimento:', AswerPerfil: dataPerfil['data_nascimento']),
      PdfScreen(QuestionPerfil:  'Idade:', AswerPerfil: dataPerfil['idade']),
      PdfScreen(QuestionPerfil: 'Nacionalidade:', AswerPerfil: dataPerfil['nacionalidade']),
      PdfScreen(QuestionPerfil:  'Estado Civil:', AswerPerfil: dataPerfil['estado_civil']),
      PdfScreen(QuestionPerfil: 'Tipo de Documento:', AswerPerfil: dataPerfil['tipo_documento']),
      PdfScreen(QuestionPerfil: 'Número do Documento:', AswerPerfil: dataPerfil['documento']),
    ];

    final body = users.map((user) => [user.Question, user.Aswer]).toList();

    final bodyViagem = travel.map((travels) => [travels.QuestionTravel, travels.AswerTravel]).toList();

    final bodyPerfil = perfil.map((perfils) => [perfils.QuestionPerfil, perfils.AswerPerfil]).toList();


    final imageJpg =
    (await rootBundle.load('assets/person.jpeg')).buffer.asUint8List();


    pdf.addPage(MultiPage(
        pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,

        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Página ${context.pageNumber} de ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
          Header(
              level: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Connect My Health Formulário', textScaleFactor: 2),
                    Image(
                      MemoryImage(imageJpg),
                      width: 150,
                      height: 40,
                    ),
                  ])),
          Header(level: 1, text: "Preenchido por ${data['user']} em ${data['data_form']}"),
          Padding(padding: const EdgeInsets.all(10)),
          Table.fromTextArray(
            headers: headers,
            data: body,
          ),
          Padding(padding: const EdgeInsets.all(100)),
          Table.fromTextArray(
            headers: headersTravel,
            data: bodyViagem,
          ),
          Padding(padding: const EdgeInsets.all(20)),
          Table.fromTextArray(
            headers: headersPerfil,
            data: bodyPerfil,
          ),
        ]));

    return saveDocument(name: 'Formulário_${data['user']}_${data['data_form']}.pdf', pdf: pdf);
  }

  static Future<File> generateImage() async {
    final pdf = Document();

    final imageSvg = await rootBundle.loadString('assets/fruit.svg');
    final imageJpg =
        (await rootBundle.load('assets/person.jpeg')).buffer.asUint8List();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (context.pageNumber == 1) {
          return FullPage(
            ignoreMargins: true,
            child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
          );
        } else {
          return Container();
        }
      },
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          Container(
            height: pageTheme.pageFormat.availableHeight - 1,
            child: Center(
              child: Text(
                'Foreground Text',
                style: TextStyle(color: PdfColors.white, fontSize: 48),
              ),
            ),
          ),
          SvgImage(svg: imageSvg),
          Image(MemoryImage(imageJpg)),
          Center(
            child: ClipRRect(
              horizontalRadius: 32,
              verticalRadius: 32,
              child: Image(
                MemoryImage(imageJpg),
                width: pageTheme.pageFormat.availableWidth / 2,
              ),
            ),
          ),
          GridView(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: [
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
            ],
          )
        ],
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

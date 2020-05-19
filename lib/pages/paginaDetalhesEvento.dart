import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/horario.dart';
import 'package:myflutterproject/models/medicamento.dart';
import 'package:myflutterproject/models/eventos.dart';
class Detalhes extends StatefulWidget {
  final int eventoID;
  Detalhes(this.eventoID);
  @override
  State<StatefulWidget> createState() {

    return _State(this.eventoID);
  }
}
class _State extends State<Detalhes> {
  DatabaseHelper helper = DatabaseHelper();

  Medicamento medicamento;
  Horario horario;
  int eventoID;
  List<Medicamento> medicamentoList;
  List<Horario> horarioList;
  List<Eventos> eventos;
  int contadorMedicamentoList = 0;
  int contadorHorarioList = 0;
  int contadoreventos=0;
  String Hora="";
  String Dia="";
  String nomeM="";
  String tipoM="";
  String imagemM=null;
  _State(this.eventoID);

  @override
  void initState() {
    // TODO: implement initState
    getEvento();
    super.initState();

    //inserirdadosmedicamento();
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    //stockController.text = medicamento.stock;
    return WillPopScope(
        onWillPop: () {moveToLastScreen();},
    child: Scaffold(
      appBar: AppBar(
        title: Text("Detalhes"),
        leading: IconButton(icon: Icon(
        Icons.arrow_back),
        onPressed: () {
        moveToLastScreen();
        },
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 150.0, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: imagemM == null ?
                    AssetImage('assets/medicamento.png'):
                    FileImage(File(imagemM))

                ),
              ),
            ),
            SizedBox(height: 10),
            Text("Dia: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(Dia,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text("Hora: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(Hora,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text("Nome do Medicamento: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(nomeM,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text("Tipo de Medicamento: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(tipoM,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
          ]
        )
      ),
    )
    );
}
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
  void getMedicamento(int id){
    Future<List<Medicamento>> EventoFuture = helper.getMedicamentoEvento2(id);
    EventoFuture.then((noteList) {
      setState(() {
        this.medicamentoList = noteList;
        this.contadorMedicamentoList = noteList.length;
        for(int i = 0 ; i< contadorMedicamentoList;i++)
          if(medicamentoList[i].id==id){
            nomeM=medicamentoList[i].nome;
            tipoM=medicamentoList[i].tipo;
            imagemM=medicamentoList[i].imagem;
          }
      });
    });
  }
  void getHorario(int id){
    Future<List<Horario>> EventoFuture = helper.getAllEventosHorario(id);
    EventoFuture.then((noteList) {
      setState(() {
        this.horarioList = noteList;
        this.contadorHorarioList = noteList.length;
        for(int i = 0 ; i< contadorHorarioList;i++)
          if(horarioList[i].id==id){
            Hora=horarioList[i].hora;
          }
      });
    });
  }
  void getEvento(){
    Future<List<Eventos>> EventoFuture = helper.getAllEventos();
    EventoFuture.then((noteList) {
      setState(() {
      this.eventos = noteList;
      this.contadoreventos = noteList.length;
      for(int i = 0 ; i< contadoreventos;i++)
      if(eventos[i].id==eventoID){
        getMedicamento(eventos[i].idM);
        getHorario(eventos[i].idH);
        Dia=eventos[i].data.day.toString()+"/"+eventos[i].data.month.toString()+"/"+eventos[i].data.year.toString();
      }
      });
    });
  }
  void _delete() async {
    DateTime a = DateTime.now();
    String b=DateTime(a.year,a.month,a.day).toIso8601String();
    int result = await helper.deleteEvento(horario.id,b);
    if (result != 0) {}
    moveToLastScreen();
  }
}

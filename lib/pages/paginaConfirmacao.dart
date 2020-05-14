import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/horario.dart';
import 'package:myflutterproject/models/medicamento.dart';
import 'package:myflutterproject/models/eventos.dart';
class Confirmacao extends StatefulWidget {
  final Horario horario;
  final Eventos evento;
  Confirmacao(this.horario,this.evento);
  @override
  State<StatefulWidget> createState() {

    return _State(this.horario,this.evento);
  }
}
class _State extends State<Confirmacao> {
  DatabaseHelper helper = DatabaseHelper();
  Medicamento medicamento;
  Horario horario;
  Eventos eventos;
  List<Medicamento> medicamentoList;
  int contador = 0;
  String nomeM="";
  String tipoM="";
  String userM="";
  bool o = false;
  _State(this.horario,this.eventos);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    inserirdadosmedicamento();
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    //stockController.text = medicamento.stock;
    return WillPopScope(
        onWillPop: () {moveToLastScreen();},
    child: Scaffold(
      appBar: AppBar(
        title: Text("Confirmação"),
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
        child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text ("Dia: ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(DateTime.now().day.toString()+"/"+DateTime.now().month.toString() +"/"+DateTime.now().year.toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text("Hora: ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(horario.hora,style: TextStyle(fontSize: 24),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text("Nome do Medicamento: ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(nomeM,style: TextStyle(fontSize: 24),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text("Tipo de Medicamento: ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(tipoM,style: TextStyle(fontSize: 24),textAlign: TextAlign.left),
            SizedBox(height: 10),
            o==true ? Text("Cuidador de: ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left):Container(),
            SizedBox(height: 10),
            o==true ? Text(userM,style: TextStyle(fontSize: 24),textAlign: TextAlign.left):Container(),
          ]
        )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.only(left: 18,right: 18),
          onPressed: (){
            _save();
          },
          child: Text(
            "Confirmar toma",
            style: TextStyle(fontSize: 18),),
        ),
      ),
    )
    );
}
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
  void inserirdadosmedicamento(){
    Future<List<Medicamento>> medicamentolistFuture = helper.getNoteList();
    medicamentolistFuture.then((noteList) {
      setState(() {
        this.medicamentoList = noteList;
        this.contador = noteList.length;
        for(int i = 0 ; i <contador ;i++){
          if(horario.idMedicamento==medicamentoList[i].id){
            nomeM=medicamentoList[i].nome;
            tipoM=medicamentoList[i].tipo;
            userM=medicamentoList[i].nomeUtilizador;
            if(userM==null){
              o=true;
            }
          }
        }
      });
    });
  }
  void _save() async {

    eventos.idH=horario.id;
    eventos.idM=horario.idMedicamento;
    DateTime a = DateTime.now();
    eventos.data= DateTime(a.year,a.month,a.day);
    int result;
    result = await helper.insertEvento(eventos);
    if(result!=0){

    }
    moveToLastScreen();
  }
}

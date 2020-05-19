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
  bool confirmado=false;
  String nomeM="";
  String tipoM="";
  String userM="";
  String imagemM=null;
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
            Text ("Dia: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(DateTime.now().day.toString()+"/"+DateTime.now().month.toString() +"/"+DateTime.now().year.toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Hora: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(horario.hora,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text("Nome do Medicamento: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(nomeM,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text("Tipo de Medicamento: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
            SizedBox(height: 10),
            Text(tipoM,style: TextStyle(fontSize: 20),textAlign: TextAlign.left),
            SizedBox(height: 10),
            o==true ? Text("Cuidador de: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left):Container(),
            SizedBox(height: 10),
            o==true ? Text(userM,style: TextStyle(fontSize: 20),textAlign: TextAlign.left):Container(),
            confirmado==true ? Text("Vocé ja registou esta toma!",style: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold)):Container(),
          ]
        )
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: confirmado==false?FlatButton(
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
        ):FlatButton(
          color: Colors.red.shade700,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.only(left: 18,right: 18),
          onPressed: (){
            _delete();
          },
          child: Text(
            "Eliminar toma atual",
            style: TextStyle(fontSize: 18),),
        ),
      ),
    )
    );
}
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
  void inserirdadosmedicamento()async{
    DateTime a = DateTime.now();
    String b=DateTime(a.year,a.month,a.day).toIso8601String();
    int l = await helper.getEventosComparacao(horario.id,b);
    if(l!=0){
      confirmado=true;
    }
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
            imagemM=medicamentoList[i].imagem;
            if(userM==null){
              o=true;
            }
        }
      }});
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
  void _delete() async {
    DateTime a = DateTime.now();
    String b=DateTime(a.year,a.month,a.day).toIso8601String();
    int result = await helper.deleteEvento(horario.id,b);
    if (result != 0) {}
    moveToLastScreen();
  }
}

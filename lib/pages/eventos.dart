import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/horario.dart';
import 'package:myflutterproject/models/medicamento.dart';


void main() => runApp(App());
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Eventos(),
    );
  }
}
class Eventos extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<Eventos> {
  DatabaseHelper helper = DatabaseHelper();
  Medicamento medicamento;
  Horario horario;
  List<Horario> horarioList;
  List<Medicamento> medicamentoList;
  int contadorlistahora = 0;
  int contadorlistamedicamento = 0;
  int count =0;
  int ultimo_id_medicamento;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdUltimoInserido();
    //insertlistmedicamento();
    insertlisthora();
    //insertlisthora(1);
  }
  void getIdUltimoInserido() async{
    ultimo_id_medicamento = await helper. getFutureID();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
        body: Column(
          children: <Widget>[
            Expanded(
            child:
            ListView.builder(
            itemCount: contadorlistahora,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int position) {
            return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title:RichText(
                text: TextSpan(
                  text: "${"Nome do medicamento"}\n",
                  style: Theme.of(context).textTheme.title.copyWith(fontSize: 16),
                  children: [
                    TextSpan(
                        text: "Grama",
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        children: []),
                  ],
                ),
              ),
              subtitle: Text("Antonio"),
              isThreeLine: true,
              trailing: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Faltam 4h\n",
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "${horarioList[position].hora}",
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
            );
            }
            )
            )
          ],
        )
    );
  }
  void  insertlistmedicamento(int id){
    Future<List<Medicamento>> horalistFuture = helper.getNoteList();
    horalistFuture.then((noteList) {
      setState(() {
        for(int i=0;i<contadorlistahora;i++){
          if(noteList[i].id==id){
            this.medicamentoList = noteList;
            this.contadorlistamedicamento = noteList.length;
          }
        }
      });
    });
  }
  void insertlisthora(){
    Future<List<Horario>> horalistFuture = helper.getHorarioList();
    horalistFuture.then((noteList) {
      setState(() {
        this.horarioList = noteList;
        this.contadorlistahora = noteList.length;
//        for(int i=0;i<contadorlistahora;i++){
//        insertlistmedicamento(horarioList[i].idMedicamento);
//        }
      });
    });
  }
}

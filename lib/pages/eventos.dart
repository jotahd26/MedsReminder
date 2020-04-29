import 'dart:async';
import 'dart:io';
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
  List NomeMedicamento;
  String o3;
  List<String> NomeMedicamentos=[];
  List<String> TipoMedicamentos=[];
  List<String> UserMedicamentos=[];
  Timer _timer;
  bool carregado=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    insertlisthora();
  }
  _State(){

    Timer(Duration(seconds: 3), () {
      setState(() {
        if(carregado==false)
        carregado=true;
      });

    });
  }


  void o(int p) async{
    for(int i=0;i<contadorlistahora;i++){
      if(p==horarioList[i].idMedicamento)
      o3 = await helper.str(horarioList[i].idMedicamento);
    }
  }
  @override
  Widget build(BuildContext context) {

      return
        Scaffold(
          appBar: AppBar(
            title: Text("Events"),
            centerTitle: true,
            backgroundColor: Colors.green.shade800,
          ),
          body: initScreen(context),
        );
  }
  initScreen(BuildContext context) {
    return Scaffold(
        body:
        Column(
          children: <Widget>[

            carregado ? Expanded(
                child:
                ListView.builder(

                    itemCount: contadorlistahora,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (BuildContext context, int position) {
                      return  Card(

                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(

                              title:RichText(
                                text: TextSpan(
                                  text: "${NomeMedicamentos[position]}\n",
                                  style: Theme.of(context).textTheme.title.copyWith(fontSize: 16),
                                  children: [
                                    TextSpan(
                                        text: "${TipoMedicamentos[position]}",
                                        style: Theme.of(context).textTheme.subtitle.copyWith(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                        children: []),
                                  ],
                                ),
                              ),
                              subtitle: Text("${UserMedicamentos[position]}"),
                              //isThreeLine: true,
                              trailing: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Remaining 4h\n",
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
            ): new Container(child: Text("A carregar dados..."),)
          ],
        )

    );
  }

void delay(){
  if(NomeMedicamento==null){
    new Future.delayed(const Duration(seconds: 4));
  }
  if(TipoMedicamentos==null){
    new Future.delayed(const Duration(seconds: 4));
  }
  if(UserMedicamentos==null){
    new Future.delayed(const Duration(seconds: 4));
  }
}
  void insertlistmedicamento(int id) async{

    Future<List<Medicamento>> horalistFuture = helper.getMedicamentoEvento2(id);
    horalistFuture.then((noteList) {
      setState(() {
        this.medicamentoList = noteList;
        this.contadorlistamedicamento = noteList.length;
        for(int i=0;i<contadorlistamedicamento;i++){
          if(noteList[i].id==id){
            NomeMedicamentos.add(medicamentoList[i].nome);
            TipoMedicamentos.add(medicamentoList[i].tipo);
            UserMedicamentos.add(medicamentoList[i].nomeUtilizador);
            //
          }
        }
      });
    });
  }
  void insertlisthora() async{
    Future<List<Horario>> horalistFuture = helper.getHorarioList();
    horalistFuture.then((noteList) {
      setState(() {
        this.horarioList = noteList;
        this.contadorlistahora = noteList.length;
        for(int i=0;i<contadorlistahora;i++){
          if(horarioList[i].idMedicamento!=null){
            insertlistmedicamento(horarioList[i].idMedicamento);
          }
        }
      });
    });
  }
}

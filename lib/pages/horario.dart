import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/horario.dart';
import 'package:myflutterproject/models/medicamento.dart';
import 'package:myflutterproject/models/eventos.dart';
import 'package:myflutterproject/pages/paginaConfirmacao.dart';


void main() => runApp(App());
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Horarios(),
    );
  }
}
class Horarios extends StatefulWidget {

  @override
  _State createState() => _State();
}
class _State extends State<Horarios> {
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
  List<String> ImagemMedicamentos=[];
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


  @override
  Widget build(BuildContext context) {

      return
        Scaffold(
          appBar: AppBar(
            title: Text("Horário"),
            centerTitle: true,
            backgroundColor: Colors.green.shade800,
          ),
          body: carregado ? Column(
            children: <Widget>[
              Expanded(
                  child:
                  ListView.builder(

                      itemCount: contadorlistahora,
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (BuildContext context, int position) {
                        return  Card(

                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: Container(
                                width: 60.0, height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: ImagemMedicamentos[position] == null ?
                                      AssetImage("assets/medicamento.png"):
                                      FileImage(File(ImagemMedicamentos[position]))
                                  ),
                                ),
                              ),
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
                              trailing: new Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Icon(Icons.alarm,color: Colors.blue),
                                  new Text(" "+horarioList[position].hora,
                                    style: Theme.of(context).textTheme.subtitle.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                navigateToDetail(this.horarioList[position],Eventos(0,0,DateTime(2000,0,0)));
                              },
                            )
                        );
                      }
                  )
              ),
            ],
          ):  Container(
            child: new Stack(
              children: <Widget>[
                new Container(
                  alignment: AlignmentDirectional.center,
                  decoration: new BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: new BorderRadius.circular(10.0)
                    ),
                    width: 300.0,
                    height: 200.0,
                    alignment: AlignmentDirectional.center,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                          child: new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: new CircularProgressIndicator(
                              value: null,
                              strokeWidth: 7.0,
                            ),
                          ),
                        ),
                        new Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: new Center(
                            child: new Text(
                              "A carregar dados...",
                              style: new TextStyle(
                                  fontSize: 23,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
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
            ImagemMedicamentos.add(medicamentoList[i].imagem);
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
          horarioList.sort((a, b) {
            return a.hora.toLowerCase().compareTo(b.hora.toLowerCase());
          });
          if(horarioList[i].idMedicamento!=null){
            insertlistmedicamento(horarioList[i].idMedicamento);
          }
        }
      });
    });
  }
  void navigateToDetail(Horario horario, Eventos evento) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Confirmacao(horario,evento);
    }));
    if (result == true) {
    }
  }
}

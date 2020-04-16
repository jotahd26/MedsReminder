import 'package:flutter/material.dart';
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/horario.dart';
import 'package:myflutterproject/models/medicamento.dart';
import 'package:sqflite/sqflite.dart';
import 'paginaMedicamento.dart';

void main() => runApp(App());
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Gestao(),
    );
  }
}
class Gestao extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<Gestao> {
DatabaseHelper databaseHelper = DatabaseHelper();
List<Medicamento> medicamentosList;
List<Horario> horarioList;
int count = 0;
bool check=false;
@override
void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (medicamentosList == null) {
      medicamentosList = List<Medicamento>();
      updateListView();
    }
    if(horarioList==null){
      horarioList = List<Horario>();
      //updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestão"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,

      ),
      body: Column(
          children:[
            FlatButton.icon(
              label: Text('Adicionar Medicamento'),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              icon: Icon(Icons.add),
              onPressed: () {
                navigateToDetail(Medicamento('', '','','','',1),Horario('',0), 'Adicionar Medicamento');
              },
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: count,
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (BuildContext context, int position) {
                    return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(this.medicamentosList[position].nome),
                        subtitle: Text(this.medicamentosList[position].tipo),
                        trailing: GestureDetector(
                          child: Icon(Icons.delete, color: Colors.grey,),
                          onTap: () {
                              _delete(context, medicamentosList[position]);
                              //_confirmaExclusao(context, medicamentosList[position]);
                          },
                        ),
                        onTap: () {
                          debugPrint("ListTile Tapped");
                          navigateToDetail(this.medicamentosList[position],this.horarioList[position],'Editar Medicamento');
                        },

                      ),
                    );
                  },
                )
            ),
          ]
      )
    );
  }

  void _delete(BuildContext context, Medicamento medicamento) async {
    int result = await databaseHelper.deleteMedicamento(medicamento.id);
    int result2= await databaseHelper.deleteHorarioMedicamento(medicamento.id);
      if (result != 0) {
        _showSnackBar(context, 'Medicamento '+medicamento.nome+' apagado com sucesso');
        updateListView();
    };
  }

void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message),duration: Duration(seconds: 1),);
    Scaffold.of(context).showSnackBar(snackBar);

  }
void updateListView() {

  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  dbFuture.then((database) {

    Future<List<Medicamento>> noteListFuture = databaseHelper.getNoteList();
    noteListFuture.then((noteList) {
      setState(() {
        this.medicamentosList = noteList;
        this.count = noteList.length;
      });
    });
    Future<List<Horario>> horarioListFuture = databaseHelper.getHorarioList();
    horarioListFuture.then((noteList) {
      setState(() {
        this.horarioList = noteList;
        //this.count2 = noteList.length;
      });
    });
  });
}
  void navigateToDetail(Medicamento medicamento,Horario horario, String titulopagina) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PaginaMedicamento(medicamento,horario, titulopagina);
    }));

    if (result == true) {
      updateListView();
    }
  }
}

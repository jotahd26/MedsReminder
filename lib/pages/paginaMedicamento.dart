import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/medicamento.dart';


class PaginaMedicamento extends StatefulWidget {
  final String appBarTitle;
  final Medicamento medicamento;
  PaginaMedicamento(this. medicamento, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return _State(this.medicamento, this.appBarTitle);
  }
}

class _State extends State<PaginaMedicamento> {
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Medicamento medicamento;

  TextEditingController nomeController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController frequenciaController = TextEditingController();
  _State(this.medicamento, this.appBarTitle);

  List<String> csv = new List();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  String newValue;
  String newValueFrequencia;
  String dropdownValue = 'Unidade';
  String dropdownValueFrequencia = 'Diariamente, x vezes ao dia';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicamento = Medicamento.fromMapObject(widget.medicamento.toMap());
    getDropDownItem();
    loadCSV();
  }
  List <String> tipoList= ["Ampolas", "Aplicações", "Capsulas", "Colher de cha", "Colher de sopa","Gota","Grama","Inalações","Injeção","Miligrama","Mililitro","Pedaço","Penso","Pilula","Spray","Supositório","UI","Unidade"];
  List <String> frequenciaList = ["Diariamente, x vezes ao dia", "Diariamente, a cada x horas","A cada X dias","Dias especificos da semana"];

  void getDropDownItem(){
    setState(() {
      if(medicamento.tipo!=null){
        newValue = medicamento.tipo;
        newValueFrequencia= medicamento.frequencia;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    nomeController.text = medicamento.nome;
    tipoController.text = medicamento.tipo;
    frequenciaController.text = medicamento.frequencia;
    return WillPopScope(
        onWillPop: () {moveToLastScreen();},
    child: Scaffold(
      appBar: AppBar(
        //_editaMedicamento.nome==''?"Novo Medicamento" :
        //        _editaMedicamento.nome
        title: Text(appBarTitle),
        leading: IconButton(icon: Icon(
        Icons.arrow_back),
        onPressed: () {
        // Write some code to control things, when user press back button in AppBar
        moveToLastScreen();
        }
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 10.0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('Nome do Medicamento:',style: TextStyle(fontSize: 18)),
                          csv.length == 0 ? Text("A carregar dados..."): SimpleAutoCompleteTextField(       //Nome do Medicamento
                            key: key,
                            controller: nomeController,
                            suggestions: csv,
                            onFocusChanged: (hasFocus) {
                              setState(() {
                                updateNome();
                              });
                            },
                            textChanged: (text){
                              updateNome();
                            },
                            decoration: InputDecoration(
                              enabledBorder: new UnderlineInputBorder(

                                borderSide: new BorderSide(color: Colors.green.shade800,width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(

                                borderSide: BorderSide(color: Colors.green.shade800),
                              ),
                              hintText: 'Introduzir o nome do medicamento',
                              hintStyle: TextStyle(color: Colors.black),
                              //icon: Icon(Icons.chevron_right,color: Colors.green.shade800),
                              isDense: true,
                            ),

                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 10.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Tipo de Medicamento:',style: TextStyle(fontSize: 18)),
                    new DropdownButton<String>(
                        hint: Text('Escolha'),
                        underline: Container(
                          height: 2,
                          color: Colors.green.shade800,
                        ),
                        value: newValue==""? dropdownValue : newValue,
                        items: tipoList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (valueSelected) {
                          setState(() {
                            dropdownValue = valueSelected;
                            if(newValue!=""){
                              newValue=valueSelected;
                            }
                            medicamento.tipo = valueSelected;
                            //updateTipo(valueSelectedByUser);
                          });
                        }
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 10.0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Text('Frequência:',style: TextStyle(fontSize: 18)),
                          new DropdownButton<String>(

                              hint: Text('Escolha'),
                              underline: Container(
                                height: 2,
                                color: Colors.green.shade800,
                              ),
                              value: newValueFrequencia==""? dropdownValueFrequencia : newValueFrequencia,
                              items: frequenciaList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (valueSelected) {
                                setState(() {
                                  dropdownValueFrequencia = valueSelected;
                                  if(newValueFrequencia!=""){
                                    newValueFrequencia=valueSelected;
                                  }
                                  medicamento.frequencia = valueSelected;
                                  //updateTipo(valueSelectedByUser);
                                });
                              }
                            //changedDropDownItem,
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //Texto -> Frequência
          ],
        ),

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
            "Guardar",
            style: TextStyle(fontSize: 18),),
        ),
      ),
    )
    );
  }
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }
  void loadCSV() {
    loadAsset('assets/lista.csv').then((String output) {

      setState(() {
        csv = output.split("\n");
      });

    });
  }
  void updateNome(){
    medicamento.nome = nomeController.text;
  }
  void _save() async {

    moveToLastScreen();
    int result;
    if (medicamento.id != null) {  // Case 1: Update operation
      result = await helper.updateMedicamento(medicamento);
    } else { // Case 2: Insert Operation
      result = await helper.insertMedicamento(medicamento);
    }

    if (result != 0) {  // Success
      //_showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      //_showAlertDialog('Status', 'Problem Saving Note');
    }

  }

}

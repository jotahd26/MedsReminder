import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/horario.dart';
import 'package:myflutterproject/models/medicamento.dart';


class PaginaMedicamento extends StatefulWidget {
  final String appBarTitle;
  final Medicamento medicamento;
  final Horario horario;

  PaginaMedicamento(this. medicamento,this.horario, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return _State(this.medicamento,this.horario, this.appBarTitle);
  }
}

class _State extends State<PaginaMedicamento> {
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Medicamento medicamento;
  Horario horario;
  List<Horario> horarioList;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController frequenciaController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController nomeUtilizadorController = TextEditingController();

  _State(this.medicamento,this.horario, this.appBarTitle);
  List<String> timeofday = [];
  static TimeOfDay t = TimeOfDay.now();
  List<String> csv = new List();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  String newValueTipoMedicamento;
  String newValueFrequencia;
  String dropdownValue;
  String dropdownValueFrequencia;
  double listhorasheight=0;
  int ultimo_id_medicamento;
  final _nomeFocus = FocusNode();
  bool editar=false;
  int contadorlistahora = 0;
  int o;
  bool ativado;
  String nomeestado;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdUltimoInserido();
    getIdhora();
    medicamento = Medicamento.fromMapObject(widget.medicamento.toMap());
    EditarMedicamento();
    loadCSV();
  }
  List <String> tipoList= ["Ampolas", "Aplicações", "Capsulas", "Colher de cha", "Colher de sopa","Gota","Grama","Inalações","Injeção","Miligrama","Mililitro","Pedaço","Penso","Pilula","Spray","Supositório","UI","Unidade"];
  List <String> frequenciaList = ["Diariamente, x vezes ao dia", "Diariamente, a cada x horas","A cada X dias","Dias especificos da semana"];
  void getIdUltimoInserido() async{
    ultimo_id_medicamento = await helper. getFutureID();
  }
  void getIdhora() async{
    o = await helper.getCountHorario();
  }

  void EditarMedicamento(){
    setState(() {
      if( appBarTitle=="Editar Medicamento"){
        if(medicamento.estado==1){
          nomeestado="Ativado";
          ativado=true;
        }else{
          nomeestado="Desativado";
          ativado=false;
        }
        editar=true;
        insertlisthora(medicamento.id);
        newValueTipoMedicamento = medicamento.tipo;
        newValueFrequencia= medicamento.frequencia;
        dropdownValue=tipoList.last;
        dropdownValueFrequencia=frequenciaList.first;

        updateTipo(dropdownValue);
        updateFrequencia(dropdownValueFrequencia);
        //Inicializar os valores quando edito
        nomeController.text = medicamento.nome;
        tipoController.text = medicamento.tipo;
        frequenciaController.text = medicamento.frequencia;
        stockController.text=medicamento.stock;
        nomeUtilizadorController.text = medicamento.nomeUtilizador;
      }
    });
  }
  bool visibilityTextAlert = false;
  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag"){
        visibilityTextAlert= visibility;
      }
    });
  }
  bool visibilityTextAlert2 = false;
  void _changed2(bool visibility, String field) {
    setState(() {
      if (field == "tag1"){
        visibilityTextAlert2= visibility;
      }
    });
  }
  int count=0;
  @override
  Widget build(BuildContext context) {

    //stockController.text = medicamento.stock;
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
        },
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            editar?Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 10.0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Ativar/Desativar medicamento",style: TextStyle(fontSize: 18)),
                          new RaisedButton(
                            child: new Text(nomeestado),
                            textColor: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            color: ativado ? Colors.green : Colors.red,
                            onPressed: () {
                              setState(() {
                                if(nomeestado=="Ativado")
                                {
                                  nomeestado="Desativado";
                                  medicamento.estado=0;
                                }
                                else{
                                  nomeestado="Ativado";
                                  medicamento.estado=1;
                                }
                                ativado = !ativado;

                              });
                            }
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ):Container(),
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
                            focusNode: _nomeFocus,
                            suggestions: csv,
                            onFocusChanged: (hasFocus) {
                              setState(() {
                                if(medicamento.nome!="")
                                {
                                  _changed(false, "tag");
                                }
                                updateNome();
                              });
                            },
                            textChanged: (text){
                              if(medicamento.nome!=""){
                                _changed(false, "tag");
                              }
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
                          visibilityTextAlert ? Text('Precisa de preencher o nome primeiro',style: TextStyle(color: Colors.red),) : new Container()
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
                        value: newValueTipoMedicamento==""? dropdownValue : newValueTipoMedicamento,
                        items: tipoList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (valueSelected) {
                          setState(() {
                            dropdownValue = valueSelected;
                            if(newValueTipoMedicamento!=""){
                              newValueTipoMedicamento=valueSelected;
                            }
                            updateTipo(valueSelected);
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
                                  updateFrequencia(valueSelected);
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
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.alarm),
                            color: Colors.blue,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.only(left: 18,right: 18),

                            onPressed: () async{
                              final time = await _selectTime(context);
                              if(time==null) return;
                              addItemToList(time);
                              //_savehorario();
                            },
                            label: Text('Adicionar Hora'),
                          ),
                        ],
                  ),
            ),
            visibilityTextAlert2 ? Text('Precisa de adicionar pelo menos uma hora',style: TextStyle(color: Colors.red),) : new Container(),
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
                height: listhorasheight,
                child: new ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: timeofday.length,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                      title: Text(timeofday[position]),
                  trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey,),
                  onTap: () {
                  apagarHoradalista(context,position);

                  //_confirmaExclusao(context, medicamentosList[position]);
                  },
                  ),
                      ),
                  );
                },
            )
        ),
          ),
        ]
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
                          new Text('Quantidade em stock:',style: TextStyle(fontSize: 18)),
                          TextFormField(
                            //key:keyStock,
                            controller: stockController,
                            keyboardType: TextInputType.number,
                            //inputFormatters: ,
                            decoration: InputDecoration(
                              enabledBorder: new UnderlineInputBorder(

                                borderSide: new BorderSide(color: Colors.green.shade800,width: 2),
                              ),
                            ),
                            onChanged: (valor){
                                medicamento.stock=valor;
                            },
                          )
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
                          new Text('Caso seja cuidador preencha com o nome da pessoa que cuida:',style: TextStyle(fontSize: 18)),
                          TextFormField(
                            controller: nomeUtilizadorController,
                            decoration: InputDecoration(
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.green.shade800,width: 2),
                              ),
                            ),
                            onChanged: (texto){
                              medicamento.nomeUtilizador=texto;
                            },
                          )
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
            if(medicamento.nome != "")
            {
              if(timeofday.length!=0){
                _save();
              }else{
                _changed2(true, "tag1");
              }
            }else{
              //_exibeAviso();
              _changed(true, "tag");
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          child: Text(
            "Guardar",
            style: TextStyle(fontSize: 18),),
        ),
      ),
    )
    );
}
  Future<TimeOfDay> _selectTime(BuildContext context) {
    return showTimePicker( context: context, initialTime: t,
    );
  }
  void addItemToList(TimeOfDay time){
    setState(() {
      //horario.hora = time.format(context);
      //horario.idMedicamento = 4;
      listhorasheight+=70;
      timeofday.insert(0,time.format(context));
    });
  }
  void addItemToListString(String time){
    setState(() {
      //horario.hora = time.format(context);
      //horario.idMedicamento = 4;
      listhorasheight+=70;
      timeofday.insert(0,time);
    });
  }
  void apagarHoradalista(BuildContext context,int position){
    setState(() {
      timeofday.removeAt(position);
      listhorasheight-=70;
    });
    updateHora();
  }
  void updateHora(){
    setState(() {
      this.timeofday.length = timeofday.length;
    });
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
  void updateFrequencia(String val) {
    medicamento.frequencia = val;
  }
  void updateTipo(String val) {
    medicamento.tipo = val;
  }
  void updateNome(){
    medicamento.nome = nomeController.text;
  }
  void updateStock(){
    medicamento.stock = stockController.text;
  }
  void _savehorario() async{
    int result;
      if(medicamento.id==null){
      //problema, se a tabela medicamentos não tiver valor, proximo id vai ser igual ao ultimo inserido, a tabela horario nao recebe
      for(int i=0; i<timeofday.length;i++){
          horario.hora=timeofday[i];
          if(ultimo_id_medicamento!=null){
            int p = ultimo_id_medicamento+1;
            horario.idMedicamento=p;
          }
          else{
            horario.idMedicamento=1;
          }

          //horario.idMedicamento = medicamento.id;
          result = await helper.insertHorario(horario);
        }
      }
    }
  void _save() async {

    int result;
    if (medicamento.id != null) {  // Case 1: Update operation
      result = await helper.updateMedicamento(medicamento);

//      if(horarioList!=null){
//        if(timeofday.length!=contadorlistahora){
//      for(int i=0;i<timeofday.length;i++){
//        bool p = horarioList[i].hora.contains(timeofday[i]);
//        if(p!=true){
//          getIdhora();
//          horario.id=o+1;
//          horario.hora=timeofday[i];
//          horario.idMedicamento=medicamento.id;
//          print((horario.id).toString() + ' ; ' + horario.hora+' ; ' + horario.idMedicamento.toString());
//          result = await helper.insertHorario(horario);
//        }
//      }
//    }
//  }

      for(int i = 0 ; i <timeofday.length;i++){
        result = await helper.updateHorario(horario,medicamento);
      }

    } else { // Case 2: Insert Operation
      //medicamento.id = getid+1;
      result = await helper.insertMedicamento(medicamento);

      if(result!=0){
        _savehorario();
      }
//      if(horario.idMedicamento!=null){
//        for(int i = 0 ; i <timeofday.length;i++){
//          result = await helper.updateHorario(horario,medicamento);
//        }
//
//      }
    }
    moveToLastScreen();
    }
    void insertlisthora(int id){
      Future<List<Horario>> horalistFuture = helper.getHorarioListEditar(id);
      horalistFuture.then((noteList) {
        setState(() {
          this.horarioList = noteList;
          this.contadorlistahora = noteList.length;
          for(int i = 0 ; i <contadorlistahora ;i++){
            print(horarioList[i].hora);
              addItemToListString(horarioList[i].hora);
            }
        });
      });
    }
}

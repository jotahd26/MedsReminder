import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart' show rootBundle;


class Addmedicamento extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Addmedicamento> {
  List<String> csv = new List();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

@override
void initState() {
  // TODO: implement initState
  super.initState();
  loadCSV();
  _dropDownMenuItems = getDropDownMenuItems();
  _currentTipoMedicammento = _dropDownMenuItems[17].value; //seleciona a Unidade da lista
}
  List TipoMedicamentos =
  ["Ampolas", "Aplicações", "Capsulas", "Colher de cha", "Colher de sopa","Gota","Grama","Inalações","Injeção","Miligrama","Mililitro","Pedaço","Penso","Pilula","Spray","Supositório","UI","Unidade"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentTipoMedicammento;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String tipoMedicammento in TipoMedicamentos) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: tipoMedicammento,
          child: new Text(tipoMedicammento)
      ));
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Medicamento"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
         children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16,right: 16),
            child: csv.length == 0 ? Text("A carregar dados..."):
             SimpleAutoCompleteTextField(
              key: key,
              suggestions: csv,
              decoration: InputDecoration(
                enabledBorder: new UnderlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green.shade800),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade800),
                ),
                labelText: 'Nome do medicamento',
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Introduzir o nome do medicamento',
                hintStyle: TextStyle(color: Colors.black),
                icon: Icon(Icons.chevron_right,color: Colors.green.shade800),

                isDense: true,
              ),
            ),
          ),
           SizedBox(height: 10),  //Espaço entre o Nome do Medicamento e o Tipo do medicamento
           new Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: <Widget>[

              Padding(
              padding: EdgeInsets.only(left: 16),
               child: Icon(
                 Icons.chevron_right,
                 color: Colors.green.shade800,
                 size: 20,
               ),
              ),
                  Padding(
                  padding: EdgeInsets.only(left: 14,right: 25),
                    child: new Text('Tipo de Medicamento',style: TextStyle(fontSize: 18)),
                  ),
              new DropdownButton(
                      underline: Container(
                        height: 2,
                        color: Colors.green.shade800,
                      ),
                     value: _currentTipoMedicammento,
                     items: _dropDownMenuItems,
                     onChanged: changedDropDownItem,
                   )
             ],
           ),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            onPressed: (){
            },
            child: Text(
              "Guardar",
            ),
          )
        ],
      ),
    );
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
  void changedDropDownItem(String selectedTipoMedicamento) {
    print("Selected city $selectedTipoMedicamento, we are going to refresh the UI");
    setState(() {
      _currentTipoMedicammento = selectedTipoMedicamento;
    });
  }

}

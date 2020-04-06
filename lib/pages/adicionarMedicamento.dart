import 'package:flutter/material.dart';

class Addmedicamento extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Addmedicamento> {
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
            padding: EdgeInsets.only(left: 16, top: 16),
            child: TextFormField(
              validator: (val) =>
              val.length > 3 ? null : 'Nome do medicamento não é valido',
              decoration: InputDecoration(
                labelText: 'Nome do medicamento',
                hintText: 'Introduzir o nome do medicamento',
                icon: Icon(Icons.person),
                isDense: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: TextFormField(
              validator: (val) =>
              val.length > 3 ? null : 'Tipo de medicamento não é valido',
              decoration: InputDecoration(
                labelText: 'Tipo de medicamento',
                hintText: 'Introduzir o tipo do medicamento',
                icon: Icon(Icons.person),
                isDense: true,
              ),
            ),
          ),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            onPressed: () {
              /*...*/
            },
            child: Text(
              "Guardar",
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'adicionarMedicamento.dart';

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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Gestão"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
        children: <Widget>[
            FlatButton.icon(
              label: Text('Adicionar Medicamento'),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              icon: Icon(Icons.add),
              onPressed: () {
                  Navigator.pushNamed(context, '/addMedicamento');
              },
            )
        ],
      ),
    );
  }
}

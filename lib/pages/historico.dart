import 'package:flutter/material.dart';


void main() => runApp(App());
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: Historico(),
    );
  }
}
class Historico extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<Historico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: Center(
        child: Text('Histórico',style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

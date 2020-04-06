import 'package:flutter/material.dart';


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
        body: Center(
          child: Text('Eventos',style: TextStyle(fontSize: 20)),
        ),
    );
  }
}

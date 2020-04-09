import 'package:flutter/material.dart';
import 'pages/gestao.dart';
import 'pages/historico.dart';
import 'pages/eventos.dart';
import 'assets/Icons/my_flutter_app_icons.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: Home(),
        debugShowCheckedModeBanner: false,

    );
  }
}
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}
class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    Eventos(),
    Historico(),
    Gestao()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade800,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(

            icon: Icon(MyFlutterApp.calendar),
            title:
            Text('Eventos',style: TextStyle(color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.calendar_check_o),
            title:  Text('Histórico',style: TextStyle(color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.heartbeat),
            title: Text('Gestão',style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }
}
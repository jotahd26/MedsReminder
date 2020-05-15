import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myflutterproject/helpers/databasehelper.dart';
import 'package:myflutterproject/models/eventos.dart';
import 'package:myflutterproject/models/horario.dart';
import 'package:myflutterproject/models/medicamento.dart';
import 'package:myflutterproject/pages/paginaDetalhesEvento.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';

void main() => runApp(App());
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historico',
      theme: ThemeData(
        primarySwatch: Colors.green,

      ),
      home: Historico(),
    );
  }
}
class Historico extends StatefulWidget {
  Historico({Key key, this.title}) : super(key: key);
  final String title;
  _HomePageState createState() => _HomePageState();
}
List<Eventos> _selectedEvents;
DateTime selectedDay;
Map<DateTime, List<Eventos>> _events;

class _HomePageState extends State<Historico> with TickerProviderStateMixin{
  List<String> NomeMedicamentos=[];
  List<String> HoraHorario=[];
  List<int> IdHorario=[];
  List<Horario> horarioList;
  List<Medicamento> medicamentoList;
  int contadorhorario=0;
  int contadormedicamento=0;
  int _counter = 0;
  int count = 0;
  CalendarController _calendarController;
  AnimationController _animationController;
  DatabaseHelper helper = DatabaseHelper();
  List<Eventos> eventList;
  DateTime selectedDay;
  bool carregado =false;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    //getAllEvent();
    final _selectedDay = DateTime.now();
    _selectedEvents = [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this
    );

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTask1().then((val) => setState(() {
        _events = val;
      }));
    });
    super.initState();
  }
  _HomePageState(){
    Timer(Duration(seconds: 0), () {
      setState(() {
        if(carregado==false)
          carregado=true;
      });
    });
  }
  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
  Future<Map<DateTime, List<Eventos>>> getTask1() async {
    Map<DateTime, List<Eventos>> mapFetch = {};
    List<Eventos> event = await helper.getAllEventos();
    for (int i = 0; i < event.length; i++) {
      var createTime = DateTime(event[i].data.year,
          event[i].data.month, event[i].data.day);
      var original = mapFetch[createTime];
      if (original == null) {
        print("null");
        mapFetch[createTime] = [event[i]];
      } else {
        print(event[i].data);
        mapFetch[createTime] = List.from(original)..addAll([event[i]]);
      }
    }

    return mapFetch;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
    );
  }
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      //holidays: _holidays,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.green.shade800),
        holidayStyle: TextStyle().copyWith(color: Colors.green.shade800),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.green.shade600),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
    );
  }
  Widget _buildEventList() {
    return carregado?ListView.builder(
        itemCount: _selectedEvents.length,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, int position) {
          return  Card(
              shape: Border.all(width: 0.2),
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: Text(NomeMedicamentos[position]),
                trailing: Text(HoraHorario[position]),
                onTap: () {
                  navigateToDetail(_selectedEvents[position].id);
                },
              )

          );
        }
    ): Container(
          child:Align(
          alignment: Alignment.topCenter,
          child: Row(
            children:[
              SizedBox(
                child: CircularProgressIndicator(),
                height: 10.0,
                width: 10.0,
              ),
              Text(" A carregar")
            ],
          ),
        )
        ) ;
  }
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            : Colors.green.shade400,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
  void insertlistmedicamento(int id) async{
    Future<List<Medicamento>> horalistFuture = helper.getMedicamentoEvento2(id);
    horalistFuture.then((noteList) {
      setState(() {
        this.medicamentoList = noteList;
        this.contadormedicamento = noteList.length;
        for(int i=0;i<contadormedicamento;i++){
          if(noteList[i].id==id){
            NomeMedicamentos.add(medicamentoList[i].nome);
            //
          }
        }
      });
    });
  }
  void insertlisthora(int id) async{
    Future<List<Horario>> horalistFuture = helper.getAllEventosHorario(id);
    horalistFuture.then((noteList) {
      setState(() {
        this.horarioList = noteList;
        this.contadorhorario = noteList.length;
        for(int i=0;i<contadorhorario;i++){
          if(noteList[i].id==id){
            HoraHorario.add(horarioList[i].hora);
            IdHorario.add(horarioList[i].id);
            //
          }
        }
      });
    });
  }
  void _onDaySelected(DateTime day, List<Eventos> events) {
    setState(() {
      NomeMedicamentos.clear();
      HoraHorario.clear();
      IdHorario.clear();
      for(int i=0;i<events.length;i++){
        insertlistmedicamento(events[i].idM);
        insertlisthora(events[i].idH);
      }
      carregado=false;
      Timer(Duration(seconds: 1), () {
        setState(() {
          if(carregado==false)
            carregado=true;
        });
      });
      _selectedEvents = events;
      selectedDay = DateTime(day.year, day.month, day.day);
    });
  }
  void navigateToDetail(int id) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Detalhes(id);
    }));
    if (result == true) {
    }
  }
}

class EventScreenDetail extends StatefulWidget {
  @override
  _EventScreenDetailState createState() => _EventScreenDetailState();
}

class _EventScreenDetailState extends State<EventScreenDetail> {
  @override
  Widget build(BuildContext context) {
    var eventList = _events[selectedDay];
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: eventList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(
                child: Text(
                    ' ${eventList[index].data}   ${eventList[index].data}')),
          );
        });
  }
}

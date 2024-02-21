import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendPage extends StatefulWidget {
  const AgendPage({super.key});

  @override
  State<AgendPage> createState() => _AgendPageState();
}

class _AgendPageState extends State<AgendPage> {
  List<String> vagasDoDia = [];

  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? _horarioSelecionado;
  String? _dataFormatada;

  final Map<DateTime, List<String>> _vagasPorDia = {};

  @override
  void initState() {
    super.initState();
    _focusDay = DateTime.now();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Agendar Dia'),
        ),
        
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 650,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  //locale: 'pt_BR',
                  focusedDay: _focusDay,
                  firstDay: DateTime.now(),
                  lastDay: DateTime(2024, 12, 31),
                  calendarFormat: _format,
                  currentDay: _currentDay,
                  rowHeight: 30,
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month'
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _format = format;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_currentDay, day);
                  },
                  onDaySelected: ((selectedDay, focusedDay) {
                    setState(() {
                      if (_vagasPorDia[selectedDay] == null) {
                        _vagasPorDia[selectedDay] = [];
                      }
                      _currentDay = selectedDay;
                      _focusDay = focusedDay;
                      _dateSelected = true;
                      if (selectedDay.weekday == 6 ||
                          selectedDay.weekday == 7) {
                        _isWeekend = true;
                        _timeSelected = false;
                        _currentIndex = null;
                      } else {
                        _isWeekend = false;
                        _horarioSelecionado = null;
                      }
                    });
                    /*obterHorariosDoDia(selectedDay).then((horarios) {
                      setState(() {
                        vagasDoDia = horarios;
                      });
                    });*/
                  }),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }





  
}

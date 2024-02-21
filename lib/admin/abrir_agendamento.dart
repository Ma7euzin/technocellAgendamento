import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class OpenAgend extends StatefulWidget {
  const OpenAgend({super.key});

  @override
  State<OpenAgend> createState() => _OpenAgendState();
}

class _OpenAgendState extends State<OpenAgend> {
  List<String> vagasDoDia = [];
  List<DateTime> _diasSelecionados = [];
  List<DateTime> _diasCadastrados = [];

  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? _horarioSelecionado;
  String? _dataFormatada;
  int _quantidadeVagas = 0;

  DateTime? _selectedStart;
  DateTime? _selectedEnd;

  final Map<DateTime, List<String>> _vagasPorDia = {};

  @override
  void initState() {
    super.initState();
    _focusDay = DateTime.now();
    loadRegisteredDates();
  }

  Future<void> salvarVagasNoFirebase(
      List<DateTime> diasSelecionados, int quantidadeVagas) async {
    final CollectionReference vagasCollection =
        FirebaseFirestore.instance.collection('vagas');

    for (DateTime diaSelecionado in diasSelecionados) {
      await vagasCollection.doc(diaSelecionado.toString()).set({
        'dia': diaSelecionado,
        'quantidadeVagas': quantidadeVagas,
        // Adicione outros campos relevantes aqui
      });
    }
  }

  void loadRegisteredDates() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('vagas').get();

      setState(() {
        _diasCadastrados =
            querySnapshot.docs.map((doc) => DateTime.parse(doc.id)).toList();
      });
    } catch (e) {
      print("Erro ao carregar datas cadastradas: $e");
    }
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
          child: Column(children: <Widget>[
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
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                onFormatChanged: (format) {
                  setState(() {
                    _format = format;
                  });
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_currentDay, day);
                },
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date, _) {
                    final isSelected = _diasSelecionados.contains(date);
                    final isAlreadyRegistered = _diasCadastrados.contains(date);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_diasSelecionados.contains(date)) {
                            _diasSelecionados.remove(date);
                          } else {
                            _diasSelecionados.add(date);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black
                              : (isAlreadyRegistered ? Colors.red : null),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isAlreadyRegistered
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  // Você pode adicionar qualquer lógica necessária aqui
                  setState(() {
                    if (_vagasPorDia[selectedDay] == null) {
                      _vagasPorDia[selectedDay] = [];
                    }
                    _currentDay = selectedDay;
                    _focusDay = focusedDay;
                    _dateSelected = true;
                    if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
                      _isWeekend = true;
                      _timeSelected = false;
                      _currentIndex = null;
                    } else {
                      _isWeekend = false;
                      _horarioSelecionado = null;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _quantidadeVagas = int.tryParse(value) ?? 0;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Quantidade de vagas",
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_diasSelecionados.isNotEmpty && _quantidadeVagas > 0) {
                    salvarVagasNoFirebase(_diasSelecionados, _quantidadeVagas);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Cor de fundo
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20), // Ajusta o tamanho do botão
                ),
                child: const Text(
                  'ABRIR AGENDA',
                  style: TextStyle(
                    color: Colors.white, // Cor do texto
                    fontWeight: FontWeight.bold, // Negrito
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

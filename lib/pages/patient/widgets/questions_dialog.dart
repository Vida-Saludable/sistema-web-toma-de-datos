import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomQuestionsDialog extends StatefulWidget {
  final String patientId;
  final String patientName;

  const CustomQuestionsDialog({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  _CustomQuestionsDialogState createState() => _CustomQuestionsDialogState();
}

class _CustomQuestionsDialogState extends State<CustomQuestionsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'Hábitos alimentarios',
    'Ingesta de agua',
    'Dominio propio',
    'Actividad física',
    'Sueño',
    'Rayos del sol',
    'Respirar aire puro',
    'Confianza en Dios'
  ];

  final List<List<Map<String, dynamic>>> _questions = [
    [
      {
        "question": "Me alimento 3 veces al día (desayuno, almuerzo y cena)",
        "value": 1
      },
      {
        "question": "Consumo 5 porciones de fruta y/o verduras diariamente",
        "value": 1
      },
      {
        "question":
            "Consumo al menos 3 porciones de proteínas al día (ejemplo: huevo, res, cerdo, pescado, pollo, etc.)",
        "value": 1
      },
      {
        "question":
            "Ingiero otros alimentos entre comidas (dulces, salados, frutas, otros)",
        "value": 1
      },
      {"question": "Consumo mis alimentos en horario", "value": 1},
      {
        "question":
            "Consumo más de 3 porciones de carbohidratos al día (pan, tortilla, cereales, galletas, etc.)",
        "value": 1
      },
      {"question": "Consumo mis alimentos hechos en casa cada día", "value": 1}
    ],
    [
      {"question": "Bebo solo agua pura cada día", "value": 1},
      {
        "question":
            "Bebo 8 vasos de agua pura al día (sin contar té, agua de frutas, refresco, café, jugo, etc.)",
        "value": 1
      },
      {
        "question":
            "Consumo más de 1 bebida con alto contenido de azúcar al día (chocolate, refrescos, jugos, etc.)",
        "value": 1
      },
      {"question": "Bebo agua al despertar", "value": 1},
      {"question": "Bebo agua antes de las comidas", "value": 1},
      {"question": "Bebo agua para dormir", "value": 1}
    ],
    [
      {"question": "Consumo alcohol", "value": 1},
      {
        "question": "Consumo bebidas alcohólicas más de 1 vez a la semana",
        "value": 1
      },
      {
        "question":
            "En fiestas tomo más de 2 bebidas con alcohol (como vasos de cerveza, cubas, bebidas preparadas)",
        "value": 1
      },
      {
        "question":
            "Consumo alguna sustancia estimulante (café, refrescos de cola, bebidas energéticas o medicamentos con cafeína) para tener más energía",
        "value": 1
      },
      {"question": "Consumo cigarrillos", "value": 1},
      {
        "question":
            "Consumo comida chatarra durante el día (frituras, pollo broaster, salchipapas, hamburguesa, galletas, pan dulce)",
        "value": 1
      },
      {
        "question": "Consumo entre comidas (dulce, salados, frutas, etc.)",
        "value": 1
      },
      {
        "question":
            "A pesar de sentirme satisfecho, pido que me sirvan más comida",
        "value": 1
      },
      {
        "question":
            "Agrego más AZÚCAR de la que ya tienen mis alimentos o bebidas",
        "value": 1
      },
      {
        "question": "Agrego más SAL de la que ya tienen mis alimentos",
        "value": 1
      }
    ],
    [
      {
        "question": "Realizo actividad deportiva para cuidar mi salud",
        "value": 1
      },
      {"question": "Hago actividad física diariamente", "value": 1},
      {
        "question":
            "Practico algún deporte en mi tiempo libre (natación, futbol, danza, vóley, etc.)",
        "value": 1
      },
      {"question": "Dedico 30 minutos a la actividad física", "value": 1},
      {
        "question":
            "Practico actividad física (Carrera, bicicleta, aeróbicos, caminata, etc.)",
        "value": 1
      }
    ],
    [
      {"question": "Suelo dormir menos de 7 horas diariamente", "value": 1},
      {"question": "Mi sueño es interrumpido", "value": 1},
      {
        "question": "Me cuesta recuperar el sueño después de la interrupción",
        "value": 1
      },
      {"question": "Duermo y despierto siempre a la misma hora", "value": 1},
      {"question": "Consumo alguna pastilla para dormir", "value": 1}
    ],
    [
      {"question": "Me expongo al sol cada día", "value": 1},
      {
        "question": "Tomo el sol por la mañana en cualquier horario",
        "value": 1
      },
      {"question": "Tomo el sol por la tarde en cualquier horario", "value": 1},
      {
        "question": "Tomo sol hasta las 9 am y después de las 16 pm cada día",
        "value": 1
      },
      {"question": "Tomo el sol más de 30 min al día", "value": 1}
    ],
    [
      {
        "question": "Realizo ejercicios respiratorios al aire libre",
        "value": 1
      },
      {
        "question":
            "Realizo ejercicios respiratorios al aire libre todos los días",
        "value": 1
      },
      {
        "question":
            "El tiempo que realizo los ejercicios respiratorios es de 30 minutos",
        "value": 1
      },
      {"question": "El horario que realizo es antes de las 09:00", "value": 1},
      {
        "question": "El horario que realizo es entre las 10:00 y 15:00",
        "value": 1
      },
      {
        "question": "El horario que realizo es entre las 16:00 y 19:00",
        "value": 1
      },
      {"question": "El horario que realizo es después de las 20:00", "value": 1}
    ],
    [
      {"question": "Conozco y creo en Dios", "value": 1},
      {"question": "Leo la biblia todos los días", "value": 1},
      {"question": "Leo la biblia interdiario", "value": 1},
      {"question": "Leo la biblia una vez a la semana", "value": 1},
      {"question": "Practico la oración diaria", "value": 1},
      {"question": "Practico la oración interdiario", "value": 1},
      {"question": "Practico la oración una vez a la semana", "value": 1},
      {
        "question":
            "Practico la oración solo cuando me acuerdo o cuando necesito",
        "value": 1
      },
      {"question": "Practico la oración antes de cada comida", "value": 1},
      {
        "question": "Desearía aprender de Dios, orar y estudiar la biblia",
        "value": 1
      }
    ]
  ];

  List<List<List<Map<String, dynamic>>>> _allResponses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _initializeResponses();
  }

  void _initializeResponses() {
    _allResponses = List.generate(
      _tabs.length,
      (tabIndex) => [
        List.generate(
          _questions[tabIndex].length,
          (questionIndex) => {
            'date': DateTime.now(),
            'value': -1,
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(child: _buildTabBarView()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.patientName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.indigo.shade100)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Colors.indigo,
        labelColor: Colors.indigo,
        unselectedLabelColor: Colors.indigo.shade300,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children:
          List.generate(_tabs.length, (index) => _buildQuestionnaireTab(index)),
    );
  }

  Widget _buildQuestionnaireTab(int tabIndex) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQuestionList(tabIndex),
                  const SizedBox(height: 16),
                  _buildSummaryTable(tabIndex),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _saveResponses(tabIndex),
            child: const Text('Guardar'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(int tabIndex) {
    return Column(
      children: List.generate(_questions[tabIndex].length, (questionIndex) {
        return _buildQuestionCard(tabIndex, questionIndex);
      }),
    );
  }

  Widget _buildQuestionCard(int tabIndex, int questionIndex) {
    Map<String, dynamic> question = _questions[tabIndex][questionIndex];
    // int currentValue = _allResponses[tabIndex].last[questionIndex]['value'];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRadioButton(tabIndex, questionIndex, 1, 'Nunca'),
                const SizedBox(width: 80),
                _buildRadioButton(
                    tabIndex, questionIndex, 2, 'Muy Pocas veces'),
                const SizedBox(width: 80),
                _buildRadioButton(tabIndex, questionIndex, 3, 'Algunas Veces'),
                const SizedBox(width: 80),
                _buildRadioButton(tabIndex, questionIndex, 4, 'Casi Siempre'),
                const SizedBox(width: 80),
                _buildRadioButton(tabIndex, questionIndex, 5, 'Siempre'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(
      int tabIndex, int questionIndex, int value, String label) {
    return Column(
      children: [
        Radio<int>(
          value: value,
          groupValue: _allResponses[tabIndex].last[questionIndex]['value'],
          onChanged: (newValue) {
            setState(() {
              _allResponses[tabIndex].last[questionIndex]['value'] = newValue;
              _allResponses[tabIndex].last[questionIndex]['date'] =
                  DateTime.now();
            });
          },
          activeColor: Colors.indigo,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSummaryTable(int tabIndex) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Respuestas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Pregunta')),
                  ..._allResponses[tabIndex].asMap().entries.map((entry) {
                    int responseIndex = entry.key;
                    return DataColumn(
                      label: Text('Respuesta ${responseIndex + 1}'),
                    );
                  }),
                ],
                rows: _questions[tabIndex].asMap().entries.map((entry) {
                  int questionIndex = entry.key;
                  Map<String, dynamic> question = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(question['question'])),
                      ..._allResponses[tabIndex].map((response) {
                        return DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_getResponseText(
                                  response[questionIndex]['value'])),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(response[questionIndex]['date']),
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getResponseText(int value) {
    switch (value) {
      case 1:
        return 'Nunca';
      case 2:
        return 'Muy Pocas veces';
      case 3:
        return 'Algunas Veces';
      case 4:
        return 'Casi Siempre';
      case 5:
        return 'Siempre';
      default:
        return 'Sin respuesta';
    }
  }

  void _saveResponses(int tabIndex) {
    print('Guardando respuestas para la pestaña: ${_tabs[tabIndex]}');
    setState(() {
      _allResponses[tabIndex].add(
        List.generate(
          _questions[tabIndex].length,
          (questionIndex) => {
            'date': DateTime.now(),
            'value': -1,
          },
        ),
      );
    });
  }
}

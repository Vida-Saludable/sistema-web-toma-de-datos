import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/air_controllers.dart';
import 'package:flutter_web_dashboard/controllers/exercise_controllers.dart';
import 'package:flutter_web_dashboard/controllers/feeding_controllers.dart';
import 'package:flutter_web_dashboard/controllers/hope_controllers.dart';
import 'package:flutter_web_dashboard/controllers/rest_controllers.dart';
import 'package:flutter_web_dashboard/controllers/sun_controllers.dart';
import 'package:flutter_web_dashboard/controllers/water_controllers.dart';
import 'package:flutter_web_dashboard/pages/reports/widgets/report_habit_table.dart';
import 'package:flutter_web_dashboard/pages/reports/widgets/top_report_habit_page.dart';
import 'package:flutter_web_dashboard/widgets/pagination_buttons.dart';
import 'package:get/get.dart';

class HabitReportsPage extends StatefulWidget {
  const HabitReportsPage({Key? key}) : super(key: key);

  @override
  _HabitReportsPageState createState() => _HabitReportsPageState();
}

class _HabitReportsPageState extends State<HabitReportsPage> {
  final AirController airController = Get.put(AirController());
  final WaterController waterController = Get.put(WaterController());
  final ExerciseController exerciseController = Get.put(ExerciseController());
  final SunController sunController = Get.put(SunController());
  final RestController restController = Get.put(RestController());
  final HopeController hopeController = Get.put(HopeController());
  final FeedingController feedingController = Get.put(FeedingController());
  String _tipoDeDato = 'agua'; // Valor inicial
  Map<String, List<Map<String, dynamic>>> _datosPorTipo =
      {}; // Mapa para los datos

  @override
  void initState() {
    super.initState();
    waterController.listarAguas(); // Llamar al método para listar aguas
    airController.listarAires();
    exerciseController.listarExercisees();
    sunController.listarSuns();
    restController.listarDescanso();
    hopeController.listarEsperanza();
    feedingController.listarAlimentacion();
    // Aquí puedes agregar más llamadas a otros métodos de controladores para cargar datos iniciales
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                "Reportes por hábitos",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            const SizedBox(height: 10),
            ResponsiveSearchFilterExport(),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  List<Map<String, dynamic>> datos;

                  if (_tipoDeDato == 'agua') {
                    datos = waterController.waters.map((water) {
                      return {
                        'usuario': water.usuario,
                        'fecha': water.fecha,
                        'hora': water.hora,
                        'cantidad': water.cantidad,
                        'telefono': water.telefono,
                      };
                    }).toList();
                  } else if (_tipoDeDato == 'aire') {
                    datos = airController.airs.map((air) {
                      return {
                        'usuario': air.usuario,
                        'fecha': air.fecha,
                        'tiempo': air.tiempo,
                        'telefono': air.telefono,
                      };
                    }).toList();
                  } else if (_tipoDeDato == 'alimentacion') {
                    datos = feedingController.feedings.map((feeding) {
                      return {
                        'usuario': feeding.usuario,
                        'fecha': feeding.fecha,
                        'desayuno_hora': feeding.desayuno_hora,
                        'almuerzo_hora': feeding.almuerzo_hora,
                        'cena_hora': feeding.cena_hora,
                        'desayuno': feeding.desayuno,
                        'almuerzo': feeding.almuerzo,
                        'cena': feeding.cena,
                        'desayuno_saludable': feeding.desayuno_saludable,
                        'almuerzo_saludable': feeding.almuerzo_saludable,
                        'cena_saludable': feeding.cena_saludable,
                        'telefono': feeding.telefono,
                      };
                    }).toList();
                  } else if (_tipoDeDato == 'ejercicio') {
                    datos = exerciseController.exercises.map((exercise) {
                      return {
                        'usuario': exercise.usuario,
                        'fecha': exercise.fecha,
                        'tiempo': exercise.tiempo,
                        'tipo': exercise.tipo,
                        'telefono': exercise.telefono,
                      };
                    }).toList();
                  } else if (_tipoDeDato == 'esperanza') {
                    datos = hopeController.hope.map((air) {
                      return {
                        'usuario': air.usuario,
                        'fecha': air.fecha,
                        'oracion': air.oracion,
                        'leer_biblia': air.leer_biblia,
                        'telefono': air.telefono,
                      };
                    }).toList();
                  } else if (_tipoDeDato == 'sol') {
                    datos = sunController.suns.map((sun) {
                      return {
                        'usuario': sun.usuario,
                        'fecha': sun.fecha,
                        'tiempo': sun.tiempo,
                        'telefono': sun.telefono,
                      };
                    }).toList();
                  } else if (_tipoDeDato == 'descanso') {
                    datos = restController.rest.map((rest) {
                      return {
                        'usuario': rest.usuario,
                        'fecha': rest.fecha,
                        'total_horas': rest.total_horas,
                        'total_minutos': rest.total_minutos,
                        'hora_dormir': rest.hora_dormir,
                        'hora_despertar': rest.hora_despertar,
                        'estado': rest.estado,
                        'telefono': rest.telefono,
                      };
                    }).toList();
                  } else {
                    // Aquí puedes manejar otros tipos de datos (alimentación, ejercicio, etc.)
                    datos = _datosPorTipo[_tipoDeDato] ?? [];
                  }

                  return ReportsHabitTable(
                    datos: datos,
                    tipoDeDato: _tipoDeDato,
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: PaginationButtons(
                  currentPage: 1,
                  totalPages: 5,
                  onPageChanged: (int newPage) {}),
            ),
          ],
        ),
      ),
    );
  }
}

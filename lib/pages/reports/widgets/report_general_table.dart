import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/report_general_controllers.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportsTable extends StatefulWidget {
  const ReportsTable({Key? key}) : super(key: key);

  @override
  State<ReportsTable> createState() => _ReportsTableState();
}

class _ReportsTableState extends State<ReportsTable> {
  final ReporteController reporteController = Get.put(ReporteController());

  @override
  void initState() {
    super.initState();
    reporteController.listarReportes(); // Llama al método para obtener los datos
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reporteController.reportes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final horizontalController = ScrollController();
      bool _isHovering = false;

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Scrollbar(
          thickness: 14.0,
          controller: horizontalController,
          radius: const Radius.circular(10.0),
          thumbVisibility: _isHovering,
          trackVisibility: _isHovering,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 8),
                  ...reporteController.reportes.map((report) => _buildRow(report.toJson())).toList(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: const Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          SizedBox(width: 80, child: Text('#', textAlign: TextAlign.center)),
          SizedBox(width: 100, child: Text('Fecha', textAlign: TextAlign.center)),
          SizedBox(width: 180, child: Text('Nombre Completo', textAlign: TextAlign.center)),
          SizedBox(width: 180, child: Text('Proyecto', textAlign: TextAlign.center)),
          SizedBox(width: 160, child: Text('Nutrición', textAlign: TextAlign.center)),
          SizedBox(width: 180, child: Text('Ejercicio', textAlign: TextAlign.center)),
          SizedBox(width: 180, child: Text('Agua', textAlign: TextAlign.center)),
          SizedBox(width: 180, child: Text('Luz Solar', textAlign: TextAlign.center)),
          SizedBox(width: 180, child: Text('Aire Puro', textAlign: TextAlign.center)),
          SizedBox(width: 120, child: Text('Descanso', textAlign: TextAlign.center)),
          SizedBox(width: 150, child: Text('Esperanza', textAlign: TextAlign.center)),
          SizedBox(width: 100, child: Text('Temperancia', textAlign: TextAlign.center)),
          SizedBox(width: 100, child: Text('Acciones', textAlign: TextAlign.center)),
        ],
      ),
    );
  }

Widget _buildRow(Map<String, dynamic> report) {
  double exerciseProgress = _calculateExerciseProgress(report['ejercicio']);
  double waterProgress = _calculateWaterProgress(report['agua']);
  double sunlightProgress = _calculateSunlightProgress(report['sol']);
  
  return Container(
    margin: const EdgeInsets.only(bottom: 3.0),
    padding: const EdgeInsets.symmetric(vertical: 3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
    ),
    child: Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: [
        SizedBox(width: 80, child: _buildCell(('1'), textAlign: TextAlign.center)),
        SizedBox(width: 100, child: _buildCell(report['fecha'], textAlign: TextAlign.center)),
        SizedBox(width: 180, child: _buildCell(report['usuario']['nombres_apellidos'], textAlign: TextAlign.center)),
        SizedBox(width: 180, child: _buildCell(report['proyectos'].isNotEmpty ? report['proyectos'][0] : 'Sin proyecto', textAlign: TextAlign.center),),

        // Celdas de alimentación con iconos
        SizedBox(width: 160, child: _buildNutritionCell(report['alimentacion'].isNotEmpty ? report['alimentacion'] : 'No hay registros')),
        
        // Celdas de progreso
        SizedBox(width: 180, child: _buildProgressCell(exerciseProgress, "Ejercicio", report['ejercicio'])),
        SizedBox(width: 180, child: _buildProgressCell(waterProgress, "Agua", report['agua'].isNotEmpty ? report['agua'] : 'No hay registros' )),
        SizedBox(width: 180, child: _buildProgressCell(sunlightProgress, "Luz Solar", report['sol'])),
        SizedBox(width: 180, child: _buildProgressCell(sunlightProgress, "Aire", report['aire'])),
        
        // Celdas restantes sin progreso
        // SizedBox(width: 100, child: _buildAirCell(report['aire'])),
        SizedBox(width: 120, child: _buildRestCell(report['descanso']),),
        SizedBox(width: 150, child: _buildReligiousCell(report)),
        SizedBox(width: 100, child: _buildChartCell(report)),
        SizedBox(width: 100, child: _buildActionsCell(report)),
      ],
    ),
  );
}

double _calculateExerciseProgress(List<dynamic> exercises) {
  double totalMinutes = exercises.fold(0, (sum, exercise) => sum + exercise['tiempo']);
  return totalMinutes / 45;
}

double _calculateWaterProgress(Map<String, dynamic> water) {
  return water['cantidad'] / 2000;
}

double _calculateSunlightProgress(Map<String, dynamic> sunlight) {
  return sunlight['tiempo'] / 45; 
}

double _calculateAirProgress(Map<String, dynamic> air) {
  return air['tiempo'] / 45;
}

double _calculateRestProgress(Map<String, dynamic> rest) {
  int totalMinutes = (rest['total_horas'] * 60) + rest['total_minutos'];
  return totalMinutes / 480;
}

Widget _buildProgressCell(double progress, String label, dynamic value) {
  return Container(
    margin: const EdgeInsets.only(top: 5.0),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, // Ensure horizontal centering
      children: [
        SizedBox(
          width: 180, // Width for consistency
          child: Container(
            height: 6.0, // Ajusta el grosor aquí
            child: LinearProgressIndicator(
              value: progress > 0 ? progress.clamp(0.0, 1.0) : 0.0,
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 180, // Match the width of the progress bar
          child: Text(
            _getProgressText(label, value),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

String _getProgressText(String label, dynamic value) {
  switch (label) {
    case "Ejercicio":
      return "${value.fold(0, (sum, exercise) => sum + exercise['tiempo'])} min. de 45 min. Recomendados";
    case "Agua":
      return "${value['cantidad']} ml. de 2000 ml. Recomendados";
    case "Luz Solar":
    case "Aire":
      return "${value['tiempo']} min. de 45 min. Recomendados";
    default:
      return "";
  }
}


  Widget _buildCell(String text, {TextAlign textAlign = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: textAlign),
    );
  }
Widget _buildNutritionCell(Map<String, dynamic> nutrition) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCheckCell(nutrition['desayuno'] > 0),
              const Text("D", textAlign: TextAlign.center), // Desayuno
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCheckCell(nutrition['almuerzo'] > 0),
              const Text("A", textAlign: TextAlign.center), // Almuerzo
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCheckCell(nutrition['cena'] > 0),
              const Text("C", textAlign: TextAlign.center), // Cena
            ],
          ),
        ],
      ),
    ],
  );
}

  Widget _buildExerciseCell(List<dynamic> exercises) {
    double totalMinutes = exercises.fold(0, (sum, exercise) => sum + exercise['tiempo']);
    return _buildCell("${totalMinutes} min");
  }

  Widget _buildWaterCell(Map<String, dynamic> water) {
    return _buildCell("${water['cantidad']} ml");
  }

  Widget _buildSunlightCell(Map<String, dynamic> sunlight) {
    return _buildCell("${sunlight['tiempo']} min");
  }

  Widget _buildAirCell(Map<String, dynamic> air) {
    return _buildCheckCell(air['tiempo'] > 0);
  }

Widget _buildRestCell(Map<String, dynamic> rest) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildCell("${rest['total_horas']}h ${rest['total_minutos']}m", textAlign: TextAlign.center),
    ],
  );
}


Widget _buildReligiousCell(Map<String, dynamic> report) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCheckCell(report['esperanza']?.any((p) => p['tipo_practica'] == "oracion") ?? false),
          const SizedBox(height: 5), // Espaciado entre el icono y el texto
          const Text("Oración", textAlign: TextAlign.center),
        ],
      ),
      const SizedBox(width: 20), // Espaciado entre las dos columnas
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCheckCell(report['esperanza']?.any((p) => p['tipo_practica'] == "lectura") ?? false),
          const SizedBox(height: 5), // Espaciado entre el icono y el texto
          const Text("Biblia", textAlign: TextAlign.center),
        ],
      ),
    ],
  );
}



Widget _buildActionsCell(Map<String, dynamic> report) {
  String phoneNumber = report['usuario']['telefono'];
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildWhatsAppButton(phoneNumber),
    ],
  );
}

Widget _buildChartCell(Map<String, dynamic> report) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildChartButton()
    ],
  );
}

Widget buildWhatsAppButton(String phoneNumber) {
  return Container(
    margin: const EdgeInsets.only(top: 10), // Mueve el botón hacia abajo
    child: OutlinedButton(
      onPressed: () async {
        final url = 'https://wa.me/$phoneNumber';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'No se pudo abrir $url';
        }
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.green), // Borde verde
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Borde redondeado
        ),
      ),
      child: const Icon(
        Icons.call,
        color: Colors.green,
        size: 24, // Mismo tamaño de ícono que el botón de gráfico
      ),
    ),
  );
}



Widget buildChartButton() {
  return Container(
    margin: const EdgeInsets.only(top: 10), 
    child: OutlinedButton(
      onPressed: () {

      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Icon(Icons.bar_chart_rounded),
    ),
  );
}


  Widget _buildCheckCell(bool fulfilled) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: Center(
        child: Icon(
          fulfilled ? Icons.check_circle : Icons.cancel,
          color: fulfilled ? Colors.green : Colors.red,
          size: 20,
        ),
      ),
    );
  }
}

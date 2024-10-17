import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ReportsHabitTable extends StatelessWidget {
  final List<Map<String, dynamic>> datos;
  final String tipoDeDato;

  const ReportsHabitTable({
    Key? key,
    required this.datos,
    required this.tipoDeDato,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 30),
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            ...datos.map((report) => _buildRow(report, context)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    List<Widget> headerItems = [
      _buildHeaderItem('Fecha'),
      _buildHeaderItem('Nombre Completo'),
    ];

    // Agregar columnas dinámicas basadas en el tipoDeDato
    if (tipoDeDato == 'agua') {
      headerItems.add(_buildHeaderItem('Hora'));
      headerItems.add(_buildHeaderItem('Cantidad de Agua (ml)'));
    } else if (tipoDeDato == 'aire') {
      headerItems.add(_buildHeaderItem('Tiempo de Aire (min)'));
    } else if (tipoDeDato == 'alimentacion') {
      headerItems.add(_buildHeaderItem('Hora Desayuno'));
      headerItems.add(_buildHeaderItem('Desayuno'));
      headerItems.add(_buildHeaderItem('Hora Almuerzo'));
      headerItems.add(_buildHeaderItem('Almuerzo'));
      headerItems.add(_buildHeaderItem('Hora cena'));
      headerItems.add(_buildHeaderItem('cena'));
      // headerItems.add(_buildHeaderItem('Saludable'));
    } else if (tipoDeDato == 'ejercicio') {
      headerItems.add(_buildHeaderItem('Tipo de Ejercicio'));
      headerItems.add(_buildHeaderItem('Tiempo de Ejercicio (min)'));
    } else if (tipoDeDato == 'esperanza') {
      headerItems.add(_buildHeaderItem('Oración'));
      headerItems.add(_buildHeaderItem('Lectura Bíblica'));
    } else if (tipoDeDato == 'sol') {
      headerItems.add(_buildHeaderItem('Tiempo de Sol (min)'));
    } else if (tipoDeDato == 'descanso') {
      headerItems.add(_buildHeaderItem('Hora de Dormir'));
      headerItems.add(_buildHeaderItem('Hora de Despertar'));
      headerItems.add(_buildHeaderItem('Total Horas'));
      headerItems.add(_buildHeaderItem('Decanso Bien'));
    }

    headerItems.add(_buildHeaderItem('Acción'));

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: headerItems,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildHeaderItem(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> report, BuildContext context) {
    List<Widget> rowItems = [
      _buildCell(report['fecha'] ?? ''),
      _buildCell(report['usuario'] ?? ''),
    ];

    // Agregar celdas dinámicas basadas en tipoDeDato
    if (tipoDeDato == 'agua') {
      rowItems.add(_buildCell(report['hora'] ?? ''));
      rowItems.add(_buildCell("${report['cantidad'] ?? '0'} ml"));
    } else if (tipoDeDato == 'aire') {
      rowItems.add(_buildCell("${report['tiempo'] ?? '0'} minutos"));
    } else if (tipoDeDato == 'alimentacion') {
      rowItems.add(_buildCell(report['desayuno_hora'] ?? ''));
      rowItems.add(_buildCheckCellFeeding(
        "Desayuno: ${report['desayuno'] ?? 0} Saludable: ${report['desayuno_saludable'] ?? 0}"
      ));
      rowItems.add(_buildCell(report['almuerzo_hora'] ?? ''));
      rowItems.add(_buildCheckCellFeeding(
        "Almuerzo: ${report['almuerzo'] ?? 0} Saludable: ${report['almuerzo_saludable'] ?? 0}"
      ));
      rowItems.add(_buildCell(report['cena_hora'] ?? ''));
      rowItems.add(_buildCheckCellFeeding(
        "Cena: ${report['cena'] ?? 0} Saludable: ${report['cena_saludable'] ?? 0}"
      ));
    } else if (tipoDeDato == 'ejercicio') {
      rowItems.add(_buildCell(report['tipo'] ?? ''));
      rowItems.add(_buildCell("${report['tiempo'] ?? '0'} minutos"));
    } else if (tipoDeDato == 'esperanza') {
      rowItems.add(_buildCheckCellHope(report['oracion']));
      rowItems.add(_buildCheckCellHope(report['leer_biblia']));
    } else if (tipoDeDato == 'sol') {
      rowItems.add(_buildCell("${report['tiempo'] ?? '0'} minutos"));
    } else if (tipoDeDato == 'descanso') {
      // rowItems.add(_buildCell(report['hora_dormir'] ?? ''));
      rowItems.add(_buildCell("Durmió a: ${report['hora_dormir'] ?? ''}"));
      rowItems.add(_buildCell("Despertó a: ${report['hora_despertar'] ?? ''}"));
      rowItems.add(_buildCell("${report['total_horas'] ?? '0'} hrs. ${report['total_minutos'] ?? '0'} min."));
      rowItems.add(_buildCheckCell(report['estado'] ?? 0));
    }

    rowItems.add(_buildActionsCell(context, report['telefono']?.toString() ?? ''));

    return Container(
      margin: const EdgeInsets.only(bottom: 3.0),
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Row(
        children: rowItems,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

Widget _buildCheckCellFeeding(String value) {
  // Extraemos los números de la cadena para cada comida
  final desayunoMatch = RegExp(r'Desayuno: (\d)').firstMatch(value);
  final saludableDesayunoMatch = RegExp(r'Saludable: (\d)').firstMatch(value);
  final almuerzoMatch = RegExp(r'Almuerzo: (\d)').firstMatch(value);
  final saludableAlmuerzoMatch = RegExp(r'Saludable: (\d)').firstMatch(value);
  final cenaMatch = RegExp(r'Cena: (\d)').firstMatch(value);
  final saludableCenaMatch = RegExp(r'Saludable: (\d)').firstMatch(value);

  List<Widget> iconAndTextWidgets = [];

  // Verificamos y añadimos desayuno
  if (desayunoMatch != null && saludableDesayunoMatch != null) {
    int desayuno = int.parse(desayunoMatch.group(1)!);
    int saludableDesayuno = int.parse(saludableDesayunoMatch.group(1)!);
    iconAndTextWidgets.add(_buildIconAndText(desayuno, saludableDesayuno, 'Desayuno'));
  }

  // Verificamos y añadimos almuerzo
  if (almuerzoMatch != null && saludableAlmuerzoMatch != null) {
    int almuerzo = int.parse(almuerzoMatch.group(1)!);
    int saludableAlmuerzo = int.parse(saludableAlmuerzoMatch.group(1)!);
    iconAndTextWidgets.add(_buildIconAndText(almuerzo, saludableAlmuerzo, 'Almuerzo'));
  }

  // Verificamos y añadimos cena
  if (cenaMatch != null && saludableCenaMatch != null) {
    int cena = int.parse(cenaMatch.group(1)!);
    int saludableCena = int.parse(saludableCenaMatch.group(1)!);
    iconAndTextWidgets.add(_buildIconAndText(cena, saludableCena, 'Cena'));
  }

  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: iconAndTextWidgets,
    ),
  );
}

Widget _buildIconAndText(int cantidad, int saludable, String abreviatura) {
  // Definir los íconos para cada caso
  IconData cantidadIcon = (cantidad == 1) ? Icons.check_circle : Icons.cancel;
  IconData saludableIcon = (saludable == 1) ? Icons.check_circle : Icons.cancel;

  // Colores correspondientes
  Color cantidadColor = (cantidad == 1) ? Colors.green : Colors.red;
  Color saludableColor = (saludable == 1) ? Colors.green : Colors.red;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Ícono y texto para la comida
      Column(
        children: [
          Icon(
            cantidadIcon,
            color: cantidadColor,
            size: 20,
          ),
          Text('$abreviatura', style: TextStyle(fontSize: 12)),
        ],
      ),
      SizedBox(width: 4,),
      // Ícono y texto para "Saludable"
      Column(
        children: [
          Icon(
            saludableIcon,
            color: saludableColor,
            size: 20,
          ),
          Text('Saludable', style: TextStyle(fontSize: 12)),
        ],
      ),
    ],
  );
}



Widget _buildCheckCellHope(dynamic value) {
  // Si el valor es un string no nulo y no vacío, marcamos como 'true' (fulfilled), caso contrario será 'false'.
  bool fulfilled = value != null && value is String && value.isNotEmpty;

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: Center(
        child: Icon(
          fulfilled ? Icons.check_circle : Icons.cancel,
          color: fulfilled ? Colors.green : Colors.red,
          size: 20,
        ),
      ),
    ),
  );
}


Widget _buildCheckCell(dynamic value) {
  // Convertimos el valor a booleano, si es 1 será true, si es 0 o cualquier otro valor será false
  bool fulfilled = value == 1;

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: Center(
        child: Icon(
          fulfilled ? Icons.check_circle : Icons.cancel,
          color: fulfilled ? Colors.green : Colors.red,
          size: 20,
        ),
      ),
    ),
  );
}


  Widget _buildActionsCell(BuildContext context, String phoneNumber) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildWhatsAppButton(phoneNumber),
        ],
      ),
    );
  }

  Widget buildWhatsAppButton(String phoneNumber) {
    return GestureDetector(
      onTap: () async {
        final url = 'https://wa.me/+591$phoneNumber';
        if (kIsWeb) {
          html.window.open(url, '_blank');
        } else {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'No se pudo abrir $url';
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(4),
        child: const Icon(
          Icons.call,
          color: Colors.green,
          size: 20,
        ),
      ),
    );
  }
}

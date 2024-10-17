import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/datos_fisicos_controller.dart';
import 'package:flutter_web_dashboard/controllers/datos_personales_controllers.dart';
import 'package:flutter_web_dashboard/controllers/signos_vitales_controller.dart';
import 'package:flutter_web_dashboard/controllers/test_ruffier_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/datos_muestras_controller.dart';

class CustomAnalysisDialog extends StatefulWidget {

  final String patientId;
  final String patientName;

  const CustomAnalysisDialog({
    Key? key,
    required this.patientId, // Asegúrate de que este parámetro es requerido
    required this.patientName,
  }) : super(key: key);

  @override
  _CustomAnalysisDialogState createState() => _CustomAnalysisDialogState();
  
}

class _CustomAnalysisDialogState extends State<CustomAnalysisDialog> with SingleTickerProviderStateMixin {

  final DatosPersonalesController _controller = Get.put(DatosPersonalesController());
  final DatosFisicosController _controllerDF = Get.put(DatosFisicosController());
  final DatosMuestrasController _controllerDM = Get.put(DatosMuestrasController()); 
  final SignosVitalesController _controllerSV = Get.put(SignosVitalesController()); 
  final TestRuffierController _controllerTR = Get.put(TestRuffierController()); 

  late TabController _tabController;

  String _gender = 'Masculino';
  DateTime _birthDate = DateTime.now();
  int _age = 0;

@override
void initState() {
  super.initState();
  _controller.edadController.text = _age.toString();
  _controller.fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(_birthDate);

  // Inicializa el TabController
  _tabController = TabController(length: 5, vsync: this);
  _controller.clearDatosPersodatos();
  _controller.listarDatosPersonales(widget.patientId);
  _tabController.addListener(() {
    if (_tabController.index == 1) {
      _controllerDF.clearDatosFisicos(); // Limpia los datos físicos antes de cargar
      _controllerDF.listarDatosFisicos(widget.patientId);
    } else if (_tabController.index == 2) {
      _controllerSV.clearSignosVitales(); // Limpia los signos vitales antes de cargar
      _controllerSV.listarSignosVitales(widget.patientId);
    } else if (_tabController.index == 3) {
      _controllerDM.clearDatosMuestras(); // Limpia las muestras antes de cargar
      _controllerDM.listarDatosMuestras(widget.patientId);
    } else if (_tabController.index == 4) {
      _controllerTR.clearTestRuffier(); // Limpia los tests antes de cargar
      _controllerTR.listarTestRuffier(widget.patientId);
    }
  });
}

    @override
  void dispose() {
    _tabController.dispose(); // Limpia el TabController
    super.dispose();
  }


  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _controller.fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(_birthDate);
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    final now = DateTime.now();
    final age = now.year -
        _birthDate.year -
        ((now.month < _birthDate.month ||
                (now.month == _birthDate.month && now.day < _birthDate.day))
            ? 1
            : 0);
    setState(() {
      _age = age;
      _controller.edadController.text = _age.toString();
    });
  }

void _calculateImc(String value) {
  final peso = double.tryParse(_controllerDF.pesoController.text);
  final altura = double.tryParse(_controllerDF.alturaController.text);

  // Verificar que el peso y la altura sean válidos y positivos
  if (peso != null && altura != null && peso > 0 && altura > 0) {
    // Convertir la altura de centímetros a metros
    final alturaInMeters = altura / 100;
    
    // Calcular el IMC
    final imc = peso / (alturaInMeters * alturaInMeters);
    
    // Asignar el resultado al controlador de IMC con dos decimales
    _controllerDF.imcController.text = imc.toStringAsFixed(2);
  } else {
    // Manejar el caso de valores no válidos
    _controllerDF.imcController.text = 'Ingrese valores válidos';
  }
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 700,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.patientName,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.indigo,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.indigo,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Datos Personales'),
                      Tab(text: 'Datos Físicos'),
                      Tab(text: 'Signos Vitales'),
                      Tab(text: 'Muestras'),
                      Tab(text: 'Test de Ruffer'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPersonalDataTab(),
                        _buildPhysicalDataTab(),
                        _buildVitalSignsTab(),
                        _buildSamplesTab(),
                        _buildRufferTestTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPersonalDataTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Nombre completo',
                              controller: _controller.nombresApellidosController,
                              placeholder: 'Ej. Juan Merlos')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Estado civil',
                              controller: _controller.estadoCivilController,
                              placeholder: 'Ej. Soltero')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Telefono',
                              controller: _controller.telefonoController,
                              placeholder: 'Ej. 7121XXXXX')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Grado de instrucion ',
                              controller: _controller.gradoInstruccionController,
                              placeholder: 'Ej. XXXXXXXX')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Procedencia',
                              controller: _controller.procedenciaController,
                              placeholder: 'Ej. XXXXXX')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Religion',
                              controller: _controller.religionController,
                              placeholder: 'Ej. Catolica')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDatePickerField(
                              'Fecha de Nacimiento', _controller.fechaNacimientoController)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Edad',
                              controller: _controller.edadController,
                              enabled: false,
                              placeholder: 'Ej. 25')),
                      Expanded(child: _buildGenderCheckbox('Masculino')),
                      Expanded(child: _buildGenderCheckbox('Femenino')),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _controller.createDatosPersonales(widget.patientId);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_controller.datosPersonales.isEmpty) {
                      return const Text('No hay registros disponibles.');
                    }
                    return _buildHistoryTable(
                      [
                        'Fecha',
                        'Nombre completo',
                        'Estado civil',
                        'Fecha de Nacimiento',
                        'Edad',
                        'Telefono',
                        'Grado instruccion',
                        'Procedencia',
                        'Religion',
                        'Sexo',
                      ],
                      _controller.datosPersonales.map((test) {
                        String formattedDate = test.fecha != null 
                          ? DateFormat('dd/MM/yyyy').format(test.fecha!) 
                          : 'Fecha no disponible'; // Valor por defecto si es null
                        String formattedDateFN = test.fecha_nacimiento != null 
                          ? DateFormat('dd/MM/yyyy').format(test.fecha_nacimiento!) 
                          : 'Fecha no disponible'; // Valor por defecto si es null
                        
                        String sexoFormateado = test.sexo == 'M' ? 'Masculino' : (test.sexo == 'F' ? 'Femenino' : 'No especificado');

                        return [
                          formattedDate,
                          test.nombres_apellidos.toString(),
                          test.estado_civil.toString(),
                          formattedDateFN,
                          test.edad.toString(),
                          test.telefono.toString(),
                          test.grado_instruccion.toString(),
                          test.procedencia.toString(),
                          test.religion.toString(),
                          sexoFormateado,
                        ];
                      }).toList(),
                    );
                  }),
                  // _buildHistoryTable(
                  //   [
                  //     'Fecha',
                  //     'Nombre completo',
                  //     'Estado civil',
                  //     'Fecha de Nacimiento',
                  //     'Edad',
                  //     'Telefono',
                  //     'Grado instruccion',
                  //     'Procedencia',
                  //     'Religion',
                  //     'Sexo'
                  //   ],
                  //   [
                  //     [
                  //       '12/09/2023',
                  //       'John Smith',
                  //       'Soltero',
                  //       '01/01/2000',
                  //       '23',
                  //       '77271791',
                  //       'Grado instruccion',
                  //       'Procedencia',
                  //       'Cateolica',
                  //       'Masculino'
                  //     ],
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalDataTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Peso (kg)',
                              controller: _controllerDF.pesoController,
                              onChanged: _calculateImc,
                              placeholder: 'Ej. 70')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Talla (cm)',
                              controller: _controllerDF.alturaController,
                              onChanged: _calculateImc,
                              placeholder: 'Ej. 175')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('IMC',
                              controller: _controllerDF.imcController,
                              enabled: false,
                              placeholder: 'Ej. 22.9')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Radio Abdominal',
                              controller: _controllerDF.radioAbdominalCivilController,
                              placeholder: 'Ej. 80 cm')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Grasa Visceral',
                              controller: _controllerDF.grasaVisceralController,
                              placeholder: 'Ej. 10')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Grasa Corporal (%)',
                              controller: _controllerDF.grasaCorporalController,
                              placeholder: 'Ej. 15%')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Porcebtaje Musculo (%)',
                              controller: _controllerDF.porcentajeMusculoController,
                              placeholder: 'Ej. 34,7%')),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _controllerDF.createDatosFisicos(widget.patientId);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_controllerDF.datosFisicos.isEmpty) {
                      return const Text('No hay registros disponibles.');
                    }
                    return _buildHistoryTable(
                      [
                        'Fecha',
                        'Tipo',
                        'Peso',
                        'Talla',
                        'IMC',
                        'Radio Abdominal',
                        'Grasa Visceral',
                        'Grasa Corporal',
                        'Porcentaje Musculo',
                      ],
                      _controllerDF.datosFisicos.map((test) {
                        String formattedDate = test.fecha != null 
                          ? DateFormat('dd/MM/yyyy').format(test.fecha!) 
                          : 'Fecha no disponible'; // Valor por defecto si es null
                        return [
                          formattedDate,
                          test.tipo.toString(),
                          '${test.peso} Kg',
                          '${test.altura} cm',
                          '${test.imc}',
                          '${test.radio_abdominal}',
                          '${test.grasa_visceral}',
                          '${test.grasa_corporal} %',
                          '${test.porcentaje_musculo} %',
                        ];
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignsTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Presión Sistólica',
                              controller: _controllerSV.presion_sistolicaController,
                              placeholder: 'Ej. 120')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Presión Diastólica',
                              controller: _controllerSV.presion_diastolicaController,
                              placeholder: 'Ej. 80')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Frecuencia Cardíaca',
                              controller: _controllerSV.frecuencia_cardiacaController,
                              placeholder: 'Ej. 72')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Frecuencia Respiratoria',
                              controller: _controllerSV.frecuencia_respiratoriaController,
                              placeholder: 'Ej. 16')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Temperatura',
                              controller: _controllerSV.temperaturaController,
                              placeholder: 'Ej. 34.6')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Saturacion Oxigeno',
                              controller: _controllerSV.saturacion_oxigenoController,
                              placeholder: 'Ej. 90')),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _controllerSV.createSignosVitales(widget.patientId);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ),

                  Obx(() {
                    if (_controllerSV.signosVitales.isEmpty) {
                      return const Text('No hay registros disponibles.');
                    }
                    return _buildHistoryTable(
                      [
                        'Fecha',
                        'Tipo',
                        'Presión Sistólica',
                        'Presión Diastólica',
                        'Frecuencia Cardíaca',
                        'Frecuencia Respiratoria',
                        'Temperatura',
                        'Saturacion Oxigeno',
                      ],
                      _controllerSV.signosVitales.map((test) {
                        String formattedDate = test.fecha != null 
                          ? DateFormat('dd/MM/yyyy').format(test.fecha!) 
                          : 'Fecha no disponible'; // Valor por defecto si es null
                        return [
                          formattedDate,
                          test.tipo.toString(),
                          '${test.presion_sistolica} mmHg',
                          '${test.presion_diastolica} mmHg',
                          '${test.frecuencia_cardiaca} bpm',
                          '${test.frecuencia_respiratoria} rpm',
                          '${test.temperatura} °C',
                          '${test.saturacion_oxigeno} %',
                        ];
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSamplesTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Colesterol HDL',
                              controller: _controllerDM.colesterol_hdlController,
                              placeholder: 'Ej. 50 mg/dL')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Colesterol LDL',
                              controller: _controllerDM.colesterol_ldlController,
                              placeholder: 'Ej. 100 mg/dL')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Colesterol Total',
                              controller: _controllerDM.colesterol_totalController,
                              placeholder: 'Ej. 50 mg/dL')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInputField('Glicemia Basal',
                              controller: _controllerDM.glicemia_basalController,
                              placeholder: 'Ej. 100 mg/dL')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Triglicéridos',
                              controller: _controllerDM.trigliceridosController,
                              placeholder: 'Ej. 150 mg/dL')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildInputField('Glucosa',
                              controller: _controllerDM.glucosaController,
                              placeholder: 'Ej. 90 mg/dL')),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _controllerDM.createDatosMuestras(widget.patientId);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_controllerDM.datosMuestras.isEmpty) {
                      return const Text('No hay registros disponibles.');
                    }
                    return _buildHistoryTable(
                      [
                        'Fecha',
                        'Tipo',
                        'Colesterol HDL',
                        'Colesterol LDL',
                        'Colesterol Total',
                        'Trigliceridos',
                        'Glucosa',
                        'Glicemia Basal',
                      ],
                      _controllerDM.datosMuestras.map((test) {
                        String formattedDate = test.fecha != null 
                          ? DateFormat('dd/MM/yyyy').format(test.fecha!) 
                          : 'Fecha no disponible'; // Valor por defecto si es null
                        return [
                          formattedDate,
                          test.tipo.toString(),
                          '${test.colesterol_hdl} mg/dL',
                          '${test.colesterol_ldl} mg/dL',
                          '${test.colesterol_total} mg/dL',
                          '${test.trigliceridos} mg/dL',
                          '${test.glucosa} mg/dL',
                          '${test.glicemia_basal} mg/dL',
                        ];
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildRufferTestTab() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        'Frecuencia Cardíaca en Reposo',
                        controller: _controllerTR.frecuencia_cardiaca_en_reposoController,
                        placeholder: 'Ej. 72 bpm',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        'Frecuencia Cardíaca a 45s',
                        controller: _controllerTR.frecuencia_cardiaca_despues_de_45_segundosController,
                        placeholder: 'Ej. 75 bpm',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        'Frecuencia Cardíaca a 1min',
                        controller: _controllerTR.frecuencia_cardiaca_1_minuto_despuesController,
                        placeholder: 'Ej. 76 bpm',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        'Resultado Test de Ruffer',
                        controller: _controllerTR.resultado_test_ruffierController,
                        placeholder: 'Ej. Positivo',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _controllerTR.createTestRuffier(widget.patientId);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Guardar'),
                    ),
                  ),
                ),

                Obx(() {
                  if (_controllerTR.testRuffier.isEmpty) {
                    return const Text('No hay registros disponibles.');
                  }
                  return _buildHistoryTable(
                    [
                      'Fecha',
                      'Tipo',
                      'Frecuencia en Reposo',
                      'Frecuencia a 45s',
                      'Frecuencia a 1min',
                      'Resultado Test de Ruffer',
                    ],
                    _controllerTR.testRuffier.map((test) {
                      String formattedDate = test.fecha != null 
                        ? DateFormat('dd/MM/yyyy').format(test.fecha!) 
                        : 'Fecha no disponible'; // Valor por defecto si es null
                      return [
                        formattedDate,
                        test.tipo.toString(),
                        '${test.frecuencia_cardiaca_en_reposo} bpm',
                        '${test.frecuencia_cardiaca_despues_de_45_segundos} bpm',
                        '${test.frecuencia_cardiaca_1_minuto_despues} bpm',
                        test.resultado_test_ruffier.toString(),
                      ];
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildInputField(String label,
      {TextEditingController? controller,
      Function(String)? onChanged,
      bool enabled = true,
      String? placeholder}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: '$label*',
          labelStyle: TextStyle(color: Colors.grey[800]),
          hintText: placeholder,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo, width: 2.0),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        onTap: () => _selectDate(context),
        readOnly: true,
        decoration: InputDecoration(
          labelText: '$label*',
          labelStyle: TextStyle(color: Colors.grey[800]),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo, width: 2.0),
          ),
        ),
      ),
    );
  }

Widget _buildGenderCheckbox(String label) {
  return CheckboxListTile(
    title: Text(label),
    value: _gender == label,
    onChanged: (value) {
      setState(() {
        // Actualiza el género seleccionado
        _gender = value == true ? label : 'Masculino';
        
        // Actualiza el controlador con 'M' o 'F'
        _controller.sexoController.text = (_gender == 'Masculino') ? 'M' : 'F';
      });
    },
    controlAffinity: ListTileControlAffinity.leading,
    activeColor: Colors.indigo,
  );
}

  Widget _buildHistoryTable(List<String> headers, List<List<String>> rows) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: 0, // Ajustamos el espacio entre columnas a 0
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.indigo[50]!),
                columns: headers
                    .map((header) => DataColumn(
                            label: Expanded(
                          // Expandimos las columnas
                          child: Text(
                            header,
                            style: TextStyle(color: Colors.indigo[900]),
                          ),
                        )))
                    .toList(),
                rows: rows
                    .map((row) => DataRow(
                          cells: row
                              .map((cell) => DataCell(
                                    Expanded(
                                      // Expandimos el contenido de las celdas
                                      child: Text(
                                        cell,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

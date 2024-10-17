import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/datos_personales_models.dart';
import 'package:flutter_web_dashboard/providers/datos_personales_providers.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';

class DatosPersonalesController extends GetxController {
  final TextEditingController nombresApellidosController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController estadoCivilController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController gradoInstruccionController = TextEditingController();
  final TextEditingController procedenciaController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  
  DatosPersonalesProviders datosPersonalesProviders = DatosPersonalesProviders();

    // Variable para almacenar el género seleccionado
  String _gender = '';
  
  String get gender => _gender;

  // Método para actualizar el género
  void updateGender(String value) {
    _gender = value;
    update();
  }

  var datosPersonales = <DatosPersonales>[].obs; // Lista observable de datos personales

  @override
  void onInit() {
    super.onInit();
    // listarDatosPersonales();
  }

  void createDatosPersonales(String usuario) async {
    String nombresApellidos = nombresApellidosController.text.trim();
    String sexo = sexoController.text.trim();
    int? edad = int.tryParse(edadController.text.trim());
    String estadoCivil = estadoCivilController.text.trim();
    DateTime? fechaNacimiento = DateTime.tryParse(fechaNacimientoController.text.trim());
    String telefono = telefonoController.text.trim();
    String gradoInstruccion = gradoInstruccionController.text.trim();
    String procedencia = procedenciaController.text.trim();
    String religion = religionController.text.trim();

  //     print("Nombres y Apellidos: $nombresApellidos");
  // print("Sexo: $sexo");
  // print("Edad: ${edad != null ? edad : 'No especificada'}");
  // print("Estado Civil: $estadoCivil");
  // print("Fecha de Nacimiento: ${fechaNacimiento != null ? fechaNacimiento.toLocal().toString().split(' ')[0] : 'No especificada'}");
  // print("Teléfono: $telefono");
  // print("Grado de Instrucción: $gradoInstruccion");
  // print("Procedencia: $procedencia");
  // print("Religión: $religion");

    if (nombresApellidos.isEmpty || sexo.isEmpty || edad == null || estadoCivil.isEmpty || 
        fechaNacimiento == null || telefono.isEmpty || gradoInstruccion.isEmpty || 
        procedencia.isEmpty || religion.isEmpty) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos');
      return;
    }

    DatosPersonales datos = DatosPersonales(
      nombres_apellidos: nombresApellidos,
      sexo: sexo,
      edad: edad,
      estado_civil: estadoCivil,
      fecha_nacimiento: fechaNacimiento,
      telefono: telefono,
      grado_instruccion: gradoInstruccion,
      procedencia: procedencia,
      religion: religion,
      fecha: DateTime.now(), // Fecha actual o puedes pasar una fecha específica
      usuario: usuario, // Cambia esto según el usuario autenticado
    );

    ResponseApi responseApi = await datosPersonalesProviders.create(datos);

    if (responseApi.success == true) {
      Get.snackbar('Registro exitoso', responseApi.message ?? '');
      listarDatosPersonales(usuario);
      _clearControllers();
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
    }
  }

  void updateDatosPersonales(int id) async {
    // Implementación similar a createDatosPersonales
    // Aquí solo necesitas recuperar los datos del controlador y actualizar el ID
  }

  void deleteDatosPersonales(int id) async {
    // Implementación como se explicó anteriormente
  }

  void listarDatosPersonales(String usuario) async {
    ResponseApi responseApi = await datosPersonalesProviders.getAll(usuario);
    if (responseApi.success == true) {
      datosPersonales.value = List<DatosPersonales>.from(responseApi.data);
      // print('Datos Personales: ${datosPersonales.value}');
    } else {
      print('Error al listar datos personales: ${responseApi.message}');
    }
  }

    void clearDatosPersodatos() {
    datosPersonales.clear(); // Limpia los datos anteriores
  }

    void _clearControllers() {
      // Método para limpiar los TextEditingControllers
      nombresApellidosController.clear();
      sexoController.clear();
      edadController.clear();
      estadoCivilController.clear();
      fechaNacimientoController.clear();
      telefonoController.clear();
      gradoInstruccionController.clear();
      procedenciaController.clear();
      religionController.clear();
  }
}

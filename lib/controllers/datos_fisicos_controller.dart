import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/datos_fisicos_model.dart';
import 'package:flutter_web_dashboard/providers/datos_fisicos_providers.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';

class DatosFisicosController extends GetxController {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController imcController = TextEditingController();
  final TextEditingController radioAbdominalCivilController = TextEditingController();
  final TextEditingController grasaVisceralController = TextEditingController();
  final TextEditingController grasaCorporalController = TextEditingController();
  final TextEditingController porcentajeMusculoController = TextEditingController();
  
  DatosFisicosProviders datosFisicosProviders = DatosFisicosProviders();

  var datosFisicos = <DatosFisicos>[].obs;

  @override
  void onInit() {
    super.onInit();
    // listarDatosFisicos();
  }

  void createDatosFisicos(String usuario) async {
    // Convertimos los valores a double, si no son válidos retornamos
    double? peso = double.tryParse(pesoController.text.trim());
    int? altura = int.tryParse(alturaController.text.trim());
    double? imc = double.tryParse(imcController.text.trim());
    double? radioAbdominal = double.tryParse(radioAbdominalCivilController.text.trim());
    double? grasaVisceral = double.tryParse(grasaVisceralController.text.trim());
    double? grasaCorporal = double.tryParse(grasaCorporalController.text.trim());
    double? porcentajeMusculo = double.tryParse(porcentajeMusculoController.text.trim());

    // Validamos que todos los campos estén llenos y sean válidos
    if (peso == null || altura == null || imc == null || radioAbdominal == null || 
        grasaVisceral == null || grasaCorporal == null || porcentajeMusculo == null) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos y ser válidos');
      return;
    }

    // Creamos el objeto DatosFisicos
    DatosFisicos datos = DatosFisicos(
      peso: peso,
      altura: altura,
      imc: imc,
      radio_abdominal: radioAbdominal,
      grasa_visceral: grasaVisceral,
      grasa_corporal: grasaCorporal,
      porcentaje_musculo: porcentajeMusculo,
      fecha: DateTime.now(), // Fecha actual o puedes pasar una fecha específica
      usuario: usuario, // Cambia esto según el usuario autenticado
    );

    // Llamamos al método de creación en el provider
    ResponseApi responseApi = await datosFisicosProviders.create(datos);

    if (responseApi.success == true) {
      Get.snackbar('Registro exitoso', responseApi.message ?? '');
      listarDatosFisicos(usuario);
      _clearControllers();
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
    }
  }

  void updateDatosFisicos(int id) async {
    // Implementación de la actualización similar a createDatosFisicos
  }

  void deleteDatosFisicos(int id) async {
    // Implementación del borrado
  }

  void listarDatosFisicos(String usuario) async {
    ResponseApi responseApi = await datosFisicosProviders.getAll(usuario);
    if (responseApi.success == true) {
      datosFisicos.value = List<DatosFisicos>.from(responseApi.data);
    } else {
      print('Error al listar datos Fisicos: ${responseApi.message}');
    }
  }

      void _clearControllers() {
    // Método para limpiar los TextEditingControllers
    pesoController.clear();
    alturaController.clear();
    imcController.clear();
    radioAbdominalCivilController.clear();
    grasaCorporalController.clear();
    grasaVisceralController.clear();
    porcentajeMusculoController.clear();
  }

  void clearDatosFisicos() {
    datosFisicos.clear(); // Limpia los datos anteriores
  }
}

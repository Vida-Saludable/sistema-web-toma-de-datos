// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/test_ruffier_model.dart';
import 'package:flutter_web_dashboard/providers/test_ruffier_provider.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';

class TestRuffierController extends GetxController {
  final TextEditingController frecuencia_cardiaca_en_reposoController = TextEditingController();
  final TextEditingController frecuencia_cardiaca_despues_de_45_segundosController = TextEditingController();
  final TextEditingController frecuencia_cardiaca_1_minuto_despuesController = TextEditingController();
  final TextEditingController resultado_test_ruffierController = TextEditingController();

  TestRuffierProviders testRuffierProviders = TestRuffierProviders();

  var testRuffier = <TestRuffier>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Puedes listar los test de Ruffier al iniciar el controlador
    // listarTestRuffier('usuarioId'); // Pasa el usuarioId apropiado aquí
  }

  void createTestRuffier(String usuario) async {
    // Convertimos los valores a int y double, si no son válidos retornamos
    int? frecuencia_cardiaca_en_reposo = int.tryParse(frecuencia_cardiaca_en_reposoController.text.trim());
    int? frecuencia_cardiaca_despues_de_45_segundos = int.tryParse(frecuencia_cardiaca_despues_de_45_segundosController.text.trim());
    int? frecuencia_cardiaca_1_minuto_despues = int.tryParse(frecuencia_cardiaca_1_minuto_despuesController.text.trim());
    double? resultado_test_ruffier = double.tryParse(resultado_test_ruffierController.text.trim());

    // Validamos que todos los campos estén llenos y sean válidos
    if (frecuencia_cardiaca_en_reposo == null || frecuencia_cardiaca_despues_de_45_segundos == null || frecuencia_cardiaca_1_minuto_despues == null || 
        resultado_test_ruffier == null) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos y ser válidos');
      return;
    }

    // Creamos el objeto TestRuffier
    TestRuffier datos = TestRuffier(
      frecuencia_cardiaca_en_reposo: frecuencia_cardiaca_en_reposo,
      frecuencia_cardiaca_despues_de_45_segundos: frecuencia_cardiaca_despues_de_45_segundos,
      frecuencia_cardiaca_1_minuto_despues: frecuencia_cardiaca_1_minuto_despues,
      resultado_test_ruffier: resultado_test_ruffier,
      fecha: DateTime.now(), // Fecha actual o puedes pasar una fecha específica
      usuario: usuario, // Cambia esto según el usuario autenticado
    );

    // Llamamos al método de creación en el provider
    ResponseApi responseApi = await testRuffierProviders.create(datos);

    if (responseApi.success == true) {
      Get.snackbar('Registro exitoso', responseApi.message ?? '');
      listarTestRuffier(usuario);
      _clearControllers(); // Limpiar los controladores después de un registro exitoso
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
    }
  }

  void updateTestRuffier(int id) async {
    // Implementación de la actualización similar a createTestRuffier
  }

  void deleteTestRuffier(int id) async {
    // Implementación del borrado
  }

  void listarTestRuffier(String usuario) async {
    ResponseApi responseApi = await testRuffierProviders.getAll(usuario);
    if (responseApi.success == true) {
      testRuffier.value = List<TestRuffier>.from(responseApi.data);
      print('Lista TestRuffier: ${testRuffier}');
    } else {
      print('Error al listar TestRuffier: ${responseApi.message}');
    }
  }



  void _clearControllers() {
    // Método para limpiar los TextEditingControllers
    frecuencia_cardiaca_en_reposoController.clear();
    frecuencia_cardiaca_despues_de_45_segundosController.clear();
    frecuencia_cardiaca_1_minuto_despuesController.clear();
    resultado_test_ruffierController.clear();
  }

    void clearTestRuffier() {
    testRuffier.clear(); // Limpia los datos anteriores
  }
}

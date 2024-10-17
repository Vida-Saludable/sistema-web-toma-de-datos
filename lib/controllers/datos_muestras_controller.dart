import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/datos_muestras_model.dart';
import 'package:flutter_web_dashboard/providers/datos_muestras_provider.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';

class DatosMuestrasController extends GetxController {
  final TextEditingController colesterol_totalController = TextEditingController();
  final TextEditingController colesterol_hdlController = TextEditingController();
  final TextEditingController colesterol_ldlController = TextEditingController();
  final TextEditingController trigliceridosController = TextEditingController();
  final TextEditingController glucosaController = TextEditingController();
  final TextEditingController glicemia_basalController = TextEditingController();
  
  DatosMuestrasProviders datosMuestrasProviders = DatosMuestrasProviders();

  var datosMuestras = <DatosMuestras>[].obs;

  @override
  void onInit() {
    super.onInit();
    // listarDatosMuestras();
  }

  void createDatosMuestras(String usuario) async {
    // Convertimos los valores a double, si no son válidos retornamos
    double? colesterol_total = double.tryParse(colesterol_totalController.text.trim());
    double? colesterol_hdl = double.tryParse(colesterol_hdlController.text.trim());
    double? colesterol_ldl = double.tryParse(colesterol_ldlController.text.trim());
    double? trigliceridos = double.tryParse(trigliceridosController.text.trim());
    double? glucosa = double.tryParse(glucosaController.text.trim());
    double? glicemia_basal = double.tryParse(glicemia_basalController.text.trim());

    // Validamos que todos los campos estén llenos y sean válidos
    if (colesterol_total == null || colesterol_hdl == null || colesterol_ldl == null || trigliceridos == null || 
        glucosa == null || glicemia_basal == null) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos y ser válidos');
      return;
    }

    // Creamos el objeto DatosMuestras
    DatosMuestras datos = DatosMuestras(
      colesterol_total: colesterol_total,
      colesterol_hdl: colesterol_hdl,
      colesterol_ldl: colesterol_ldl,
      trigliceridos: trigliceridos,
      glucosa: glucosa,
      glicemia_basal: glicemia_basal,
      fecha: DateTime.now(), // Fecha actual o puedes pasar una fecha específica
      usuario: usuario, // Cambia esto según el usuario autenticado
    );

    // Llamamos al método de creación en el provider
    ResponseApi responseApi = await datosMuestrasProviders.create(datos);

    if (responseApi.success == true) {
      Get.snackbar('Registro exitoso', responseApi.message ?? '');
      listarDatosMuestras(usuario);
      _clearControllers();
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
    }
  }

  void updateDatosMuestras(int id) async {
    // Implementación de la actualización similar a createDatosMuestras
  }

  void deleteDatosMuestras(int id) async {
    // Implementación del borrado
  }

  void listarDatosMuestras(String usuario) async {
    ResponseApi responseApi = await datosMuestrasProviders.getAll(usuario);
    if (responseApi.success == true) {
      datosMuestras.value = List<DatosMuestras>.from(responseApi.data);
    } else {
      print('Error al listar datos Muestras: ${responseApi.message}');
    }
  }

    void _clearControllers() {
    // Método para limpiar los TextEditingControllers
    colesterol_totalController.clear();
    colesterol_hdlController.clear();
    colesterol_ldlController.clear();
    glucosaController.clear();
    glicemia_basalController.clear();
    trigliceridosController.clear();
  }

    void clearDatosMuestras() {
    datosMuestras.clear(); // Limpia los datos anteriores
  }
}

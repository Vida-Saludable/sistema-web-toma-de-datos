import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/signos_vitales_model.dart';
import 'package:flutter_web_dashboard/providers/signos_vitales_provider.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';

class SignosVitalesController extends GetxController {
  final TextEditingController presion_sistolicaController = TextEditingController();
  final TextEditingController presion_diastolicaController = TextEditingController();
  final TextEditingController frecuencia_cardiacaController = TextEditingController();
  final TextEditingController frecuencia_respiratoriaController = TextEditingController();
  final TextEditingController temperaturaController = TextEditingController();
  final TextEditingController saturacion_oxigenoController = TextEditingController();
  
  SignosVitalesProviders signosVitalesProviders = SignosVitalesProviders();

  var signosVitales = <SignosVitales>[].obs;

  @override
  void onInit() {
    super.onInit();
    // listarSignosVitales();
  }

  void createSignosVitales(String usuario) async {
    // Convertimos los valores a double, si no son válidos retornamos
    int? presion_sistolica = int.tryParse(presion_sistolicaController.text.trim());
    int? presion_diastolica = int.tryParse(presion_diastolicaController.text.trim());
    int? frecuencia_cardiaca = int.tryParse(frecuencia_cardiacaController.text.trim());
    int? frecuencia_respiratoria = int.tryParse(frecuencia_respiratoriaController.text.trim());
    double? temperatura = double.tryParse(temperaturaController.text.trim());
    int? saturacion_oxigeno = int.tryParse(saturacion_oxigenoController.text.trim());

    // Validamos que todos los campos estén llenos y sean válidos
    if (presion_sistolica == null || presion_diastolica == null || frecuencia_cardiaca == null || frecuencia_respiratoria == null || 
        temperatura == null || saturacion_oxigeno == null) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos y ser válidos');
      return;
    }

    // Creamos el objeto SignosVitales
    SignosVitales datos = SignosVitales(
      presion_sistolica: presion_sistolica,
      presion_diastolica: presion_diastolica,
      frecuencia_cardiaca: frecuencia_cardiaca,
      frecuencia_respiratoria: frecuencia_respiratoria,
      temperatura: temperatura,
      saturacion_oxigeno: saturacion_oxigeno,
      fecha: DateTime.now(), // Fecha actual o puedes pasar una fecha específica
      usuario: usuario, // Cambia esto según el usuario autenticado
    );

    // Llamamos al método de creación en el provider
    ResponseApi responseApi = await signosVitalesProviders.create(datos);

    if (responseApi.success == true) {
      Get.snackbar('Registro exitoso', responseApi.message ?? '');
      listarSignosVitales(usuario);
      _clearControllers();
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
    }
  }

  void updateSignosVitales(int id) async {
    // Implementación de la actualización similar a createSignosVitales
  }

  void deleteSignosVitales(int id) async {
    // Implementación del borrado
  }

  void listarSignosVitales(String usuario) async {
    ResponseApi responseApi = await signosVitalesProviders.getAll(usuario);
    if (responseApi.success == true) {
      signosVitales.value = List<SignosVitales>.from(responseApi.data);
    } else {
      print('Error al listar Signos Vitales: ${responseApi.message}');
    }
  }
  void _clearControllers() {
    // Método para limpiar los TextEditingControllers
    presion_sistolicaController.clear();
    presion_diastolicaController.clear();
    frecuencia_cardiacaController.clear();
    frecuencia_respiratoriaController.clear();
    temperaturaController.clear();
    saturacion_oxigenoController.clear();
  }

    void clearSignosVitales() {
    signosVitales.clear(); // Limpia los datos anteriores
  }
}
